import  jieba
import  numpy as np
import  codecs
import  pandas
import matplotlib.pyplot as plt
from wordcloud import WordCloud

file=codecs.open("C:/Users/Administrator/Desktop/微信词云/词云.txt",'r',encoding='utf-8')
content=file.read()
file.close()
segment=[]
segs=jieba.cut(content) #切词
for seg in segs:
    if len(seg)>1 and seg!='\r\n':
        segment.append(seg)

words_df=pandas.DataFrame({'segment':segment})
words_df.head()
stopwords=pandas.read_csv("C:/Users/Administrator/Desktop/微信词云/stopwords.txt",index_col=False,quoting=3,sep="\t",names=['stopword'],encoding="gb18030")
words_df=words_df[~words_df.segment.isin(stopwords.stopword)]


words_stat = words_df.groupby(by=['segment'])['segment'].agg([("计数",np.size)])
words_stat=words_stat.reset_index().sort_values(by="计数",ascending=False)
words_stat  #打印统计结果


import scipy
import cv2
import matplotlib.pyplot as plt
from wordcloud import WordCloud,ImageColorGenerator
bimg=cv2.imread("C:/Users/Administrator/Desktop/微信词云/图.webp")
wordcloud=WordCloud(background_color="white",mask=bimg,font_path='C:/Users/Administrator/Desktop/微信词云/浪漫雅圆.ttf')
#wordcloud=wordcloud.fit_words(words_stat.head(4000).itertuples(index=False))
words = words_stat.set_index("segment").to_dict()
wordcloud=wordcloud.fit_words(words["计数"])
bimgColors=ImageColorGenerator(bimg)
plt.axis("off")
plt.imshow(wordcloud.recolor(color_func=bimgColors))
plt.show()