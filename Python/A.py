#!/bin/env python
#-*- coding:utf-8 -*-
#

l=[3,1,4,2]
l=[3,1,4,2,6,8,5]
def insertSortInplace(l):
    for i in range(1,len(l)):
        for j in range(0,i):
            # print 'j',j,'i',i,l
            if l[i]<l[j]:
                tmp=l[i]
                # print range(j,i)
                for k in range(i,j,-1):
                    l[k]=l[k-1]
                l[j]=tmp
                break

insertSortInplace(l)
print l
