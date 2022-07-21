[toc]

### R中的循环和apply函数以及矩阵应用。
 R中最好不要使用循环，效率特别低，要是用向量计算替代循环，原因是R的for循环都是根据自身语言编写，而向量是调用的C的底层函数实现的apply家族函数，包括apply, sapply, tapply, mapply, lapply, rapply, vapply, eapply等。
 [apply函数简介以及常规循环比较](https://blog.csdn.net/kkkkkiko/article/details/83118381)