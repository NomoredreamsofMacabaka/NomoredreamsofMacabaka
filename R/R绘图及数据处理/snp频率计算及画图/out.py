from os import lseek, remove, sep
import re
snp = 'C:/Users/Administrator/Desktop/snp_ratio.txt'
sample_name = 'C:/Users/Administrator/Desktop/sample_name.txt'
with open(sample_name,'r') as f3:
    for line in f3:
        sample_name_list=line.strip('\n').split('\t')

with open(snp,'r') as f1:
    for line in f1:
        file_num = 0
        list = line.strip('\n').split('\t')
        if not re.search(r"#CHROM",list[0]):
            for i in range(4,len(list)):
                if i%2==0:
                    with open('C:/Users/Administrator/Desktop/test/'+sample_name_list[file_num]+'.txt','a') as f2:
                        Alt = list[3].split(',')
                        if len(Alt)==2 and not re.search(r"\*",list[3]):
                            if not re.search(r"-",list[i]):
                                ratio=list[i].split(":")[1]
                                print (list[1],Alt[0],ratio,file=f2,sep='\t')
                            if not re.search(r"-",list[i+1]):
                                ratio=list[i+1].split(":")[1]
                                print (list[1],Alt[1],ratio,file=f2,sep='\t')
                        elif len(Alt)==2 and re.search(r"\*",list[3]):
                            Alt.remove("*")
                            if not re.search(r"-",list[i]):
                                ratio=list[i].split(":")[1]
                                print (list[1],Alt[0],ratio,file=f2,sep='\t')
                        elif len(Alt)==1:
                            if not re.search(r"-",list[i]):
                                ratio=list[i].split(":")[1]
                                print (list[1],Alt[0],ratio,file=f2,sep='\t')
                else:
                    file_num+=1

