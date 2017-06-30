
广度优先搜索，抓取新浪站内10000个页面（url中含有‘sina.com.cn/’的页面）

　　抓取: urllib2.urlopen()

　　解析：htmllib.HTMLParser

　　存储：redis

　　　　每个URL对应一个IDSEQ序列（从1000000开始增加）

　　　　URL:IDSEQ　　　　　　存储URL

　　　　PAGE:IDSEQ　　　　　 存储URL对应的HTML页面源码

　　　　URLSET:IDSEQ　　　　每个URL对应一个指向它的URL（IDSEQ）集合


抽取网页正文

　　根据提陈鑫的论文《基于行块分布函数的通用网页正文抽取算法》，googlecode上的开源项目（http://code.google.com/p/cx-extractor/）

　　“作者将网页正文抽取问题转化为求页面的行块分布函数，这种方法不用建立Dom树，不被病态HTML所累（事实上与HTML标签完全无关）。通过在线性时间内建立的行块分布函数图，直接准确定位网页正文。同时采用了统计与规则相结合的方法来处理通用性问题。作者相信简单的事情总应该用最简单的办法来解决这一亘古不变的道理。整个算法实现代码不足百行。但量不在多，在法。”

　　他的项目中并没有python版本的程序，下面的我根据他的论文和其他代码写的python程序，短小精悍，全文不过50行代码：
```
#!/usr/bin/python
#coding=utf-8
#根据 陈鑫《基于行块分布函数的通用网页正文抽取算法》
#Usage: ./getcontent.py filename.html
import re
import sys
def PreProcess():
    global g_HTML
    _doctype = re.compile(r'<!DOCTYPE.*?>', re.I|re.S)
    _comment = re.compile(r'<!--.*?-->', re.S)
    _javascript = re.compile(r'<script.*?>.*?<\/script>', re.I|re.S)
    _css = re.compile(r'<style.*?>.*?<\/style>', re.I|re.S)
    _other_tag = re.compile(r'<.*?>', re.S)
    _special_char = re.compile(r'&.{1,5};|&#.{1,5};')
    g_HTML = _doctype.sub('', g_HTML)
    g_HTML = _comment.sub('', g_HTML)
    g_HTML = _javascript.sub('', g_HTML)
    g_HTML = _css.sub('', g_HTML)
    g_HTML = _other_tag.sub('', g_HTML)
    g_HTML = _special_char.sub('', g_HTML)
def GetContent(threshold):
    global g_HTMLBlock
    nMaxSize = len(g_HTMLBlock)
    nBegin = 0
    nEnd = 0
    for i in range(0, nMaxSize):
        if g_HTMLBlock[i]>threshold and i+3<nMaxSize and g_HTMLBlock[i+1]>0 and g_HTMLBlock[i+2]>0 and g_HTMLBlock[i+3]>0:
            nBegin = i
            break
    else:
        return None
    for i in range(nBegin+1, nMaxSize):
        if g_HTMLBlock[i]==0 and i+1<nMaxSize and g_HTMLBlock[i+1]==0:
            nEnd = i
            break
    else:
        return None
    return '\n'.join(g_HTMLLine[nBegin:nEnd+1])
if __name__ == '__main__' and len(sys.argv) > 1:
    f = file(sys.argv[1], 'r')
    global g_HTML
    global g_HTMLLine
    global g_HTMLBlock
    g_HTML = f.read()
    PreProcess()
    g_HTMLLine = [i.strip() for i in g_HTML.splitlines()]    #先分割成行list，再过滤掉每行前后的空字符
    HTMLLength = [len(i) for i in g_HTMLLine]    #计算每行的长度
    g_HTMLBlock = [HTMLLength[i] + HTMLLength[i+1] + HTMLLength[i+2] for i in range(0, len(g_HTMLLine)-3)]    #计算每块的长度
    print GetContent(200)
```















