import base64


image_path = 'C:/Users/Administrator/Desktop/小提琴图.PNG'
image_result = 'C:/Users/Administrator/Desktop/base64_result.txt'
with open(image_path,'rb') as f1:
    with open(image_result,'w') as f2:
        image = f1.read()
        image_base64 = str(base64.b64encode(image), encoding='utf-8')
        print (image_base64,file=f2)
