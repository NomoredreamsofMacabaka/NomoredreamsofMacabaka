[toc]

### 杂记
1. 程序的组织结构：
    + 顺序结构
    + 选择结构
    + 循环结构

***
###列表
#### 1. 列表的查询操作
+ 获取列表中指定元素的索引
    + index()：
        + 如果列表中存在N个相同的元素，只返回相同元素的**第一个索引**
        + 如果查询元素不存在，返回ValueError
        + 还可以指定的start和end之间进行查找,list.index('test',1,2)**注意python是左闭右开区间**
    + 获取列表中单个元素：
        + 索引list[1],list[-1]
        + 索引不存在，抛出indexError
+ **获取列表当中多个元素** (切片操作)类似等差数列
    + 语法格式：列表名[start ： stop ： step]
    + 切片操作：
        + 切片结果 -- 原列表片段的拷贝
        + 切片的范围 -- [start,stop)
        + step默认为1
        + step可为正负数，负数从后面开始切片


#### 2. 列表元素的增删改操作
+ 列表增加操作
    + append()：在列表的末尾添加一个元素
    + extend()：在列表的末尾扩展，list.extend(list2)即可将list2扩展到list中
    + insert()：在列表的任意位置添加一个元素list.insert(1,90)在索引为1的地方添加90
    + 切片：在列表的任意位置至少添加一个元素
+ 列表删除操作
    + remove()：一次删除一个元素
    + pop()：删除指定索引位置上的元素，不指定索引删除列表最后一个元素。
    + 切片：一次至少删除一个元素，产生一个新列表对象（eg：newlist=list[1:3]）,不产生新列表而删除原列表中的内容（eg：list[1:3]=[]）
    + clear()：清空列表
    + del()：删除列表
+ 列表元素的更改
    + 切片赋值一个或者多个（eg：list[1:4]=[1,2,3]）
    + 直接赋值
+ **<font color=red>列表的排序操作</font>**
    + 调用sort()方法，列表中所有元素默认按照从小到大的顺序排序。若reverse=T即可实现降序排序。list.sort(reverse=T)
    + 调用内置函数sorted()，可以指定reverse=T，进行降序排序，原列表不发生改变。eg：new_list=sorted(list)
+ 列表生成器
    + 生成列表公式：**[表达式] for [自定义变量] in [可迭代对象]**
        eg：**lst=[i*i for i in range(1,5)]**

<br></br>
*** 

### 字典
#### 1. 字典的实现原理
+ 字典类似于查字典，查字典实现根据部首或者拼音首字母查找的相应页码，python中的字典是根据key查找value所在的位置。
+ <font color=red>字典键值对的个数是不影响单个键值对的查找效率的。因为对于每个键值对的查找都是独立的，根据hash(key)来计算得到value的位置结果。</font>

#### 2. 字典的常用操作
+ 获取字典元素：
    + [ ]，eg：scores['asd']
    + get()，eg：scores.get('asd')
+ **[ ]与get区别：**
    + [ ]如果字典中不存在指定的key，抛出keyError异常
    + **get()**，如果字典不存在指定key，返回None，可以通过参数设置默认的value，以便指定的key不存在时候返回
    eg：dic.get("张三"，"ss")，张三不存在于字典就换成'ss'，存在就pass
+ 字典元素删除：del scores['张三']
+ 字典清空：scores.clear()
+ <font color=red>字典的特点</font>
    + 字典中所有元素都是一个key-value键值对，key不能重复
    + 字典中的元素是无序的
    + 字典中的key必须是不可变对象（就是不能是变量）
    + 字典也可以根据需要动态的伸缩（及不需要分配空间）
    + **字典会浪费较大的内存，是一种使用空间换时间的数据结**
+ 字典生成器
    + eg：item=['s','ss','sss']，prices(1,2,3,4,5,6,7)
    zip()打包函数，upper()字母大写函数
    **d={item.upper():price for iterm,prices in zip(item,prices)}**

<br></br>
*** 

### 元祖
+ 元祖属于不可变序列
    + 不可变序列与可变序列：
        + 不可变序列：字符串，元祖（没有增删改操作）
        + 可变序列：列表，字典（有增删改操作，对象地址不发生更改）
+ 为什么要将元祖设计成不可变序列
    + 在多环境下，同时操作对象时不需要加锁（eg：如果多个用户需要同时对一个数据进行增删改操作，对于可变对象：第一个用户使用时，其他用户是无法调用数据的，得等待第一个用户处理完后才能调用，即上锁。）
    + 如果一个元祖中元素是不可变对象（eg：int整数1,2,3），则不能再引用其他对象
    + 如果一个元祖中元素是可变对象，则可变对象引用不允许改变，但是数据可以改变。例如t=(1,[2,3],2)很显然，第二个元素是列表为可变对象，可以对其进行增删改，但是不能改变其列表属性。

***

### 集合
+ 与列表、字典一样都是可变数据类型
+ 集合是没有value的字典，就是说它里面是**无序的**
+ 集合中没有重复元素
+ 定义空集合s=set()
+ set(['python','a','sss'])或者s={'python','a','sss'}
#### 1. 集合的相关操作
+ 集合元素的添加操作
    + 调用add()
    + 调用update()，至少添加一个元素，upset({200,300,400})
+ 集合元素的删除操作
    + 调用remove()，一次删除一个元素，如果指定元素不存在就抛出KeyError
    + 调用discard()，一次删除一个指定元素，如果指定元素不存在，也不报错
    + 调用pop()，一次只删除一个任意元素，没有参数
+ 集合间的关系
    + 两个集合是否相等
        + 可以使用运算符==或!=进行判断
    + 一个集合是否是另一个集合的子集
        + 可以调用方法issubset进行判断
    + 一个集合是否是另一个集合的超集
        + 可以额调用方法issuperset进行判断
    + 两个集合是否没有交集
        + 可以调用方法isdisjoint进行判断
+ 集合的数学操作
    + 交集：
        s1.inersection(s2) 
        s1 & s2
    + 并集：
        s1.union(s2)
        s1 | s2
    + 差集：
        s1.difference(s2)
        s1-s2
    + 对称差集，即不包含交集的就是对称差集
        s1.symmetric_difference(s2)
        s1 ^ s2

***


### 字符串
#### 1.字符串的常规操作
+ chr和str的区别：
    + chr将()内容转成ASCII码，str()是直接转成字符串
+ 字符串的查询操作
    + index()：查询字串substr第一次出现的位置，如果查找到的字串不存在，则抛出ValueError
    + rdindex()：查找子串substr最后一次出现的位置，如果查找子串不存在，则抛出ValueError
    + find()：查找子串substr第一次出现的位置，如果查找子串不存在时，则返回-1
    + rfind()：查找子串substr最后一次出现的位置，如果查找子串不存在，则返回-1
+ 字符串大小写转换
    + upper()：把字符串中所有字符都转成大写字母
    + lower()：把字符串中所有字符都转成小写字母
    + swapcase()：把字符串中大写变小写，小写变大写
    + capitalize()：把第一个字符转换为大写，把其余字符转换成小写
    + title()：把每个单词的第一个字符转换成大写，把每个单词的剩余字符转换成小写
+ 字符串对齐
    + center：居中对齐
    + ljust：左对齐
    + rjust：右对齐
    + zfill：右对齐，零填充

+ **字符串的拆分**
    + split()：返回值为列表，从字符串左边开始分割，默认为分隔符是空格字符串，**通过maxsplit指定分割的最大次数**
    + rsplit()：返回值为列表，从字符串右边开始分割，除此之外同上
+ **字符串的判断**
    + isidentifier()：判断字符串是不是合法的标识符
    + isspace()：判断指定字符串是否全部由空白字符组成（回车、换行、水平制表符等）
    + isalpha()：判断指定的字符串是否全部由字母组成
    + isdecimal()：判断指定字符串是否由十进制数字组成
    + isnumeric()：判断指定的字符串是否全部由数字组成
    + isalnum()：判断指定字符串是否全部由字母和数字组成
+ 字符串的其他操作
    + replace()：字符串的替换，第一个参数被替换子串，第二个参数指定替换的字符串，第三个参数最大替换次数，不改变原字符串
    + **join()：** 将列表或元组中的<font color =red>字符串</font>合并成一个字符串，不改变原表
+ **字符串的切片操作:**
    + S[1:5:1]：从1开始截至到5，（不包含5），步长为1
    + S[::2]：默认从0开始，到最后一个元素结束，步长为2
    + S[::-1]：将字符串进行倒置
+ **格式化字符串**
    + 格式化字符串：
        + %作为占位符
        + {}作为占位符

***


### 函数
#### 名词解释
+ 形参：形参变量是功能函数里的变量，只有被调用的时候才会被分配到内存单元，调用结束后立即释放。所以形参只有在函数内部有效
+ 实参：实参变量可以是常量、变量、表达式、函数等等，无论什么类型，在进行函数调用是，他们必须有确定的值，以便把这些值拷贝给形参



#### 1. 函数调用的参数传递
+ 位置实参
    + 根据形参对应的位置进行实参传递
+ 关键字实参
    + 根据形参名称进行实参传递
    eg：calc(b=10 , a=20) => def calc(a,b)**b为形参名称，10为实参值**
+ <font color=red>函数传参的情况：</font>
    + 如果是不可变对象，在函数体的修改不会影响实参的值
    + 如果是可变对象，就会影响
```python
def fun(a,b):
    a=10
    b.append(10)
    print(a,b)

test1=100
test2=[1,2,3]
fun(test1,test2)    #输出结果10，[1,2,3,10]
print(test1,test2)  #输出结果100，[1,2,3,10]
```

#### 2. 函数的返回值
+ （1）如果函数没有返回值【函数执行完毕后，不需要给调用处提供数据】 return可以省略不写
+ （2）函数返回值，如果是1个，直接返回类型本身
+ （3）函数返回值，如果是多个，<font color=red>返回结果为元组</font>
#### 3. 函数的参数定义
+ 函数定义默认参数
    + 函数定义时，给形参设置默认值，只有默认值不符的时候才需要传递实参
```python
def fun(a,b=2)
    print(a,b)

#函数调用
fun(100)     #输出结果100，2
fun(100,30)  #输出结果100，30
```
+ 个位可变的位置形参
    + 定义函数时，可能无法事先确定传递的位置实参的个数的时候，使用可变的位置参数
    + 使用*定义个数可变的位置形参
    + 结果为一个元组
```python
def fun(*args):
    print(args)

fun(1)     #输出(1,)
fun(1,2,3) #输出(1,2,3)
```

+ 个数可变的关键字形参
    + 定义函数时，无法事先确定传递的关键字实参的个数时，使用可变的关键字形参
    + 使用**定义个数可变的关键字形参
    + 结果为一个字典  
```python
def fun(**args):
    print(args)

fun(a=10)      #输出{'a': 10}
fun(a=10,b=10) #输出{'a': 10, 'b': 10}
```
+ 可以连起来一起使用：<font color=red>使用条件是要求，个数可变的位置形参要放在个数可变的关键字形参的前面</font>
```python
def fun(*args1,**arg2):
    pass
```
+ 函数的调用
```python
def fun(*args):
    print(args)
lst=[1,2,3]
fun(*lst) #在函数调用时，将列表每个元素都转换成位置参数进行传递

def fun(**args):
    print(args)
dic={'a'=1,'b'=2}
fun(**dic) #在函数调用时，将字典的每个键值对都转换成关键字实参进行传递
```
+ 变量类型
    + 全局变量
    + 局部变量：函数内部的变量一般为局部变量，可以加上global变成全局变量

+ 递归函数
    + 递归的调用过程：
        + 每递归调用一次函数，都会在栈内存分配一个栈帧
        + 每执行完一次函数，都会释放相应的空间
    + 递归的优缺点
        + 缺点：占用内存多，效率低下
        + 优点：思路和代码简单

***
### 异常处理
+ **try ... except ...**
+ **try ... except ... else**
    + 如果try块没有抛出异常，则执行else模块，如果try中抛出了异常，则执行except块
+ **try ... except ... else ... finally**
    + finally块无论是否发生异常都会被执行，能常用来释放try块中申请的资源
```python
try:
    n1 = int(input("输入第一个整数"))
    n2 = int(input("输入第二个整数"))
    result = n1/n2
    print(result)
except ZeroDivisionError: #ZeroDivisionError（python异常类型的一种，不是任意命名）
    print("除数不能为0！") #报错后执行的代码
except ValueError:
    print("只能输入数字")
else:
    print(result)
finally:
    print("程序结束")
```   
+ **<font color=red>Python中常见的异常类型</font>**
    + ZeroDivision：除（或者取模）零（所有数据类型）
    + IndexError：序列中没有此索引（index）
    + KeyError：映射中没有此键
    + NameError：未声明/初始化对象（没有属性）
    + SyntaxError：Python语法错误
    + ValueError：传入无效参数

+ **traceback模块**
    + 使用traceback模块可以打印异常信息
```python
import traceback
try:
    print("-------------------------")
    print(1/0)
except:
    traceback.print_exc()
```
*** 

### 对象、类和方法
+ 类的组成：
    + 类属性（类中的变量）
    + 实例方法 (类中的函数)
    + 静态方法
    + 类方法 
+ 对象的创建
    + 对象的创建又称为类的实例化
    + 语法：实例名=类名()
    + 意义：有了实例，就可以调用类中的内容
+ 动态绑定属性和方法

```python
class Student: #Student为类名称（类名）由一个或多个单词组成，每个单词首字母大写，其余小写
    native_pace="吉林" #直接写在类中的变量，成为属性

    #实例方法   
    def eat(self): #self算是规范写法，虽然可以用别的同样可以运行，但是这是规定的一类
        print(self.names,"学生在吃饭") 
    
    #静态方法
    @staticmethod
    def sm(): #静态方法
        print("静态方法")

    #类方法
    @classmethod
    def cm(cls):
        print(name,"类方法")

    #初始化方法
    def __init__(self,name,age):
        self.names=name #self.names称为实例属性，进行了一个复制的操作，将局部变量name赋值给了实体属性，后面实例化的类对象调用时就用xxx.names来调用，调用的值为name，通常实例属性的后缀和局部变量可以保持一致
        self.age=age

#类对象
s1=Student('张三',2)
s1.eat()   #对象名.方法名()
s1.names
s1.age 
Student.eat(s1)  #类名.方法名(类的对象)-->实际上就是方法定义处的self

#动态绑定类属性
stu1.gender='女'

#动态绑定方法
def show():
    print("定义在类之外的，称为函数")
s1.show=show
s1.show()

#查看类方法
dir(s1)
```
+ 类属性：类中方法外的变量称为类属性，被该类的所有对象所共享
+ 类方法：使用@classmethood修饰方法，使用类名直接访问的方法
+ 静态方法：使用@staticmethood修饰的方法，使用类名直接访问的方法
```python
print(Student.native_place) #访问类属性
Student.cm() #调用类方法
Student.sm() #调用静态方法
```

*** 

###面向对象
+ 封装：提高程序的安全性
    + 将数据（属性）和行为（方法）包装到类对象中。在方法内部对属性进行操作，在类对象的外部调用方法。
    + python中没有专门的修饰符用于属性的私有，如果该属性不希望在类对象外部被访问，前边可以使用两个"_"
               
+ 继承：提高代码复用性
    + 语法格式：class 子类名称（父类1，父类2 ...）：pass
    + 如果一个类没有继承任何类，则默认继承object
    + Python支持多继承
    + 定义子类时，必须在其构造函数中调用父类的构造函数
+ 方法重写：
    + 如果子类对继承父类的某个属性或者方法不满意，可以在子类中对其（方法体）进行重新编写
    + 子类重写后的方法中可以通过super.xxx()调用父类中被重写的方法
```python
class Person(object):
    def __init__(self,name,age):
        self.name=name
        self.age=age
    def info(self):
        print('姓名：{0}，年龄：{1}'.format(self.name,self.age))

#定义子类
class Student(Person):
    def __init__(self,name,age,score):
        super().__init__(name,age)
        self.score=score
    def info(self):    ###方法重写
        super().info()    
        print("分数：",self.score)
#测试
stu=Student('Jack',20,'1001')
stu.info()

stu.__dict__   #特殊属性
Student.__dict__
stu.__dir__()  #查看实例对象所含有的方法
Student.__bases__  #Student的父类元素
Student.__mro__  #类的层次结构
Person.__subclasses()  #子类的列表
```  

+ object类
    + object类是所有类的父类，因此所有类都有object类的属性和方法
    + 内置函数dir()可以查看指定对象所有属性
    + object有一个__str__()方法，用于返回一个对于"对象的描述"，对应于内置函数str()经常用到print()方法，帮我们查看对象的信息，所以我们经常会对__str__()进行重写

+ 特殊属性和特殊方法
    + 特殊属性：
        + __dict\__：获得类对象所绑定的所有属性和方法的字典
    + 特殊方法：
        + __len\_\_()：通过重写__len\__()
        方法，让内置函数len()的参数可以是自定义类型
        + __add\_\_()：通过重写__add\__()方法，可使用自定义对象具有的 “ + ” 功能
        + __new\__()：用于创建对象
        + __init\__()：对创建的对象进行初始化


+ 类的深拷贝和浅拷贝
    + 变量的赋值操作：
        + 只是形成两个变量，实际上还是指向同一个对象
    + 浅拷贝：
        + python拷贝一般都是浅拷贝，拷贝时，对象包含的对象内容不拷贝，因此，源对象与拷贝对象会引用同一个子对象
    + 深拷贝：
        + 使用copy模块的deepcopy函数，递归拷贝对象中包含的子对象，源对象和拷贝对象所有的子对象也不相同
```python 
class CPU:
    pass
class Disk:
    pass
class Computer:
    def __init__(self,cpu,disk):
        self.cpu=cpu
        self.disk=disk

-----------------------------------------------
#变量赋值操作，内存地址是相同的
cpu1=CPU()
cpu2=cpu1
print(id(cpu1),id(cpu2))

-----------------------------------------------
#类的浅拷贝
disk=Disk()  #创建一个硬盘类的对象
computer=Computer(cpu1,disk)  #创建一个计算机类的对象

import copy
computer2=copy.copy(computer)
print(computer,computer.cpu,computer.disk)
print(computer2,computer2.cpu,computer2.disk) #computer2对象id变化了，但是子对象内存id没有变化，这是因为浅拷贝不影响子对象
-----------------------------------------------
#类的深拷贝
computer3=copy.deepcopy(computer)
print(computer,computer.cpu,computer.disk)
print(computer3,computer3.cpu,computer3.disk) #computer3对象id变化了，子对象的内存id也变化了
```

*** 
###模块
+ 函数与模块的关系：
    + 一个模块可以包含N多个函数
+ 在python中一个扩展名为.py的文件就是一个模块
+ 使用模块的优点：
    + 方便其他程序员导入或者调用
    + 避免函数名和变量名冲突
    + 提高代码的可维护性
    + 提高代码的可重用性
+ 导入自定义模块
```python
#第一种，直接import，前提是模块要在当前目录下
import os
os.chdir("E:\自学盘\整理目录\python自练\python\练习代码") #chdir改变当前路径为()中的路径
print(os.getcwd())
import add

#第二种通过sys模块导入自定义模块的path：
import sys
sys.path.append("E:\自学盘\整理目录\python自练\python\练习代码")  #这会让sys.path中多一个元素
sys.path #以数组元素展示
#还可以一次性添加多个路径
sys.path.extend(r"path1",r"path2")
import add 

#第三种把模块放在模块路径下
sys.path  #查看所有模块可以调取的路径，然后将包或者模块脚本放在里面
```
+ 以主程序形式运行
    + 在每个模块的定义中都包括一个记录模块名称的变量__name__,程序可以检查变量，以确定他们在哪个模块中执行，如果一个模块不是被导入到其他程序中运行，那么他可能在解释器的顶级模块中执行，顶级模块的__name__变量值为__main__
```python
if __name__ = '__main__':
    pass


#设计一个add.py的脚本，内容如下
def add(a,b):
    return a+b
print(add(10,20))

#在其他的脚本中调用add.py这个模块，如果子add.py不设置主程序运行：
import add  #这样会输出30

#设置主程序运行：
def add(a,b):
    return a+b
if __name__=='__main__':
    print(add(10,20))
#这样在其他程序调用就不会出现输出30的情况了
```
+ python中的包
    + 包是一个分层次的目录结构，它将一组功能相近得的模块组织在一个目录下
    + 作用：
        + 规范代码
        + 避免模块名称冲突
    + 包和目录的区别：
        + 包含__init__.py文件的目录称为包
        + 目录里通常不包含__init__.py文件
*** 

### Python中常用的内置模块
![avatar](索引/%E5%B8%B8%E7%94%A8%E6%A8%A1%E5%9D%97.PNG)

### 编码格式
+ 常见的字符编码格式
    + python的解释器使用的是Unicode（内存）
    + .py文件在磁盘上使用UTF-8存储（外存）

![avatar](索引/%E7%BC%96%E7%A0%81%E6%A0%BC%E5%BC%8F.PNG)





***进程池和线程池：*** （R中使用多线程和多进程运行任务）[https://mp.weixin.qq.com/s/4uwXqu19P39IsBCEnvBv3w]
+ 一般情况下，一个核为一个线程，如果进行超线程运作，那么一个核心可以对应两个或者多个线程。
+ 关系：线程是进程的基本执行单位，一个进程的所有任务都在线程中执行；进程想要执行任务必须要有线程。流程work.sh中的job不是进程，而是运行sh的个数，可能有的程序需要多个进程同时作用。
+ 区别：
    + 同一进程的线程共享本进程的地址空间，而进程之间则是独立的地址空间；
    + 同一进程内的线程共享本进程的资源，而进程之间是独立的。   
    + 一个进程崩溃后，在保护模式下不会对其他进程产生影响，但是一个线程崩溃整个进程都死掉了。所以多进程要比多线程健壮。