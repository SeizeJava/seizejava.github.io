# 类的扩展

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

表明 BookOrder 是由 Book 派生 (extends) 的，BookOrder 是 Book 的子类，Book 是 BookOrder 的超类（父类）。因为不是一个类内，我们不可以直接给父类的`private` 的数据字段直接赋值（``public` 可以）。于是我们可以调用父类的构造器来于父类数据字段初始化：`super` 相当于调用父类的 `this` 构造器，（可以这样理解，但 `super` 并不是父类的引用，只是对编译器的指令）

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

