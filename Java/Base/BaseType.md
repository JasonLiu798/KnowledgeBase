#基本类型


#String
## intern
[深入解析String#intern](https://tech.meituan.com/in_depth_understanding_string_intern.html)
[Save Memory by Using String Intern in Java](https://blog.codecentric.de/en/2012/03/save-memory-by-using-string-intern-in-java/)


如果常量池中存在当前字符串, 就会直接返回当前字符串. 如果常量池中没有此字符串, 会将此字符串放入常量池中后, 再返回

```java
public static void main(String[] args) {
    String s = new String("1");
    s.intern();
    String s2 = "1";
    System.out.println(s == s2);

    String s3 = new String("1") + new String("1");
    s3.intern();
    String s4 = "11";
    System.out.println(s3 == s4);
}
/**
 * 打印结果为：
 * jdk6 下false false
 * jdk7 下false true
 */

public static void main(String[] args) {
    String s = new String("1");
    String s2 = "1";
    s.intern();
    System.out.println(s == s2);

    String s3 = new String("1") + new String("1");
    String s4 = "11";
    s3.intern();
    System.out.println(s3 == s4);
}
/**
 * 打印结果为：
 * jdk6 下false false
 * jdk7 下false false
 */
```

jdk6中的常量池是放在 Perm 区中的，Perm 区和正常的 JAVA Heap 区域是完全分开的。
即使调用String.intern方法也是没有任何关系的

jdk7 的版本中，字符串常量池已经从 Perm 区移到正常的 Java Heap 区域了。为什么要移动，Perm 区域太小是一个主要原因，当然据消息称 jdk8 已经直接取消了 Perm 区域，而新建立了一个元区域。应该是 jdk 开发者认为 Perm 区域已经不适合现在 JAVA 的发展了。



































