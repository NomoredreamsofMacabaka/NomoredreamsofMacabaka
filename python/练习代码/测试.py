#python�е����Ժͷ���
"""
��: ���Ƕ������������ɵ�Ⱥ���ͳ�ơ��ܿ��ٰ������������ж����������
print (type(11)) <class 'int'>
print (type(12)) <class 'int'>
11,12����int���µİ��������ƵĲ�ͬ�ĸ�������Щ��������Ϊʵ�����߶���

������:1.������ 2.ʵ������ 3.��̬���� 4.�෽��
"""

class Student:
    native_place='����'  #ֱ��д�����еı�����Ϊ������
    def __init__(self,name,age):  #��ʼ������ �൱�ڸ��ඨ���������
        self.name1 = name      #self.name1��Ϊʵ������,������һ����ֵ����,���ֲ�������name����ʵ������name1
        self.age1  = age
        
    def eat(self):     #���������еĺ�����Ϊ�෽��,self�㲻д��Ҳ�����,Ҳ���Ի��ɱ�ĵ���
                       #ʵ������
        print('ѧ���ڳԷ�...')

#����֮�ⶨ��def�ĳ�Ϊ����,�����ж���ĳ�Ϊ����
#def drink():  #drinkΪ����
#    print ('��ˮ') 


#��̬����
    @staticmethod
    def sm():  #�ھ�̬�����в�����дself(��������ʲô���ַ�)
        print('��̬����')

#�෽��
    @classmethod 
    def cm(cls):   #�෽������Ҫ����һ��cls����
        print('�෽��')

#����Student��Ķ���:
stu1 = Student('����', 18)
#����������:
stu1.name1
stu1.age1

"""
С�ܽ�
������:���з�����ı�����Ϊ������,���������ж���������
eg:Student.native.place  ���:'����'

�෽��:ʹ��@classmethod���εķ���,ʹ��������ֱ�ӷ��ʵķ���
eg:Student.cm()    ���: '�෽��' 

��̬����:ʹ��@staticmethod���εķ���,ʹ������ֱ�ӷ��ʵķ���
eg:Student.sm()    ���: '��̬����'

"""
stu = Student('����',21)
stu.native_place
stu.native_place = '�人'
Student.native_place

class Student:
    native_place='����'  #ֱ��д�����еı�����Ϊ������
    def __init__(self): 
        pass
    def eat():
        print('�Զ���')


