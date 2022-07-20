#python中的属性和方法
"""
类: 类是多个类似事物组成的群体的统称。能快速帮助我们理解和判断事物的性质
print (type(11)) <class 'int'>
print (type(12)) <class 'int'>
11,12都是int类下的包含了相似的不同的个例，这些个例被称为实例或者对象

类的组成:1.类属性 2.实例方法 3.静态方法 4.类方法
"""

from _typeshed import Self


class Student:
    native_place='湖北'  #直接写在类中的变量称为类属性
    def __init__(self,name,age):  #初始化方法 相当于给类定义变量给参
        self.name1 = name      #self.name1称为实例属性,进行了一个赋值操作,将局部变量的name赋给实体属性name1
        self.age1  = age
        
    def eat(self):     #定义在类中的函数称为类方法,self你不写它也在这儿,也可以换成别的单词
                       #实例方法
        print('学生在吃饭...')

#在类之外定义def的称为函数,在类中定义的称为方法
#def drink():  #drink为函数
#    print ('喝水') 
    def change_score(self):
        print('teacher %s is changing score ' %self.name1)

#静态方法
    @staticmethod
    def sm():  #在静态方法中不允许写self(或者其他什么的字符)
        print('静态方法')

#类方法
    @classmethod 
    def cm(cls):   #类方法中需要传递一个cls参数
        print('类方法')

        


#创建Student类的对象:
stu1 = Student('张三', 18)  #创建类对象的时候对应到__init__初始化方法中的变量。
stu1 = Student()   #例如这句话就是错的，他缺少了name，和age两个初始化参数。
#调用类属性:
stu1.name1
stu1.age1
stu1.native_place
#调用类方法:
stu1.eat()
stu1.change_score()
"""
小总结
类属性:类中方法外的变量称为类属性,被该类所有对象所共享
eg:Student.native.place  输出:'湖北'

类方法:使用@classmethod修饰的方法,使用类名称直接访问的方法
eg:Student.cm()    输出: '类方法' 

静态方法:使用@staticmethod修饰的方法,使用类名直接访问的方法
eg:Student.sm()    输出: '静态方法'

"""
stu = Student('张三',21)
print('stu.native_place\t'+stu.native_place)
stu.native_place = '武汉'
print('stu.native_place\t'+stu.native_place)
print('Student.native_place\t'+Student.native_place)


#类的继承和派生
#所谓的派生：子类定义自己新的属性，如果与父类同名，以子类自己的为准。
#子类属性查找，一定是优先查找自己本身的属性和特征，在本身没有的情况下，再去父类中查找。
#也可以看到子类继承了父类,父类的初始化变量要有定义，在子类中才能得到应用。
class Student:
    def __init__(self,name,age):
        self.name1 = name
        self.age1  = age
    def o2(self):
        print ('test')
class test(Student):
    def __init__(self,o,name,age):
        super().__init__(name,age)   #super调用了父类的属性
        self.o1 = o
    def o_print(self):
        print ("is a %s" %self.o1)
    def f_print(self):
        print ("is a %s" %self.name1)
asd = test('asd','张三','1')
asd.o_print()
asd.o2()
