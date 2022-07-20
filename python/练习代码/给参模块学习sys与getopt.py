###给参模块学习sys与getopt

import  sys 
import  os
import getopt

# args = '-a -b -c -d1 bar a1 a2 a3'.split()
# # outlist,arg = getopt.getopt(args,'abcfood:')
# # print(outlist)
# # print(arg)
# outlist,arg = getopt.getopt(args,'abc:d:')
# print(outlist)
# print(arg)
"""
运行命令看出getopt()会返回两个列表,第一个列表返回的是参数选项和参数值,第二个列表返回的是参数值
getopt()能识别'-','c:'中的':'可以让'foo'变成c的参数值并且返回在第一个列表c对应的参数值位置
"""

def site():
    name = None
    url  = None
    argv = sys.argv[1:]
    # print (argv)

    try:
        opts,args = getopt.getopt(argv, "n:u:")   #短选项模式
    except:
        print("Error:参数问题")
    else:
        print (opts,args,sep='\n')
    # for opt,arg  in opts:
    #     if opt in ['-n']:
    #         name = arg
    #     elif opt in ['-u']:
    #         url  = arg
    # print (name+" "+url)

site()











