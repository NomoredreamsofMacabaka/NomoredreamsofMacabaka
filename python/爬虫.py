# -*- coding: utf-8 -*-


from bs4 import     BeautifulSoup
import requests
import re
if __name__=='__main__':
    target = 'http://www.biqukan.com/1_1094/'
    req    = requests.get(url=target)
    req.encoding = req.apparent_encoding  #apparent_encoding查看网页返回的字符集类型
    html = req.text
    bf   = BeautifulSoup(html)  #beautifulsoup把html转换成了特殊的格式,
                                                #features就是代表解释器是什么
                                                #我猜测相当于把html这个输入用'lxml'
                                                #解译了导入到bf,如果不加这个参数,Beautifulsoup
                                                #会自动识别文件内容去找解释器解译
    #print(html.meta)      #会报错,因为html是没有经过解释器解译的
    #print(bf.meta)        #这个就可以提出第一个meta的相关信息
                          #这里输出meta说内容是utf-8但是实际上内容原本为简体中文gbk
                          #这是由于Beautiful Soup自动将输入文档转换为Unicode编码,
                          #输出文档转换为utf-8编码。
    texts = bf.find_all('div',class_='listmain') #class_中'_'是为了避免python本有的class冲突
    #这里的find_all()是Beautifulsoup带的函数,该操作取出了网页的listmain也就是小说目录
    #print(texts[0])  #find_all()函数返回的是一个查到到内容的列表
    mid   = BeautifulSoup(str(texts[0]),features='lxml')
    table_of_Contents = mid.find_all('a')    
    num = 0
    judment = 0
    for chapter in table_of_Contents:
        if (re.match('章节目录',chapter.string)):
            judment = 1
        if (judment == 1):
            print(chapter.string)  #string属性可以提取出内容
        num+=1
        if num == 20:
            break
        
req = requests.get(url = 'http://www.biqukan.com//1_1094/22744708.html')
req_text = req.text
req_mid = BeautifulSoup(req_text,features='lxml')
content = req_mid.find_all('div',class_='showtxt')
content = content[0].text.replace('\xa0'*8,'\n\n')
print (content)    
    

    

