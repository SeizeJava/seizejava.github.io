# Java 语法基础

## 数据类型

### 类型大小

类型代表了数据的结构和功能。

#### 整型和浮点型

整型大小

| long | int  | short | byte |
| ---- | ---- | ----- | ---- |
| 8    | 4    | 2     | 1    |

由于 Java 是平台无关语言，因此整数范围与运行代码的机器无关。

| double | float |
| ------ | ----- |
| 8      | 4     |

带小数点的字面量会自动转换为 double 。

#### char 型

一个 char 类型占两字节，但由于后来 Unicode 扩充，（在 20世纪80年代开始 Java 设计工作时，人们认为两个字节的代码宽度足以对世界上各种语言的所有字符进行编码，并有足够的空间留给未来的扩展，结果后来全世界都有不同的编码，而且两字节是装不下的）现在 Unicode 标准已经扩展到包含多达 1112064 个字符，那些超出原来的 16 位限制的字符被称作增补字符。

Java 是怎么扩展的？同时可以看看这个 [字符编码笔记：ASCII，Unicode 和 UTF-8](http://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)

Unicode 基本字符用一个 char 型表示。Unicode 增补字符用**一对** char 型表示。码点（code point ) 是指与一个编码表中的某个字符对应的代码值。在 Unicode标准中， 码点采用十六进制书写，并加上前缀 U+, 例如 U+0041 就是拉丁字母 A 的码点。

基本字符表示从 U+0000 到 U+FFFF 之间的字符集，也被成为基本多语言级别（BMP, basic multilingual plane)。码点从 U+0000 到 U+FFFF。增补字符表示从 U+10000 到 U+10FFFF 范围之间的字符集，也就是原来的 16 位设计无法表示的字符。

char 类型描述了 UTF-16编码中的一个代码单元。 **建议不要在程序中使用 char 类型**，除非确实需要处理 UTF-16 代码单元，否则最好将字符串作为抽象数据类型处理。

> UTF-8 最大的一个特点，就是它是一种变长的编码方式。它可以使用1~4个字节表示一个符号，根据不同的符号而变化字节长度。
>
> UTF-8 的编码规则很简单，只有二条：
>
> 1）对于单字节的符号，字节的第一位设为`0`，后面7位为这个符号的 Unicode 码。因此对于英语字母，UTF-8 编码和 ASCII 码是相同的。
>
> 2）对于`n`字节的符号（`n > 1`），第一个字节的前`n`位都设为`1`，第`n + 1`位设为`0`，后面字节的前两位一律设为`10`。剩下的没有提及的二进制位，全部为这个符号的 Unicode 码。

##### char 字符在 Java 中的运算

```java
char ch = 'a';
System.out.println(ch + 1);	// 98
System.out.println(++ch);	// b
```
为什么会有这种结果？

char 是一种数值类型，Java 的**向上兼容**方向是 char->short->int->long->float->double ，`ch + 1` 生成一个新变量会造成类型提升，转换成 int 型。`++ch` 则还是在 char 变量里面累加。

#### boolean 类型

boolean 类型有两个值：false 和 true，用来判定逻辑条件，不同于 C++ 整型值和布尔值之间不能进行相互转换。

#### 自动类型推导

Java 11 增加了变量的自动类型推导，在编译期间会自动推断实际类型，其编译后的字节码和实际类型一致。

```java
var str = "test";
System.out.println(str);	
//test
//就相当于
String str = "test";
```

#### 为什么 main 方法是静态的（static）、公有的（public）、没有返回值（void）？

1. **static** 如果 main 方法不声明为静态的，JVM 就必须创建 main 类的实例，因为构造器可以被重载，JVM 就没法确定调用哪个 main 方法。静态方法和静态数据加载到内存，可以直接调用，而不需要像实例方法一样创建实例后才能调用，如果 main 方法是静态的，那么它就会被加载到 JVM 上下文中成为可执行的方法。

2. **public** Java 指定了一些可访问的修饰符如：private、protected、public，任何方法或变量都可以声明为 public，Java 可以从该类之外的地方访问。因为 main 方法是公共的，JVM 就可以轻松的访问执行它。
3. **void** Java 有 Runtime 库的帮忙，程序结束（不管是正常还是非正常情况）自动返回状态，而 C 语言没有这种机制（只有很小的 runtime），只能直接 return 。runtime 是 运行期所必需的东西，一般是一门语言中实现其特性的基础设施。

## 变量

变量是内存的别名。

### 初始化

不同于 C++， Java 的声明和定义没有区别。声明一个变量之后，必须用赋值语句对变量进行显式初始化，否则编译器报错。

```java
char ch = 't';
// or
char ch;
ch = 't';
```

**变量最好是使用前声明。**

### 常量

常量名使用全大写，只能被赋值一次。最好是声明时赋值：

```java
final double EPS = 1e-10;
```

类常量的定义位于方法外部。因此，在同一个类的其他方法中也可以使用这个常量。同时我们也可以在类中新建 public 常量，供其他类调用。

### 枚举类型

有时候我们需要将取值限制在一个集合里，例如手机大小有小杯，中杯、大杯、超大杯。（视为一个类，写在最外层）

```java
enum Mobile{
    MINI, PRO, PRO_PLUS, ULTIMATE;
}
```

我们就可以在其他类里调用这个类型：

```java
Mobile iPhone = Mobile.MINI;
```

### 字符串

Java 没有内置的字符串类型，而在标准 Java 类库中提供了 一个预定义类 String 。每个用双引号括起来的字符串都是 String 类的一个实例：

#### 字符串操作

```java
String str = "hello";
/*
*	[0, 4) 左闭右开的区间下的子串，substring
*/
System.out.println(str.substring(0, 4));	
//hell

/*
*	连接字符串，concat 或者 +
*/
System.out.println(str.concat(", world!"));	
//hello, world
System.out.println(str + " world!");	
//hello, world

/*
*	用分隔符连接字符串，join
*/
System.out.println(String.join(" / ", "PRO", "PRO PLUS", "ULTIMATE"));
//PRO / PRO PLUS / ULTIMATE

/*
*	判断字符串相等，equals，不可以用 ==，前者是比较字符串的值，后者是比较是否是同一对象。
*/
String a = "hello";
String b = "hello1";
String c= b.substring(0, 5);
System.out.println(a.equals(c));
//	true
System.out.println(a == c);
//	false

/*
*	当他们使用的是同一块内存时，== 才会为真。
*/	
String a = "hello";
String b = a;
System.out.println(System.identityHashCode(a));
System.out.println(System.identityHashCode(b));
System.out.println(a == b);
//488970385
//488970385
//true

/*
*	判断字符串为空，先判断是不是 null，再判断是不是空字符串。
*/
//	equals
if(null == str || "".equals(str)){
    System.out.println("string is empty.");
}
//	或者 length()
if(null == str || str.length() == 0){
    System.out.println("string is empty.");
}


```
还有

```java
int indexOf( int cp, int fromlndex )
    //返回与字符串 str 或代码点 cp 匹配的第一个子串的开始位置。这个位置从索引 0 或 fromlndex 开始计算。如果在原始串中不存在 str，返回 -1
    
String replace( CharSequence oldString,CharSequence newString) 
    //返回一个新字符串。这个字符串用newString 代替原始字符串中所有的 oldString。可 以用 String 或 StringBuilder 对象作为 CharSequence 参数。
    
String toLowerCase()
String toUpperCase() 
    //返回一个新字符串。这个字符串将原始字符串中的大写字母改为小写，或者将原始字 符串中的所有小写字母改成了大写字母。
    
String trim() 
    //返回一个新字符串。这个字符串将删除了原始字符串头部和尾部的空格。
```

String 源自于 java.lang.String ，更多操作在 [API 文档](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/String.html) 里。

#### 字符串是不可变的

这一点和 python 是一样的，Java 的字符串不可以去修改。只能开辟新内存，存放新的字符串。但 Java 会共享相同字符串的内存。

```java
String str = "hello";
System.out.println(System.identityHashCode(str));
//	488970385
str = "oh my gosh!";
System.out.println(System.identityHashCode(str));
//	1209271652
//	赋值后，内存地址不同
```

### 类型转换

#### 隐式类型转换

我们有时候会将一种数值类型转换为另一种数值类型。下图都是数值类型。

比如 `98.1 + 1` double 型和 int 型运算自动提升为最高的 double 型。下图展示了数据类型的提升方向。

<img src="https://gitee.com/xrandx/blog-figurebed/raw/master/img/20210412162955.png" alt="{B8B57EB9-023E-4B93-BE60-DFD886BC63BA}" style="zoom:50%;" />

#### 显式类型转换

刚才的转换是编译器自动给出的，我们可以明确指出让编译器去转换为某种类型。

```java
int a = (int)98.5;
System.out.println(a); 	// 98
```

int 转 double 是直接将小数点后的数字截断。

```java
int a = (int) Math.round(98.5);
System.out.println(a);	//	99
```

利用 Math.round 进行四舍五入操作，返回 long 类型。若从 long 转换为 int ，也要显式地转换，不然可能会丢失数据。

提升数据类型一般不会损失数据，降低却可能会损失。

## 运算符

### 数学运算

使用算术运算符`+ - * / %`表示加、减、乘、除、取模运算。

整数被 0 除将会产生一个异常 `/ by zero`，而浮点数被 0 除将会得到 `Infinity` 或 `NaN` 结果。

### 自增、自减

```java
int a = 1, b = 1;
System.out.println(a++);    // 1
System.out.println(++b); 	// 2
```

++ 在前则最先运算，在后则最后运算。

建议不要在表达式中使用这类运算符，除非你是搞 ACM 的。

### 逻辑关系运算

和 C / C++ 一样的。

数值比较：`== != > < >= <= `

逻辑运算：

`&& || !` 代表与、或、非。

支持短路表达：从左到右，当 `&&` 遇到了 `false` 就返回 `false`，`||` 遇到 `true` 是同理。

三元表达式：

`condition ? expression1: expression2`

`condition `的真假决定了返回 `expression1` 还是 `expression2`。

### 位运算符

`& | ^ ~` 代表与、或、异或、非。

还有`<<` `>>`运算符将位左移或右移，左移n位就相当于乘以2的n次方，右移n位就相当于除以2的n次方。

```java
int a = 1 << 3;
//	8
System.out.println(a);
System.out.println(a >> 2);
//	2
```

`>>>` 会用 0 填充空位，`>>` 会填充符合位。不存在 <<< 。

## 输入输出

```java
Scanner in = new Scanner(System.in);
String str_in = in.next();
//输入 oh, 42!
System.out.println("echo:" + str_in);
//输出 echo:oh, 42!
```

### 输入的 API

源自于 [java.util.Scanner](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/util/Scanner.html) 

```java
	Scanner(InputStream in);
        //用给定的输人流创建一个 Scanner对象。
    String nextLine() 
        //读取输入的下一行内容。
    String next() 
        //读取输入的下一个单词（以空格作为分隔符)。

    int nextlnt() 
    double nextDouble() 
        //读取并转换下一个表示整数或浮点数的字符序列。

    boolean hasNext() 
        //检测输入中是否还有其他单词。 
        
    boolean hasNextInt() 
    boolean hasNextDouble()
        //检测是否还有表示整数或浮点数的下一个字符序列。
```

用 Console 更适合在控制台输入输出（源自 [java.io.Console](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/io/Console.html)）

### 格式化输出

有和 C 类似的 printf 函数，来自于 [java.io.PrintStream](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/io/PrintStream.html) ：

```java
System.out.printf("%.2f", 10000.0 / 3.0);
//	3333.33
```

类似的，构造字符串：

```java
String message = String.format("Hello, %s, Next year , you'll be %d", name, age) ;
```

### 文件输入输出

建议使用 **java.nio.file.Files** ，用 Files 写入字符串：

```java
Path path = Paths.get("output.txt");
String contents = "Hello";
try {
    Files.writeString(path, contents, StandardCharsets.UTF_8);
} catch (IOException ex) {
    // Handle exception
}
```

用 `FileWriter `写入字符串：

```java
try(FileWriter writer = new FileWriter("output.txt")) {
    writer.write("This text was written with a FileWriter");
}
catch(IOException e){
    // Handle the exception
}

```

用 Files 读取

```java
String file = "output.txt";
Path path = Paths.get(file);
String content = Files.readString(path, StandardCharsets.UTF_8);
System.out.println(content);
```

## 流程控制

### 作用域

一个块可以嵌入另一个块，但两者不能声明同名的变量。

### 条件判断

#### if-else

建议最好用大括号，增强可读性。

```java
if (condition1) {
    statement1;
}
else if(condition1){
    statement2;
}
else{
    statement3;
}
```

#### switch

switch 就像电路，没有 break 就继续流动。

```java
int option = 1;
switch (option) {
    case 1:
    case 2:
        System.out.println("1 or 2");
        break;
    case 3:
        System.out.println("3");
        break;
    default:
        System.out.println("default");
}
//输出 1 or 2
```

若 `option = 9` ，则输出 default 。

case 标签可以是：

-  char, byte, short, int 的常量表达式。

- 枚举常量

- 字符串字面量

从 Java 14 开始，`switch`语句升级为更简洁的表达式语法，保证只有一种路径会被执行，并且不需要`break`语句：

```java
int option = 1;
switch (option) {
    case 1-> System.out.println("1 or 2");
    case 2-> System.out.println("1 or 2");
    case 3-> System.out.println("3");
    default->System.out.println("default");
}
```

### 循环

在循环语句中，我们可以通过 `break` 语句退出循环，一般常常和 if-else 搭配。

#### while 循环

while 循环检测循环条件，再执行语句。

```java
while(condition){
    statement;
}
```

#### do-while 循环

do-while 循环先执行语句（通常是一个语句块)，再检测循环条件。

```java
do {
    statement;
}
while(condition);
```

#### for 循环

for 循环，是一种迭代的操作。

```java
for(T var = val; condition; statement1;){
    statement2;
}
//	等价于下面的 while
T var = val;
while(condition){
    statement2;
    statement1;
}
```

for-each 语法，让我们更简单地访问数组中每个元素的值。for-each 作为右值，只能赋值给其他对象或方法。

```java
int[] array = {1, 2, 3, 4, 5};
for (int i : array) {
    System.out.print(i);
}
//	12345
```

## 数据结构

### 数组

#### 创建

```java
/*
*	创建数组
*	Java 中的[]运算符被预定义为检查数组边界，而且没有指针运算，即不能通过数组名加 1 得到数组的下一个元素。
*/

//	无初始值，推荐这样创建数组

int[] array = new int[10];
String[] strings = new String[10];

//	或如此创建：
int array[] = new int[10];

//	有初始值创建，输出：this is a test
String[] strs = {"this ", "is ", "a ", "test"};
for(var str: strs){
    System.out.print(str);
}

//	创建匿名的数组，与上面代码是等价的，输出：this is a test
//	需要 new String[] 声明
for(var str: new String[] {"this ", "is ", "a ", "test"}){
    System.out.print(str);
}


/*
*	创建长度为 0 的数组，但不为 null
*/

String[] zero = new String[0];
```

#### 数组共享内存

数组变量之间的赋值，相当于两者之间共享一个内存空间。

```java
String[] test1 = {"this ", "is ", "a ", "test"};
String[] test2 = test1;
test1[0] = "that ";
System.out.println(Arrays.toString(test1));
System.out.println(Arrays.toString(test2));
//[this , is , a , test]
//[this , is , a , test]

System.out.println(System.identityHashCode(test1));
//295530567
System.out.println(System.identityHashCode(test2));
//295530567
//同一个内存地址
```

#### 复制数组

如果想用新内存复制一个数组，可以使用 `Arrays.copyOf` 方法。

```java
String[] test1 = {"this ", "is ", "a ", "test"};
String[] test2 = Arrays.copyOf(test1, test1.length);
test1[0] = "that ";

System.out.println(Arrays.toString(test1));
//[that , is , a , test]
System.out.println(Arrays.toString(test2));
//[this , is , a , test]

System.out.println(System.identityHashCode(test1));
System.out.println(System.identityHashCode(test2));
//295530567
//2003749087
//不同的内存地址
```

#### 命令行数组

在控制台运行 Java 程序附加一行参数`-f test1 test2 test3`

```java
public static void main(String[] args) {
    System.out.print(Arrays.toString(args));
}
//[-f, test1, test2, test3]
```

#### 数组排序

`Arrays.sort(array)` 使用快排排序。

```java
int[] array = {5, 21, 2, 0, 2};
Arrays.sort(array);
System.out.print(Arrays.toString(array));
```

#### 更多的 API

在 [java.util.Arrays](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/util/Arrays.html)

```java
binarySearch (T[] a, T key, Comparator<? super T> c)	
    //Searches a range of the specified array for the specified object using the binary search algorithm.

copyOf(type[]a, int length)
copyOfRange(type[]a, int start, int end)
    //返回与 a类型相同的一个数组，其长度为 length 或者 end-start， 数组元素为 a 的值

```

### 多维数组

#### 创建

例如我们构造一个九九乘法表

```java
int[][] table99 = new int[9][9];
for(var i = 0; i < table99.length; i++){
    for(var j = 0; j < table99[i].length; j++){
        table99[i][j] = (i + 1) * (j + 1);
    }
}
//	for-each 只能作为右值
for(int[] row: table99){
    for(int val: row){
        System.out.print(String.valueOf(val) + " ");
    }
    System.out.println();
}

/*
1 2 3 4 5 6 7 8 9 
2 4 6 8 10 12 14 16 18 
3 6 9 12 15 18 21 24 27 
4 8 12 16 20 24 28 32 36 
5 10 15 20 25 30 35 40 45 
6 12 18 24 30 36 42 48 54 
7 14 21 28 35 42 49 56 63 
8 16 24 32 40 48 56 64 72 
9 18 27 36 45 54 63 72 81 
*/
```

### 不规则数组

Java 只有一维数组，前面的九九乘法表，其实是一个数组里面存了 9  个数组对象。我们可以利用这个去存不同形状的数组。

