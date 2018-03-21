



# double
## Java中double类型比较大小或相等的方法
在Java中int类型数据的大小比较可以使用双等号，double类型则不能使用双等号来比较大小，如果使用的话得到的结果将永远是不相等，即使两者的精度是相同的也不可以。下面介绍两种比较double数据是否相等的方法。

第一种方法：转换成字符串

如果要比较的两个double数据的字符串精度相等，可以将数据转换成string然后借助string的equals方法来间接实现比较两个double数据是否相等。注意这种方法只适用于比较精度相同的数据，并且是只用用于比较是否相等的情况下，不能用来判断大小。

第二种方法：使用sun提供的Double.doubleToLongBits()方法

该方法可以将double转换成long型数据，从而可以使double按照long的方法（<, >, ==）判断是否大小和是否相等。

例如：
```java
Double.doubleToLongBits(0.01) == Double.doubleToLongBits(0.01)   
Double.doubleToLongBits(0.02) > Double.doubleToLongBits(0.01)   
Double.doubleToLongBits(0.02) < Double.doubleToLongBits(0.01)   
```






















