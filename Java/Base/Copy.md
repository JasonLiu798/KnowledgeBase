
# 对象拷贝类PropertyUtils，BeanUtils，BeanCopier
## 功能简介
业务系统中经常需要两个对象进行属性的拷贝，不能否认逐个的对象拷贝是最快速最安全的做法，但是当数据对象的属性字段数量超过程序员的容忍的程度，代码因此变得臃肿不堪，使用一些方便的对象拷贝工具类将是很好的选择。

## 目前流行的较为公用认可的工具类
### Apache的两个版本：（反射机制）
org.apache.commons.beanutils.PropertyUtils.copyProperties(Object dest, Object orig)
org.apache.commons.beanutils.BeanUtils.copyProperties(Object dest, Object orig)
### Spring版本：（反射机制）
org.springframework.beans.BeanUtils.copyProperties(Object source, Object target, Class editable, String[] ignoreProperties)
### cglib版本：（使用动态代理，效率高）
net.sf.cglib.beans.BeanCopier.copy(Object paramObject1, Object paramObject2, Converter paramConverter)

## 原理简介
### 反射类型：（apache）
都使用静态类调用，最终转化虚拟机中两个单例的工具对象
```java
public BeanUtilsBean()
{
  this(new ConvertUtilsBean(), new PropertyUtilsBean());
}
ConvertUtilsBean 可以通过ConvertUtils全局自定义注册。
ConvertUtils.register(new DateConvert(), java.util.Date.class);
```
PropertyUtilsBean 的copyProperties方法实现了拷贝的算法。
1、动态bean： orig instanceof DynaBean：Object value = ((DynaBean)orig).get(name);然后把value复制到动态bean类
2、Map类型：orig instanceof Map：key值逐个拷贝
3、其他普通类：：从beanInfo【每一个对象都有一个缓存的bean信息，包含属性字段等】取出name，然后把sourceClass和targetClass逐个拷贝

### Cglib类型：BeanCopier
copier = BeanCopier.create(source.getClass(), target.getClass(), false);
copier.copy(source, target, null);
 
Create对象过程：产生sourceClass-》TargetClass的拷贝代理类，放入jvm中，所以创建的代理类的时候比较耗时。最好保证这个对象的单例模式，可以参照最后一部分的优化方案。
创建过程：源代码见jdk：net.sf.cglib.beans.BeanCopier.Generator.generateClass(ClassVisitor)
1、  获取sourceClass的所有public get 方法-》PropertyDescriptor[] getters
2、  获取TargetClass 的所有 public set 方法-》PropertyDescriptor[] setters
3、  遍历setters的每一个属性，执行4和5
4、  按setters的name生成sourceClass的所有setter方法-》PropertyDescriptor getter【不符合javabean规范的类将会可能出现空指针异常】
5、  PropertyDescriptor[] setters-》PropertyDescriptor setter
6、  将setter和getter名字和类型 配对，生成代理类的拷贝方法。
Copy属性过程：调用生成的代理类，代理类的代码和手工操作的代码很类似，效率非常高

## 缺陷预防
陷阱条件 | Apache-PropertyUtils | Apache-BeanUtils | Spring-BeanUtils | Cglib-
BeanCopier 
---------|----------------------|------------------|------------------|------------------
是否可扩展useConvete功能 | NO | Yes | Yes | Yes，但比较难用 
src,tgt 顺序 | 逆序 | 逆序 | OK | OK 
对src特殊属性的限制：(Date,BigDec..）| OK | NO，异常出错 | OK | OK 
相同属性名，且类型不匹配时候的处理 | 异常，拷贝部分属性,非常危险 | OK，并能进行初级转换，Long和Integer互转 | 异常，拷贝部分属性 | OK，但是该属性不拷贝
Get和set方法不匹配的处理 | OK | OK | OK | 创建拷贝的时候报错，无法拷贝任何属性（当且仅当sourceClass的get方法超过set方法）

### 备注1  对targetObject特殊属性的限制：(Date，BigDecimal等）
原因：dateTimeConveter的conveter没有对null值的处理
```java
public class ErrorBeanUtilObject { //此处省略getter，setter方法
    private String name;
    private java.util.Date date;
}
 public class ErrorBeanUtilsTest {  
    public static void main(String args[]) throws Throwable  {  
    ErrorBeanUtilObject from = new ErrorBeanUtilObject(); 
    ErrorBeanUtilObject to = new ErrorBeanUtilObject();  
    //from.setDate(new java.util.Date());
    from.setName("TTTT");
    org.apache.commons.beanutils.BeanUtils.copyProperties(to, from);//如果from.setDate去掉，此处出现conveter异常
    System.out.println(ToStringBuilder.reflectionToString(from));
    System.out.println(ToStringBuilder.reflectionToString(to));
    }  
}
```

### 备注2  相同属性名，且类型不匹配时候的处理
原因：这两个工具类不支持同名异类型的匹配 !!!【包装类Long和原始数据类型long是可以的】
public class TargetClass {  //此处省略getter，setter方法
    private Long num;  
    private String name;
}
public class TargetClass {  //此处省略getter，setter方法
    private Long num;
    private String name;
}
public class ErrorPropertyUtilsTest {        
    public static void main(String args[]) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException  {  
        SourceClass from = new SourceClass();  
        from.setNum(1);
        from.setName("name"); 
        TargetClass to = new TargetClass();  
        org.apache.commons.beanutils.PropertyUtils.copyProperties(to, from); //抛出参数不匹配异常
        org.springframework.beans.BeanUtils.copyProperties(from, to);
//抛出参数不匹配异常
        System.out.println(ToStringBuilder.reflectionToString(from));    
        System.out.println(ToStringBuilder.reflectionToString(to));  
    }  
}
 
### 备注3  Get和set方法不匹配的处理
public class ErrorBeanCopierTest {    
    /**
     * 从该用例看出BeanCopier.create的target.class 的每一个get方法必须有队形的set方法
     * @param args
     */
    public static void main(String args[]) {  
        BeanCopier copier = BeanCopier.create(UnSatifisedBeanCopierObject.class, SourceClass.class,false);
        copier = BeanCopier.create(SourceClass.class, UnSatifisedBeanCopierObject.class, false); //此处抛出异常创建 
    }  
}
class UnSatifisedBeanCopierObject {   
    private String name;
    private Long num;
    public String getName() {
       return name;
    }
    public void setName(String name) {
       this.name = name;
    }
    public Long getNum() {
       return num;
    }
//  public void setNum(Long num) {
//     this.num = num;
//  }
}
 
## 优化方案
### 一些优化和改进
增强apache的beanUtils的拷贝属性，注册一些新的类型转换
public class BeanUtilsEx extends BeanUtils
{
  public static void copyProperties(Object dest, Object orig)
  {
    try
    {
      BeanUtils.copyProperties(dest, orig);
    } catch (IllegalAccessException ex) {
      ex.printStackTrace();
    } catch (InvocationTargetException ex) {
      ex.printStackTrace();
    }
  }
  static
  {
    ConvertUtils.register(new DateConvert(), java.util.Date.class);
    ConvertUtils.register(new DateConvert(), java.sql.Date.class);
    ConvertUtils.register(new BigDecimalConvert(), BigDecimal.class);
  }
}
将beancopier做成静态类，方便拷贝
public class BeanCopierUtils {
     public static Map<String,BeanCopier> beanCopierMap = new HashMap<String,BeanCopier>();
    
     public static void copyProperties(Object source, Object target){
         String beanKey =  generateKey(source.getClass(), target.getClass());
         BeanCopier copier =  null;
         if(!beanCopierMap.containsKey(beanKey)){
              copier = BeanCopier.create(source.getClass(), target.getClass(), false);
              beanCopierMap.put(beanKey, copier);
         }else{
              copier = beanCopierMap.get(beanKey);
         }
         copier.copy(source, target, null);
     }   
     private static String generateKey(Class<?> class1,Class<?>class2){
         return class1.toString() + class2.toString();
     }
}
修复beanCopier对set方法强限制的约束
改写net.sf.cglib.beans.BeanCopier.Generator.generateClass(ClassVisitor)方法
将133行的
MethodInfo write = ReflectUtils.getMethodInfo(setter.getWriteMethod());
预先存一个names2放入
/* 109 */       Map names2 = new HashMap();
/* 110 */       for (int i = 0; i < getters.length; ++i) {
/* 111 */         names2.put(setters[i].getName(), getters[i]);
/*     */       }
调用这行代码前判断查询下，如果没有改writeMethod则忽略掉该字段的操作，这样就可以避免异常的发生。
