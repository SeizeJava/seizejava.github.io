# 继承与多态

有时候新建了一个类，发现我们之前就写过类似的类，只不过新类有新数据字段和新的方法。这时候，我们可以通过继承，以获得之前类的数据字段和方法。

## 组合与继承

之前说过类之间有三种关系：继承 is-a 、聚合 has-a、依赖 use-a 。

当你用继承的时候，肯定是需要利用**多态的特性**。否则，我们最好应该用组合（has-a）模式。如果我们仅仅是为了代码复用，也应该用组合。

如果此时我们想根据之前的 Book 类，新建一个 BookOrder 类，BookOrder 拥有 Book 类的所有数据和方法，再往里加入订单ID、订单创建时间 (createdTime)、快递费 (deliverCost)。

利用组合的思想：

```java
class BookOrder{
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
class BookOrder extends Book {
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

### super() 与 this() 的区别

|        | this | super                |
| ------ | ---- | -------------------- |
| 构造器 |      |                      |
|        |      |                      |
| 本质   | 引用 | 编译器能识别的关键字 |



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







