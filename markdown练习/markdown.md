# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题


我展示的是一级标题
=================

我展示的是二级标题
----------------  

# 段落换行
段落的换行是使用两个以上空格加上回车  
以在段落后面使用一个空行来表示重新开始一个段落。
阿斯顿  
阿斯顿

# 字体
*斜体文本*  
_斜体文本_    
**粗体文本** __粗体文本__ ***粗斜体文本*** ___粗斜体文本___  


# 分隔线  
你可以在一行中用三个以上的星号、减号、底线来建立一个分隔线，行内不能有其他东西。你也可以在星号或是减号中间插入空格。下面每种写法都可以建立分隔线：
***  
***
* * *
---
- - - - 


# 删除线
### ~~baidu~~ 字符前后加上两个'~'即可

# 下划线
 下划线可以通过 HTML 的 <u> 标签来实现 </u>：  
 <u>带下划线文本</u>  


# 脚注  
创建脚注格式类似这样[^RUNOOB]。  
[^RUNOOB]: 伞兵教程

使用 Markdown[^1]可以效率的书写文档, 直接转换成 HTML[^2], 你可以使用 Typora[^T] 编辑器进行书写。  
[^1]:Markdown是一种纯文本标记语言  
[^2]:HyperText Markup Language 超文本标记语言  
[^T]:NEW WAY TO READ & WRITE MARKDOWN.
# Markdown 列表
Markdown 支持有序列表和无序列表。  

无序列表使用星号(*)、加号(+)或是减号(-)作为列表标记，这些标记后面要添加一个空格，然后再填写内容：
### 无序列表
* 第一项
* 第二项 **奥特曼**
* 第三项

+ 第一项 asd1
+ 第二项 sdfsdf21
+ 第三项

### 有序列表
1. 第一项
2. 第二项
3. 第三项

### 列表嵌套
1. 第一项：
    - 第一项嵌套的第一个元素
    - 第一项嵌套的第二个元素
2. 第二项：
    - 第二项嵌套的第一个元素
    - 第二项嵌套的第二个元素

# Markdown区块
Markdown 区块引用是在段落开头使用 > 符号 ，然后后面紧跟一个空格符号：
> 区块引用  
> > asd1   
> 
> 菜鸟教程  
> 学的不仅是技术更是梦想

# Markdown代码
如果是段落上的一个函数或片段的代码可以用反引号把它包起来（`），例如：  

`print() 函数`   
你也可以用 ``` 包裹一段代码，并指定一种语言（也可以不指定）：
```python
for i in list :
    print (i)
```


# Markdown链接
链接使用方法如下：  
[链接名称](链接地址)  
[菜鸟教程](https://www.runoob.com)  
或者  
<https://www.runoob.com>
<链接地址>

### 高级链接
可以通过变量来设置一个链接，变量赋值在文档末尾进行：
这个链接用 1 作为网址变量 [Google][1]
这个链接用 runoob 作为网址变量 [Runoob][baidu]
然后在文档的结尾为变量赋值（网址）    

[1]: https://www.google.com
[baidu]: http://www.baidu.com/


# 流程图
```flow
st=>start: Start
op=>operation: Your Operation
cond=>condition: Yes or No?
e=>end
st->op->cond
cond(yes)->e
cond(no)->op
```



# 字体颜色修改
<font face="黑体">我是黑体字</font>
<font face="微软雅黑">我是微软雅黑</font>
<font face="STCAIYUN">我是华文彩云</font>
<font color=red>我是红色</font>
<font color=#008000>我是绿色</font>
<font color=Blue>我是蓝色</font>
<font size=5>我是尺寸</font>
<font face="黑体" color=green size=5>我是黑体，绿色，尺寸为5</font>
