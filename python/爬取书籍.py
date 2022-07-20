#爬取书籍
from os import write
import re
import requests
import sys
from bs4 import BeautifulSoup

class downloader(object):
    def __init__(self):
        self.server= 'http://www.biqukan.com/'
        self.target= 'http://www.biqukan.com/1_1094/'
        self.names = []
        self.urls  = []
        self.nums  = 0

# server记录爬取的http地址的首页
# target记录爬取的目标书籍
# self.names记录每个章节名称
# self.urls 记录每个章节网址
# self.nums 记录章节的数目
    
#该函数存储url和章节name
    def get_download_url(self):
        req = requests.get(url = self.target)
        req.encoding = req.apparent_encoding            #apparent_encoding查看网页返回的字符集类型
        html=req.text
        bf = BeautifulSoup(html)
        listmain = bf.find_all('div',class_='listmain')  #class_是为与python自带的class类相区别
        mid   = BeautifulSoup(str(listmain[0]))
        a_herf= mid.find_all('a')                        #find_all是需要BeautifulSoup转换后才能够支持的,来源于同一个包
        judgment = 0      
        for element in a_herf:
            if re.match('章节目录',element.string):         #匹配开始章节，舍去不要的前缀章节
                judgment = 1
                url = self.server + element.get('href')  #get可以获取element的herf属性,但是只能提取第一个,提取所有需要用到find_all
                self.urls.append(url)
                self.names.append(element.string)   #string用于提取文字信息
                self.nums+=1
            if judgment == 1:
                url = self.server + element.get('href')  
                self.urls.append(url)
                self.names.append(element.string)
                self.nums+=1


#该函数下载每章节文字内容
    def get_download_text(self,target):  #这里的target指的是每章节的http后缀
        req = requests.get(url = target)
        html= req.text
        mid = BeautifulSoup(html)
        content = mid.find_all('div',class_='showtxt')
        content = content[0].text.replace('\xa0'*8,'\n\n')
        return content


#该函数用于写入内容
    def writer(self, path , charpter_name , charpter_content):
        with open(path, 'a' , encoding = 'utf-8') as f :
            f.write(charpter_name + '\n')
            f.writelines(charpter_content)
            f.write('\n\n')
    

if __name__ == '__main__':   #相当于c中的main函数,作为python程序的入口
    dc = downloader()
    dc.get_download_url()    #调用get_download_url方法先存入每个章节的url号
    print ('一念永恒下载:')
    for i in range(dc.nums):
        #print (dc.get_download_text(dc.urls[i]))
        dc.writer('C:/Users/Administrator/Desktop/一念永恒.txt',dc.names[i],dc.get_download_text(dc.urls[i]))
        sys.stdout.write("  已下载:%.3f%%" %  float(i/dc.nums) + '\r')    #'\r'表示回车键
        sys.stdout.flush()
    print ('下载完成')
















               




        

