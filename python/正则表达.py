import re

# []匹配[]内的任意一个内容
# ()将()的内容作为一个整体来进行匹配
# 贪婪表示会尽可以多的匹配符合条件的字符，非贪婪则为尽可以少的匹配。


# #模式一    简单匹配 re.match , re.search 和 re.findall
# print(re.findall(r"ran|run", "run ran ran ran"))           #re.search和re.match都是匹配一次,findall是匹配所有,返回的是一个列表
# for i  in r:
#     print(i)
# print(re.search("cat", "dog runs to cat cat").group()) # .group()用于把匹配结果分组
# print(re.search("cat", "dog runs to cat cat").span())  # .span()可以输出匹配到的元素的index
# a = "123abc456"
# print re.search("([0-9]*)([a-z]*)([0-9]*)",a).group(0)   #123abc456,返回整体
# print re.search("([0-9]*)([a-z]*)([0-9]*)",a).group(1)   #123
# print re.search("([0-9]*)([a-z]*)([0-9]*)",a).group(2)   #abc
# print re.search("([0-9]*)([a-z]*)([0-9]*)",a).group(3)   #456



# #模式二    灵活匹配multiple patterns   匹配潜在的多个可能性文字，可用 [] 将可能的字符囊括起来
# print(re.search(r'r[au]n', "dog runs to cat").group())


#模式三      sub替换操作
#re.sub(pattern, repl, string, count=0)   #count控制的是替换的次数
#repl : 替换的字符串，也可为一个函数。count : 模式匹配后替换的最大次数，默认 0 表示替换所有的匹配
print(re.sub(r"r[au]ns", "catches", "dog runs runs to cat",count=1))
def double(matched):
    value = int(matched.group('value'))
    return str(value * 2)
s = 'A23G4HFD567'
print (re.sub('(?P<value>\d+)',double,s))   
###看官方文档https://docs.python.org/3.9/library/re.html
###(?P<name>...)与常规括号类似，但组匹配的子字符串可通过符号组名name 访问。组名必须是有效的 Python 标识符
###并且每个组名只能在正则表达式中定义一次。符号组也是编号组，就好像该组没有命名一样。
###我的理解:相当于(?P<name>...)中name为函数所需要的检测的变量值,后面的\d+表示name所代表的值

