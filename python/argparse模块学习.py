import argparse
from typing import Sequence

#模式一
#eg:python  E:\python\练习代码\argparse模块学习.py  --nnn      asd
parser = argparse.ArgumentParser()
parser.add_argument("--nnn",help = 'echo the string you use here')        # add_argument()指定程序可以接受命令行选项
args  = parser.parse_args()        # parse_args()从指定的选项中返回一些数据
print(args)
print(args.nnn)

#模式二
parser = argparse.ArgumentParser()
parser.add_argument("square", help='display a square of a given number')
args   = parser.parse_args()
print (args.square**2)
# 运行python  E:\python\练习代码\argparse模块学习.py 4 
# 该模式输出会报错,argparse将我们给它的选项视为字符串，除非我们另有说明。
# 例如:
parser.add_argument('square',help='display a square of a given number',type = int)
args =parser.parse_args()
print (args.square**2)


#模式三   添加可选参数
#eg:python  E:\python\练习代码\argparse模块学习.py    --verbose   --verbosity    asd
parser = argparse.ArgumentParser()
parser.add_argument('-vb','--verbosity',help = '可选参数')
parser.add_argument('-v','--verbose',help = '可选参数' ,action = 'store_true')
#命令行如果添加了可选参数,其后必须要跟参数值,否则会报错,如果不想跟参数值就需要添加action参数
args   = parser.parse_args()        
print (args)                   #返回命令行参数与参数值的对应关系
print(args.verbosity)          #返回命令行参数--verbosity后跟的参数值
if args.verbosity:
    print ('verbosity turned on')
if args.verbose:
    print ('ok')


##模式四    测试一个数的平方给参
#eg:python  E:\python\练习代码\argparse模块学习.py   4   -v #参数值的前后顺序没有对其造成影响,因为我们定义的'-v'参数是不需要接参数值的,
#只是因为我们定义的是可选参数加了action='store_true',在后面的if判断中进行的输出,所以前后顺序不会影响输出.
#eg2:python  E:\python\练习代码\argparse模块学习.py    3  --vb  2222  
#eg3:python  E:\python\练习代码\argparse模块学习.py   --vb  2222   3 #定义的--vb后面需要加参数值,随便写不影响,因为我们的square会识别后一个3
#eg4:python  E:\python\练习代码\argparse模块学习.py  2   -vc -vc   #输出结果为8
parser = argparse.ArgumentParser()
parser.add_argument("square", help = '输出需要计算的平方数' , type = int )
parser.add_argument('-v','--verbose', help = '可选参数', action='store_true')   #参数一定要加'-'或者'--',不然就会报错,'-'默认为短参数,'--'默认为长参数
parser.add_argument('--vb', help = '可选参数',type = int)      
#action参数还有count,含义是计数特定的可选参数出现的次数
parser.add_argument('-vc','--verbosy', help = '可选参数', action='count')                 
args   = parser.parse_args()
answer = args.square**2
print (args.square)
if args.verbose :    # args.v会报错,是因为-v是短参数,args.vb不会报错,是因为给的是长参数'--'
    print ("the square of {} is {}".format(args.verbose,answer))
elif args.vb:
    print ("the square of {} is {}".format(args.vb,answer))
elif args.verbosy==1:
    print (answer + 2)
elif args.verbosy==2:
    print (answer + 4)
else:
    print (answer)



