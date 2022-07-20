###文件处理
```python
#跳过表头，记录并且输出：
file.readline()  #或者使用next(file)
for line in file:
    line=line.strip()
    print(line)
```

