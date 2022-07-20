#python中的属性和方法
"""
类: 类是多个类似事物组成的群体的统称。能快速帮助我们理解和判断事物的性质
print (type(11)) <class 'int'>
print (type(12)) <class 'int'>
11,12都是int类下的包含了相似的不同的个例，这些个例被称为实例或者对象

类的组成:1.类属性 2.实例方法 3.静态方法 4.类方法
"""

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


#静态方法
    @staticmethod
    def sm():  #在静态方法中不允许写self(或者其他什么的字符)
        print('静态方法')

#类方法
    @classmethod 
    def cm(cls):   #类方法中需要传递一个cls参数
        print('类方法')

#创建Student类的对象:
stu1 = Student('张三', 18)
#调用类属性:
stu1.name1
stu1.age1

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
stu.native_place
stu.native_place = '武汉'
Student.native_place

class Student:
    native_place='湖北'  #直接写在类中的变量称为类属性
    def __init__(self): 
        pass
    def eat():
        print('吃东西')


