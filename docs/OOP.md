# 对象与类

## 面向对象思想 

### 概念

面向对象 (Object-oriented programming) 的三要素是：封装、继承、多态，但继承和多态必须一起说，一旦割裂，就说明理解上已经误入歧途了。

- **封装 encapsulation**。封装的意义，在于明确标识出允许外部使用的所有成员函数和数据项，或者叫**接口**。封装把方法和数据封装成抽象的类，并且类可以把自己的数据和方法只让可信的类或者对象操作，对不可信的进行信息隐藏。封装的目的就是「互不影响」。
- **继承 inheritance** 。同时具有两种含义：
  1. 继承基类的方法，并做出自己的扩展——号称解决了代码重用问题；但在实践中，它使得子类与基类出现强耦合。
  2. 声明某个子类**兼容**于某基类（或接口上完全兼容于基类），外部调用者可无需关注其差别（内部机制会自动把请求派发 dispatch 到合适的逻辑）。**接口继承**实质上是要求「做出一个良好的抽象，这个抽象规定了一个兼容接口，使得外部调用者无需关心具体细节，可一视同仁的处理实现了特定接口的所有对象」——这在程序设计上，叫做**归一化**。
- **多态 polymorphism**。多态基于对象所属类的不同，外部对同一个方法的调用，实际执行的逻辑不同。它实际上是依附于继承的第二种含义的。让它与封装、继承这两个概念并列，是不符合逻辑的。不假思索的就把它们当作可并列概念使用的人，显然是从一开始就被误导了。

归一化使得外部使用者可以不加区分的处理所有接口兼容的对象集合——就好象 Linux 的泛文件概念一样，所有东西都可以当文件处理，不必关心它是内存、磁盘、网络还是屏幕。当然，如果你需要，当然也可以区分出“字符设备”和“块设备”，然后做出针对性的设计：细致到什么程度，视需求而定。

例如：

1. 一切对象都可以序列化 / `str()` / `toString()`
2. 一切 UI 对象都是个 window，都可以响应窗口事件。

时刻记得设计模式就三个准则：**1）组合而不是继承，2）依赖于接口而不是实现，3）高内聚，低耦合。**

### OOP 优点

1. 模块化：提供一个更清晰的模块化结构，使得程序可以更好地定义抽象数据类型，抽象数据类型隐藏了实现细节并且提供了清晰的接口
2. 可伸缩：将开发者加到项目往往很容易，因为他们不需要理解整个项目的代码，只需要理解与他们工作相关的那些代码。增加硬件资源可以被更有效地利用，因为你可以为每个模块分配不同的资源
3. 可维护：可以更容易地维护和修改现有代码，因为新对象可以与现有对象有些许不同
4. 可拓展：提供一个更好的框架来通过库拓展项目，而这些组件可以很容易地被程序员修改和调整，这在用户界面和图形界面开发中尤其有用
5. 代码可复用：各模块与其他模块相互独立，这可以让你提取出一个功能，比如用户登录，在其他项目中使用

### OOP 缺点

1. 现实世界很难被完整地划分为类和子类
2. 有时候多个对象会以复杂地形式交互，甚至在写程序地时候都无法预期到
3. 对于小项目或只需要几个简单任务地项目来说，会徒增代码量和复杂度
4. 性能下降，这是最激烈地讨论之一，虽然一个设计良好地面向过程站点性能会比设计良好地面向对象站点高，但是仍然有许多因素需要考虑，这不应该是你主要关心地问题

OO 存在很多争议，Erlang 语言的创始人乔·阿姆斯特朗（Joe Armstrong），他总结了[面向对象编程的四个重大缺点](http://harmful.cat-v.org/software/OO_programming/why_oo_sucks)：

1. 数据结构和功能不应捆绑在一起
2. 所有东西都必须是一个对象
3. 在 OOPL 中，数据类型的定义分散在各个地方
4. 物体具有私有状态

### 适合 OOP 的场景

1. 你有多个程序员并且各自不需要了解每个组件
2. 有许多复用和共享地代码
3. 项目经常变动并且之后不断新增功能
4. 不同模块服务于不同数据源或硬件

[来自 medium](https://medium.com/@hi.aaron.xie/%E4%BD%95%E6%97%B6%E8%AF%A5%E4%BD%BF%E7%94%A8%E9%9D%A2%E5%90%91%E5%AF%B9%E8%B1%A1%E7%BC%96%E7%A8%8B%E8%80%8C%E9%9D%9E%E9%9D%A2%E5%90%91%E8%BF%87%E7%A8%8B%E7%BC%96%E7%A8%8B-%E8%AF%91-e6fe573513e5)

### 其他设计思想

- **数据驱动编程（Data Driven Programming）**。将程序架构的复杂度转移为结构化的数据表示，实现极其灵活的设计。
- **组件式编程**。Unity 采用了这种方式设计且获得了很大成功。组件式尽量用类的组合代替类的继承，但是依然保留了一些多态的特性。
- **Actor 模型**。与传统面向对象有良好兼容性，充分利用多核性能，在需要高性能并发的场合大放异彩。
- **函数式编程**。比较古老的理念也焕发了新生。

### 类与类之间的关系

- 依赖 use-a ：例如，Order 类使用 Account类是因为 Order 对象需要访问 Account 对象查看信用状态。但是 Item 类不依赖于 Account类，这是因为 Item 对象与客户账户无关。因此，如果一个类的方法操纵另一个类的对象，我们就说一个类依赖于另一个类。**尽可能减少依赖，降低耦合。**

- 聚合 has-a：例如，一个 Order 对象包含一些 Item 对象。聚合关系意味着类 A 的对象包含类 B 的对象。

- 继承 is-a：如添加商品、生成账单等都是从 Order 类继承来的。一般而言，如果类 A 扩展类 B, 类 A 不但包含从类 B继承的方法，也许还会拥有一些额外的功能。

## Java 中的类设计工具

OOP 的另一个原则会让用户自定义 Java 类变得轻而易举，这就是：可以通过扩展一个 类来建立另外一个新的类。在 Java 中，所有的类都源自于一个「神通广大的超类」， 它就是 Object。

要想使用OOP，先了解 3 个特性：

- 对象的行为（behavior)  ——可以对对象施加哪些操作，或可以对对象施加哪些方法？
- 对象的状态（state）——当施加那些方法时，对象如何响应？
- 对象标识（identity） —— 如何辨别具有相同行为与状态的不同对象？

### 对象与对象变量

通过 `new class_name()` 新建对象，意味着开辟内存，并与变量联系：

```java
Date now_date = new Date();
```

若不 `new` ，则编译器报错。

```java
Date now_date;
System.out.println(date.toString());
//	Language base.md
```

### 构造器 Constructor

定义一个 Book 类，里面有书名、单价、类别。

- 构造器与类同名
- 每个类可以有一个以上的构造器
- 构造器可以有 0 个、1 个或多个参数
- 构造器没有返回值
- 构造器总是伴随着 `new` 操作一起调用

```java
class Book {
    private final String book_name;
    private double unit_price;
    public String book_type;

    public Book(String book_name, double unit_price, String book_type) {
        this.book_name = book_name;
        this.unit_price = unit_price;
        this.book_type = book_type;
    }
}
```

- `private` 意味着只有**该类内的**方法可以调用该对象或者方法。
- `public` 意味着只有**所有类**的方法都可以调用该对象或者方法。
- `final` 意味着该变量只能赋值一次，或者说该引用只能指向一块固定的内存。

我们不能直接 `Book special_offer_book = new Book();`，因为没有定义不含参数的构造器。只能使用：

```java
Book special_offer_book = new Book("Machine learning", 78.5, "Technology");
```

## 类的封装

### 私有对象

数据是 `private` 的，但有时候我们又需要去访问类内的数据怎么办？

答案是用 `public` 的方法访问！

`private` 是为了隔离外部，`public` 是为了谨慎修改。

setter 方法用来为私有的数据赋值以实现封装，可以为`unit_price`, `book_type`创建 setter 方法，因为 `book_name` 是 `final` 的，在对象构建之后，这个值不会再被修改，所以不可 set 。下面是 `book_type` 的方法

```java
public void setBook_type(String book_type) {
    this.book_type = book_type;
    //	this 代表当前对象, 为了和参数传入的 book_type 区分
}
```


getter 方法可以用来获取私有数据，避免外界修改数值。可以为`unit_price`, `book_type`, `book_name` 创建 getter 方法，下面是 `book_type` 的方法

```java
public String getBook_type() {
    return book_type;
    //	不会出现混淆，也可以不用 this
}
```

当我们调用方法时，其实也传入了隐式参数。我们新建一个获取打折后价格的方法：

```java
    public double getDiscountPrice(double discount){
        return this.unit_price * discount;
    }
```

例如新建一个 special_offer_book 对象，此时传入的第一个参数是 special_offer_book，这个参数等同于 `this` ，我们看不见，所以叫隐式。第二个传入的参数是 discount 且等于 0.8，是看得见的——显式参数。

```java
Book special_offer_book = new Book("Machine learning", 100, "Technology");
System.out.println(special_offer_book.getDiscountPrice(0.8));
//	80
```

### 私有方法

绝大多数方法都被设计为公有的，但在某些特殊情况下，例如让方法作为辅助的、中间的过程，就将它们设计为私有的。

在 Java 中，为了实现一个私有的方法，只需将关键字 `public` 改为 `private` 即可，那只有在**该类内**才能调用它。

## 静态类型

非静态字段 (non-static field ) 在每个实例中都有自己的一个独立“空间”，但是 static field 只有一个共享“空间”，所有实例都会共享该字段。

注意：static field 可以在类外用直接通过变量名访问，在类外用**类名.变量名**访问。

当我们想记录所有书的数量，我们可以用 `static` 关键字，每个由该类 (Book) 实例化的对象，都共享此对象 (book_num)。如果每次添加书时，数量加一，则可以方便地记录书的数量。

```java
class Book {
    private static int book_num = 0;
    //	共享内存
    private final String book_name;
    private double unit_price;
    public String book_type;

    public Book(String book_name, double unit_price, String book_type) {
        this.book_name = book_name;
        this.unit_price = unit_price;
        this.book_type = book_type;
        book_num += 1;
        //	每次添加书时，数量加一
    }
}
```

进行如下操作

```java
class Test{
    public static void main(String[] args) {
        Book ml_book = new Book("Machine learning", 100, "ML");
        Book cs_book = new Book("CS: APP", 80, "CS");
        System.out.println(Book.book_num);
        //	输出 2
    }
}
```

如果我们将 book_num 改为 `public`，则可以直接用 `Book.book_num ` 访问该对象。

### 静态常量

静态变量使用得比较少，但静态常量却使用得比较多。一般设为 `public` 也不会影响封闭性，因为是 `final` 的。

```java
class Decimal {
    public static final double EPS = 1e-8;
}
```

### 静态方法

静态方法是没有 `this`对象的方法，也就是不需要用到类衍生出的对象。

2 种情况下使用静态方法：

1. 不需要访问对象状态，其所需参数都是通过显式参数提供。
2. 只需要访问类的静态成员。

比如下列方法只需要访问 `static` 成员对象，那么自然也是 `static`。

```java
public static int getBookNum() {
    return book_num;
}
```

main 方法也是 `static` 方法。

## 方法的参数

### 传参

```java
public Book(String book_name, double unit_price, String book_type) {
    this.book_name = book_name;
    this.unit_price = unit_price;
    this.book_type = book_type;
}
```

对于这个方法，我们调用

```java
Book ml_book = new Book("Machine learning", 100, "ML");
```

就将`"Machine learning", 100, "ML"` 分别传给了 `book_name, unit_price, book_type`。

采用 `this.book_name = book_name;`这样的方法避免混淆。

也可以让形式参数使用不同名字：

```java
public Book(String pbook_name, double punit_price, String pbook_type) {
    book_name = pbook_name;
    unit_price = punit_price;
    book_type = pbook_type;
}
```

### 传递策略

| 求值策略 | 求值时间             | 传值方式     |
| -------- | -------------------- | ------------ |
| 值传递   | 调用前               | 原值副本     |
| 引用传递 | 调用前               | 原值         |
| 名传递   | 调用后（用到才求值） | 与值无关的名 |

### Java 传值还是传引用？

**The Java Spec says that everything in Java is pass-by-value**. There is no such thing as "pass-by-reference" in Java. Java 只存在传值。

参数传递本质是赋值操作。Java 是如何赋值的？

对于原子类型（ int, double, char ... ），赋值会直接修改**变量的值**。对于引用类型（ String, 自定义的类型...），赋值会修改**引用**，原来所指的对象不会改变。若这个对象无变量所指，自然会被销毁。

参数传递的时候，是拷贝一份**实际参数的地址**到方法内。（具体是拷贝到虚拟机栈）

如参数传递原子类型时，

```java
public static void doubleMoney(double x){
    x = x * 2;
}

public static void main(String[] args) {
    double money = 20.0;
    Book.doubleMoney(money);
    System.out.println(money);
    //	输出 20.0
}
```

复制 money 的值，赋值给 x 开辟的新内存空间，x 所指向新的 20.0 的和 money 所指的 20.0 不是同一个，因此即便修改 x 也没用。

如果是参数传递引用类型：

```java
public static void addBrand(String book_name){
    book_name = "Cipher " + book_name;
}

public static void main(String[] args) {
    String sci_book = "Explorer";
    Book.addBrand(sci_book);
    System.out.println(sci_book);
    //	输出 Explorer
}
```

复制 sci_book 的地址，赋值给 book_name ，当 book_name 被修改时，不修改其引用的对象，而是开辟新内存空间存放数据。原来的 "Explorer" 由于还被 sci_book 引用，因此没有被清除。

## 类的初始化

### 方法重载

```java
StringBuilder message1 = new StringBuilder();
StringBuilder message2 = new StringBuilder("Yep");
```

同名的方法可以传入不同类型、不同数量的参数，叫做重载（overloading）。Java 支持重载然后方法，重载需要指出方法名以及参数类型。

### 默认初始化

若在 Java 中不赋予初始值，则自动初始化：数值为0、布尔值为 false、对象引用为 null 。由于 null 会报错，最好是我们自己对所有变量初始化。

### 显式初始化 

```java
class Book {
    private static int book_num = 0;
    private double unit_price = 50.0;
    public String book_type = "Tech";
    //...
}
```

在执行构造器之前，先执行赋值操作。当一个类的所有构造器都希望把相同的值赋予某个特定的实例时，这种方式特别有用。

初始值不一定是常量，也可以是静态方法。

```java
private int id = assignId();

private int assignId() {
    book_num += 1;
    return book_num;
}

```

### 无参数构造器

如果在编写一个类时没有编写构造器，那么系统就会提供一个无参数构造器。这个构造器将所有的成员设置为默认值。

若编写了有参数构造器，如只创建了 `public Book(String book_name, double unit_price, String book_type) ` ，调用无参数构造器时 `Book book = new Book()` 就会报错。

若需要`new Classname()`，则必须创建无参构造器。

```java
public Book(String book_name){
    this(book_name, 100, "Book");
}
```

### 调用其他构造器

例如我们想创建一个新的构造器：

```java
public Book(String book_name){
    this(book_name, 100.0, "TEMP");
}
```

这样就扩展了不同参数的构造器。

```java
Book ml_book = new Book("Deep Learning");
System.out.println(ml_book.getUnit_price());
//	输出 100.0
```

### 初始化块 initialization  block

除了

1. 在声明中初始化
2. 在构造器中初始化

还可以在  initialization block 中初始化：

```java
class Book {
    public static int book_num = 0;

    private int id;
    private final String book_name;
    private double unit_price;
    public String book_type;
    {
        book_num += 1;
        id = book_num;
    }
    //...
}
```

在这个例子中，id 字段是在初始化块中初始化的，不管使用哪个构造函数来构造对象。首先运行 initialization block，然后执行构造器。这种机制从来没有必要，也不常见，了解就好。将初始化代码放在构造器中更为直接，

### 构造器总结

按顺序执行：

1. 数据字段默认的初始化
2. initialization block 
3. 构造器

### static 初始化块

如果对类的静态域进行初始化的代码比较复杂，那么可以使用静态的初始化块：

```java
static {
    book_num = 0;
    System.out.println("Hello!");
}
```

在类第一次加载的时候，将会进行静态域的初始化。与实例域一样，除非将它们显式地设置成其他值，否则默认的初始值是 0、 false 或 null。所有的静态初始化语句以及静态初始化块都将依照类定义的顺序执行。

可以，但没必要。

## 包 Packages

使用包是为了确保类名是唯一的。类似于 C++ 的命名空间。从编译器的角度来看，嵌套的包之间没有任何关系。例如，java.util 包与 java.util.jar 包毫无关系。每一个都拥有独立的类集合。

### 导入类

可以使用 import 语句导入一个特定的类或者整个包。import 语句应该位于源文件的顶部(但位于 **package 语句的后面**)。

为了使用 `LocalDate today = Local Date.now()；` 可以：

```java
import java.util.*;
```

或者使用

```java
import java.time.Local Date;
```

如果需要使用不同包下，相同名字的类库怎么办？

```java
java.util.Date deadline = new java.util.Date();
java.sql.Date today = new java.sql.Date(...);
```

#### 静态导入

import 语句不仅可以导入类，还增加了导入静态方法和静态域的功能。例如，可以：

```java
import static java.lang.System.out;
```

就可以简单地写出

```java
out.println("oh");
```

### 创建包

源代码放在 `com/benearyou/seizejava/` 下，然后：

```java
package com.benearyou.seizejava;
```

就可以囊括所有类。

### 包作用域

标记为public 的部分可以被任意的类使用；标记为 private 的部分只能被定义它们的类使用。如果没有指定 public 或 private, 这个部分（类、方法或变量）可以被**同一个包中的所有方法**访问。

为了保持封装，最好还是明确权限控制。

### 类路径

*可以要用的时候再学。*

类文件也可以存储在JAR(Java归档）文件中。在一个 JAR 文件中，可以包含多个压缩形式的类文件和子目录，这样既可以节省又可以改善性能。在程序中用到第三方 ( third-party ) 的库文件时，通常会给出一个或多个需要包含的 JAR 文件……

## 文档注释

*可以要用的时候再学。*

JDK 包含一个很有用的工具，叫做javadoc，它可以由源文件生成一个 HTML 文档。事实上，在第 3章讲述的联机 API 文档就是通过对标准 Java类库的源代码运行 javadoc 生成的。

具体参考：https://docs.oracle.com/en/java/javase/11/docs/specs/doc-comment-spec.html

- 类注释。必须放在 import 语句之后，类定义之前。

- 方法注释。@param 变量描述，@return 描述，©throws 类描述……
- 域注释。`\* *\`对公有域（通常指的是静态常量）建立文档。
- 通用注释。@author 等。



