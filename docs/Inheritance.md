# 继承与多态

有时候新建了一个类，发现我们之前就写过类似的类，只不过新类有新数据字段和新的方法。这时候，我们可以通过继承，以获得之前类的数据字段和方法。

## 组合与继承

之前说过类之间有三种关系：继承 is-a 、聚合 has-a、依赖 use-a 。

当你用继承的时候，肯定是需要利用**多态的特性**。否则，我们最好应该用组合（has-a）模式。如果我们仅仅是为了代码复用，也应该用组合。

如果此时我们想根据之前的 Book 类，新建一个 BookOrder 类，BookOrder 拥有 Book 类的所有数据和方法，再往里加入订单ID、订单创建时间 (createdTime)、快递费 (deliverCost)。

利用组合的思想：

```java
public class BookOrder{
    private int orderId;
    private Book book;
    private double deliverCost;
    private LocalDateTime createdTime;
    //...

    public BookOrder(int orderId, Book book, double deliverCost){
        this.orderId = orderId;
        this.book = book;
        this.createdTime = LocalDateTime.now();
        this.deliverCost = deliverCost;
    }
}
```

要使用 Book 的数据和成员时，我们只需要：

```java
Book tmp = new Book("Test in Line", 50, "Tech");
BookOrder bookOrder = new BookOrder(2215, tmp);
out.println(bookOrder.getBook().getBook_name());
//输出：Test in Line
```

### 父类构造器

如果利用继承，则使用关键字 `extends`：

```java
public class BookOrder extends Book {
    private int orderId;
    private double deliverCost;
    private LocalDateTime createdTime;
    //...

    public BookOrder(int orderId, double deliverCost, String book_name, 
                     double unit_price, String book_type) {
        super(book_name, unit_price, book_type);
        this.orderId = orderId;
        this.createdTime = LocalDateTime.now();
        this.deliverCost = deliverCost;
    }
}
```

表明 BookOrder 是由 Book 派生 (extends) 的，BookOrder 是 Book 的子类，Book 是 BookOrder 的超类（父类）。

因为不是一个类内，我们不可以直接给父类的`private` 的数据字段直接赋值（`public` 可以）。于是我们可以调用父类的构造器来于父类数据字段初始化：`super` 相当于调用父类的 `this` 构造器，（可以这样理解，但 `super` 并不是父类的引用，只是对编译器的指令）

### super() 与 this() 的异同

|          | this                           | super                          |
| -------- | ------------------------------ | ------------------------------ |
| 构造器   | 在当前类调用本类其他其它构造器 | 在子类调用父类构造器           |
| 作为引用 | 代表当前对象                   | 引用当前对象的直接父类中的成员 |
| 本质     | 引用                           | 编译器能识别的 Java 关键字     |

相同点：

- `this()` 和 `super()`都指的是对象，所以均不可以在 static 环境中使用，如 static 变量，static 方法，static 语句块。  

- `this()` 和 `super()`都需放在构造方法内第一行。

### super() 与 this() 为什么必须在构造方法第一行

构造方法的作用就是在 JVM 堆中构建出一个指定类型的对象，如果你调用了两个这种形式的方法，岂不是代表着构建出了两个对象。

同理，为了避免构建出两个对象这种问题的出现，Java 在编译时对这种情况做了强校验， 用户不能再同一个方法内调用多次`this()` 或 `super()` ，同时为了避免对对象本身进行操作时，对象本身还未构建成功(也就找不到对应对象)，所以对`this()`或 `super()` 的调用只能在构造方法中的第一行实现，防止异常。

在普通的成员方法中，如果调用 `super()` 或者 `this()`，你是想要重新创建一个对象吗？抱歉Java为了保证自身对象的合理性，不允许你做这样的操作。

https://www.zhihu.com/question/47012546/answer/104002471

## 覆盖

在这个例子中，如果我们想实现从 BookOrder 获取总共的单价（单价+快递费），用 `getUnit_price()` 获取：

```java
BookOrder cs_app = new BookOrder(2001, 10, "CS:APP", 50, "Tech");
out.println(cs_app.getUnit_price());
//输出：50.0
```

这样表明 `getUnit_price()` 调用的是父类 Book 的方法，显然不是我们想要的。

这时可以利用 `@Override` ，只要和父类方法同名 ，就能覆盖父类方法，

```java
@Override
public double getUnit_price() {
    return super.getUnit_price() + this.deliverCost;
}
```

此时：

```java
BookOrder cs_app = new BookOrder(2001, 10, "CS:APP", 50, "Tech");
out.println(cs_app.getUnit_price());
//输出：60.0
```

就得到我们想要的结果。

## 多态

```java
Book[] books = new Book[]{
    new BookOrder(2001, 10, "CS:APP",
                  50, "Tech"),
    new Book("Machine learning", 100, "ML"),
    new Book("Thinking in Java", 100, "CS")
};
for(Book book: books){
    out.println(book.getUnit_price());
}
/*
输出：
60.0
100.0
100.0
*/
```

一个对象变量可以指示多种实际类型的现象被称为**多态** (polymorphism)。对象在运行时自动选择调用哪个方法，这种现象称为**动态绑定** (dynamic binding )。

显然，白马是一种马，BookOrder 类也是 Book 类，因此我们可以通过 Book 数组存储 BookOrder 对象，自然，且根据类对于 `getUnit_price` 的具体实现来调用方法，先调用本子类的方法，如果不存在，就调用父类的方法。

Book 变量不仅可以**引用** BookOrder 对象，也可以引用其他 Book 子类的对象。反过来，BookOrder 变量不可以引用其父类 Book 实例化的对象。

### 继承层次

继承层次 (inheritance hierarchy) 是由同一个类派生出来的所有类的集合。在继承层次中，从某个特定的类到其祖先的路径被称为该类的继承链 (inheritance chain)，如图所示：

![inherit1](https://gitee.com/xrandx/blog-figurebed/raw/master/img/20210418215125.jpg)

Book 是所有其他类的父类。如果你想，可以这样的单继承模式可以一直延续。

### 调用方法

对于 Book 类和 BookOrder  类的同名方法 `getUnit_price()`，

```java
BookOrder bookOrder = new BookOrder(2001, 10, "CS:APP", 50, "Tech");
out.println(bookOrder.getUnit_price());
//	60.0
```

其中经历了什么过程？

1. 编译器査看对象的声明类型和方法名。调用 `bookOrder.getUnit_price()`，且变量 bookOrder 声明为 BookOrder 类的对象。也许存在多个相同名字的方法，编译器将会一一列举所有 Book 类中名为 getUnit_price 的方法和其超类中访问属性为 `public` 且名为 getUnit_price 的方法（超类的私有方法不可访问）。
2. 编译器将査看调用方法时提供的参数类型。如果在所有名为 getUnit_price 的方法中存在一个与提供的参数类型**完全匹配**，就选择这个方法。否则就通过类型转换选择最为接近的方法，例如 int 可以转换成 double 。编译器就获得需要调用的方法名字和参数类型。
3. 如果是 private 方法、 static 方法、 final 方法（有关 final 修饰符的含义将在下一节讲述）或者构造器，那么编译器将可以准确地知道应该调用哪个方法，我们将这种调用方式称为静态绑定（static binding )。与此对应的是，调用的方法依赖于隐式参数的实际类型，并且在运行时实现动态绑定。在我们列举的示例中，编译器采用动态绑定的方式生成一条调用 f (String) 的指令。
4. 当程序运行，并且采用动态绑定调用方法时，虚拟机一定调用与 bookOrder  所引用对象的实际类型**最合适**的方法。

## 阻止继承

有时候我们不希望其他类继承某类，这时我们可以声明 `final` 。

```java
public final class BookOrder extends Book{
    //...
}
```

如此，BookOrder 类不可以被用来扩展子类。

也可以在方法上使用 `final` ，这就使得其子类方法无法覆盖这个方法。（将类声明为 final ，则其下的所有方法也是 final 的）

```java
public final LocalDateTime getCreatedTime() {
    return createdTime;
}

public final void setCreatedTime(LocalDateTime createdTime) {
    this.createdTime = createdTime;
}
```

将 `getCreatedTime()` 和 `setCreatedTime()` 设置为 final ，不允许子类去改变 createdTime 的相关方法。

## 强制类型转换

有时候我们也许会需要像把 int 转 double 一样，来将我们自己的类强制转换到其他类。例如：

```java
Book[] books = new Book[]{
    new BookOrder(2001, 10, "CS:APP",
                  50, "Tech"),
    new Book("Machine learning", 100, "ML"),
    new Book("Thinking in Java", 100, "CS")
};
Book temp = (Book) books[0];
```
进行类型转换的唯一原因是：在暂时忽视对象的实际类型之后，使用对象属于父类的全部功能。例如，我们需要其属于 Book 类的 `getUnit_price` ，那么可以把一个 BookOrder 转成 Book 类。

注意，我们**只能从继承链中，由下往上类型转换**。也就是子类只能转为父类，父类不能转为子类。理所应当，白马即马，马却未必是白马。

若我们运行 `BookOrder temp = (BookOrder) books[1]`，则会出现 `java.lang.ClassCastException` 类型转换错误。

只有父类对象本身就是用子类 new 出来的时候, 才可以在将来被强制转换为子类对象。例如：

```java
Book book1 = new BookOrder(2001, 10, "CS:APP", 50, "Tech");
BookOrder bookOrder1 = (BookOrder)book1;
```

### instanceof

`instanceof` 关键字可以帮助我们判断变量的类型。这样我们就可以避免将父类转成子类。

```java
if(book1 instanceof BookOrder){
    out.println("yep!");
}
```

## 抽象类

如果我们有一个 Album 类，Book 类和它相当于都有一个共同的父类 —— CulturalProduct 类。Album 类和 Book 类在继承层次中是同级的，如果我们想为他们实现一个 `getName()` 方法，但 Album 类和 Book 类对于 `getName()` 的具体实现不同。

使用 `abstract` 关键字，我们就可以只关注抽象，不具体实现。

```java
public abstract class CulturalProduct {
    public abstract String getName();
}
```

于是 Book 类要继承这个方法，并且要提供一个实现。

```java
public class BookOrder extends Book {
    //...
    public String getName(){
        return this.book_name;
    }
}
```

Album 类同样也是：

```java
public class Album extends CulturalProduct {
    private String name;

    public Album(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }
}
```

有了这些描述，我们就可以实现多态了：

```java
Book book = new Book("this is book", 50, "Tech");
Album album = new Album("this is album");
CulturalProduct[] culturalProducts = new CulturalProduct[]{book, album};
for(var i: culturalProducts){
    out.println(i.getName());
}
//输出：
//this is book
//this is album
```

