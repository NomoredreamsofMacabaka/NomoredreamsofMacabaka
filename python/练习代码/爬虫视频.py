#HTTP,Hypertext Transfer Protocol 超文本传输协议
#HTTP是一个基于"请求和响应"模式的、无状态的(指第一次请求和第二次请求之间没有关联)、应用层协议

# from typing import KeysView
# from bs4 import BeautifulSoup
# import  os
# import  re
# import  requests

# r = requests.get("https://29884.long-vod.cdn.aodianyun.com/u/29884/m3u8/1920x1080/1080-5ad7a0670bcc465e9c5b2dd1b654d2e6/1080-5ad7a0670bcc465e9c5b2dd1b654d2e6.m3u8")
# print (r.status_code)   ##返回访问状态码,如果是200就是访问成功,其他的就是失败
# r.headers      ##返回get请求返回的头部信息
# r.encoding     ##因为recoding的编码值是从http的header中的charset中获取的,如果header没有这个字段就返回默认值
# r.apparent_encoding    ##apparent_encoding是根据http的内容部分,分析内容中文本可能的编码模式

# sourcery skip: avoid-builtin-shadow
"""
爬虫网页通用框架

def getHTMLText(url):
    try:
        r = requests.get(url, timeout=30)
        r.raise_for_status   ##如果状态不是200,引发HTTPError异常
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return "产生异常"

if __name__ == "__mian__":
    url = "http://www.baidu.com"
    print (getHTMLText(url))
"""


##测试更改

"""
###更改自己的头部信息,伪装模拟成浏览器向目标网站发送请求,而不是以python的requests库

r = requests.get("https://www.amazon.cn/?tag=baidhydrcnnv-23&ref=GS_sw_baidu_pc_ppccs_0004")
r.status_code
r.encoding
r.request.headers   #返回{'User-Agent': 'python-requests/2.25.1', 'Accept-Encoding': 'gzip, deflate', 'Accept': '*/*',                   # 'Connection': 'keep-alive'}
                    #构建模拟键值对
kv = {'user-agent':'Mozilla/5.0'}     ##user-agent':'Mozilla/5.0是浏览器常用的名称
url  = "https://www.amazon.cn/?tag=baidhydrcnnv-23&ref=GS_sw_baidu_pc_ppccs_0004"
url  = requests.get(url,headers = kv)
url.request.headers #返回{'user-agent': 'Mozilla/5.0', 'Accept-Encoding': 'gzip, deflate', 'Accept': '*/*', 'Connection': 'keep-alive'}
"""



"""
###通过requests库来访问百度的搜索接口
kv = {'wd':'Python'} 
r = requests.get("https://www.baidu.com/s", params = kv)
r.status_code
r.request.url       #'https://www.baidu.com/s?wd=Python'即转到百度搜索python词条的网页
"""



"""
# 胡广的脚本:
#coding=utf-8

import time
from multiprocessing.dummy import Pool #使用进程创建线程池
import requests
import re,os
from lxml import etree
import sys

header = {'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'}

process = int(sys.argv[1])

#srcURL = http://www.xingkongw.com/index.php/vod/play/id/59839/sid/1/nid/1.html
num = 1965
# num = 120
dir = './move_cache/'
if not os.path.exists(dir):
	os.mkdir(dir)
name = dir + 'su6.mp4'

urls = []
move_index = {}	
def getchunkTs(num):
	for i in range(1, num):
		path = '/20190123/26478_06fc190d/800k/hls/fd87e7217e' + str(int(9000000 + i)) + '.ts'
		url = 'https://yushou.qitu-zuida.com' + path
		urls.append((i,url))

def get_video_data(index,url):
	print(url,'正在下载......')
	movedata = requests.get(url = url, headers = header).content
	move_index[index] =  movedata
	print(url,'下载成功！')
			
# 调用函数，进行数据的爬取，可以指定关键字和下载页数,下载保存数据
getchunkTs(num)

#使用线程池对视频数据进行请求，较为耗时的阻塞操作
pool = Pool(process)
ProcessResult = [] #用于储存所有进程返回的结果
for url in urls:
	pool.apply_async(get_video_data, args = (url[0],url[1]))
# pool.map(get_video_data,urls)
pool.close()
pool.join()
print('开始合并文件......')
with open(name,'wb') as fp:
	for i in range(1, num):
		fp.write(move_index[i])
print()
print('================= 所有分片视频下载完成 =====================')
"""


import time
from multiprocessing.dummy import Pool #使用进程创建线程池
import requests
import re,os
# from lxml import etree
import sys


process = int(sys.argv[1]) #设置线程数
dir = 'E:/单细胞学习/视频爬取/sub.mp4' 

#调出html点Network再使用ctrl+R找到后缀为m3u8的url
# r = requests.get('https://29884.long-vod.cdn.aodianyun.com/u/29884/m3u8/1920x1080/1080-5ad7a0670bcc465e9c5b2dd1b654d2e6/1080-5ad7a0670bcc465e9c5b2dd1b654d2e6.m3u8')
# r.request.headers

#首现更改我们的请求头部信息,把它变成浏览器的头部信息
kv = {'User-Agent':'Mozilla/5.0'}
#切片数目
num = 5108
#zfill用来补齐0
urls = []
for i in range(num):
	path = f'https://29884.long-vod.cdn.aodianyun.com/u/29884/m3u8/1920x1080/1080-d90d3c4d3269609b7d993e34b3d98412/{str(i).zfill(5)}.ts'
	urls.append((i,path))
#查看输出
# len(urls)
# requests.get('https://29884.long-vod.cdn.aodianyun.com/u/29884/m3u8/1920x1080/1080-5ad7a0670bcc465e9c5b2dd1b654d2e6/00001.ts',headers=kv).content

move_index = {}
def get_video_data(index,url):
	print(url,'正在下载......')
	movedata = requests.get(url = url, headers = kv).content
	move_index[index] =  movedata
	print(url,'下载成功！')

#进程池管理
pool = Pool(process)
ProcessResult = [] #用于储存所有进程返回的结果
for url in urls:
	pool.apply_async(get_video_data, args = (url[0],url[1]))
# pool.map(get_video_data,urls)
pool.close()
pool.join()

print('开始合并文件......')
with open(dir,'wb') as fp:
	for i in range(num):
		fp.write(move_index[i])
print()
print('================= 所有分片视频下载完成 =====================')
