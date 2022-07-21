#!/opt/software/bin/python3
#本脚本用于kegg功能分类基因数目统计

###可以构建A-B-D这个字典,其中A为键,值是列表形式,添加B值后带D的K号,A键对应的每个列表值是一个B-D的字符串
###字典最终呈现结果显示为:
#A大类{'B大类///K号','B大类///K号','B大类///K号','B大类///K号'}
#先读peak_kegg构建K对gene键值对,后遍历kegg_classfaction表格

import re 
import os
from itertools import islice    ###用于跳过文件表头第一行

kegg_classfaction = '/data/project/hejie/my_script/datebase/KEGG/KEGG.keg'
peak_kegg = '/nfs2/worktmp/chenzh_test/chip_seq_process/python_process/GO_KEGG_Enrich/peak.kegg'


with open(peak_kegg,'r') as S1: 
	K_gene_dic={}
	K = []
	for line in islice(S1,1,None):     ###跳过第一行
		line = line.strip('\n')
		gene_K_list = line.strip('\n').split('\t')
		if line[-6:] not in K:
			K.append(line[-6:])
			K_gene_dic[line[-6:]]=gene_K_list[0]
		else:
			K_gene_dic[line[-6:]]=f'{K_gene_dic[line[-6:]]},{gene_K_list[0]}'

# for key,value in K_gene_dic.items():
# 	print ("\nkey:"+key)
# 	print (value)

with open(kegg_classfaction,'r') as S2:
	A_B_D={}
	A_list=[]    ###记录需要遍历的Akey
	for line in S2:
		line = line.strip('\n')
		if (re.search(r'^A',line)):
			tmp_A = line[7:]
			A_B_D[tmp_A]=[]
		elif (re.search(r'^B ',line)):
			tmp_B = line[9:]
			tmp_B = f'{tmp_B}///'   #打///为了后面分割B和D
			A_B_D[tmp_A].append(tmp_B)
		elif (re.search(r'^D',line)):
			if line[7:13] in K_gene_dic.keys():
				if tmp_A not in A_list:
					A_list.append(tmp_A)
				B=len(A_B_D[tmp_A])-1
				A_B_D[tmp_A][B]=f'{A_B_D[tmp_A][B]},{K_gene_dic[line[7:13]]}'
# for key,value in A_B_D.items():
# 	print ("\nkey:"+key)
# 	print (value)



print('firstType','secondType','count','gene',sep='\t')
for A_key in A_list:
	# print(A_B_D[A_key])
	i = 0
	while i <= len(A_B_D[A_key])-1:
		list_tmp=A_B_D[A_key][i].split('///,')
		if len(list_tmp) == 2 :
			gene_num=len(set(list(list_tmp[1].split(','))))    ###去重gene,由于不同的K号可能代表了同样的gene,所以在进行添加的时候可能会存在重复gene
			print (A_key,list_tmp[0],gene_num,list_tmp[1],sep='\t')
		i+=1
		

