from contextlib import contextmanager
import re
from typing import ContextManager  

#计算概率分布
def ratio_percentage(ALT_element,Probability_information): #这里的Probability_information就是原表中每个样本的格式信息具体数值
    Alt_count = len(ALT_element.split(","))
    if Alt_count == 2 and re.search(r"\*",ALT_element):
        ALT_list = ALT_element.split(",")
        ALT_list.remove("*")
        Probability_information_list =  Probability_information.split(":")
        mutation_num = Probability_information_list[1].split(",")[2]
        ratio1 =  round(int(mutation_num)/int(Probability_information_list[2]),3)
        if ratio1==0:
            ratio1="-"
        else:
            ratio1 = f'{ALT_list[0]}:{ratio1}'
        return [ratio1,"-"]
    elif Alt_count == 2 and not re.search(r"\*",ALT_element):
        ALT_list = ALT_element.split(",")
        Probability_information_list =  Probability_information.split(":")
        mutation_num_1 = Probability_information_list[1].split(",")[1]
        mutation_num_2 = Probability_information_list[1].split(",")[2]
        ratio1 =  round(int(mutation_num_1)/int(Probability_information_list[2]),3)       
        ratio2 =  round(int(mutation_num_2)/int(Probability_information_list[2]),3)
        if ratio1==0:
            ratio1 = '-'
        else:
            ratio1 = f'{ALT_list[0]}:{ratio1}'
        if ratio2==0:
            ratio2 = '-'
        else:
            ratio2 = f'{ALT_list[1]}:{ratio2}'
        return [ratio1,ratio2]
    elif Alt_count == 1:
        Probability_information_list =  Probability_information.split(":")
        mutation_num = Probability_information_list[1].split(",")[1]
        ratio1 =  round(int(mutation_num)/int(Probability_information_list[2]),3)
        if ratio1==0:
            ratio1 = '-'
        else:
            ratio1 = f'{ALT_element}:{ratio1}'
        return [ratio1,"-"]        



with open("C:/Users/Administrator/Desktop/indel.xls",'r') as f1: 
    with open("C:/Users/Administrator/Desktop/indel_ratio.txt",'w') as f2:
        for line in f1:
            list = line.strip('\n').split('\t')
            if re.search(r"^#CHROM",list[0]): #这个if做的是输出表头
                hang_count = len(list)
                del(list[2])
                del list[4:8] #删除中间一段连续的元素
                # print (list,len(list))
                # print(list[0:2])
                sample_name_list = list[4:len(list)]
                header = list[0:4]
                # print (header)
                for i in range(len(sample_name_list)):
                    ratio_name_1 = f'{sample_name_list[i]}.ratio1'
                    ratio_name_2 = f'{sample_name_list[i]}.ratio2'
                    header.extend([ratio_name_1,ratio_name_2])   #extend()可以扩展列表元素,里面可以接另外的列表,[]表示生成列表
                header='\t'.join(header)
                print (header,file=f2)
            elif re.search(r"^test",list[0]):
                content = [] #这是为了到时候输出每行的内容做的列表
                content.extend([list[0],list[1],list[3],list[4]])
                for element in list[9:len(list)]: #list是原表读的行
                    ratio_list = ratio_percentage(list[4],element)
                    content.extend(ratio_list)
                content = '\t'.join(content)    
                print (content,file=f2)
                    # print(ratio_list)



            






