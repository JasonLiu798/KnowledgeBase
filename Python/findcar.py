
v3
#!/usr/bin/python

'''
<version>2</version>
<author>ernest</author>
<history>
2012-09-25     v0.1     findCarInTSLog.py [-c]  simCardNum day
2012-09-25     v0.2     add usage(),isNum()
2012-09-27     v0.3     add arg [hour1] [hour2] to filter hour1~hour2 files,change -c to third args
</history>
'''

import sys
import string
import os

#stable args
LOGDIR='/root/Desktop/GpsBGServer/TransmissionServer8000/log'
#LOGDIR='D:\\testdata'
PREFIX='Full'
YEAR='2012'
WROD2SHOW=100

def usage():
     print '''usage: findCarInTSLog.py simCardNum day [-c] [hour1] [hour2]
               -c          change simCardNum to hex
               simCardNum     car's terminal number or the sim card num
               time          which day you want to find,format:MM-DD
               hour1          start hour
               hour2          end hour(if only have start hour,the end hour will be 00,)
          ask more:hch1317@foxmail.com'''
     sys.exit(1)
    
def filterFilesByDay(day):
     L = os.listdir( LOGDIR )
     tmpL=[]
     tmpFileName=PREFIX+YEAR+'-'+day
     cnt=0
     for i in L:
          idx=i.find(tmpFileName)
          if idx == 0:
               tmpL.append(i)
     return tmpL

def filterFilesByHour(L,day,h1,h2):
     resL=[]
     str1=PREFIX+YEAR+'-'+day+' '+h1
     str2=PREFIX+YEAR+'-'+day+' '+h2
    
     for f in L:
          if f>=str1 and f<=str2:
               resL.append(f)
     #print 'DEBUG--',resL
     return resL
    
#judge the str is in the file,filename and path was given in parameter filename
def isInFile(str,filename):
     f=open(filename,'r')
     allLines=f.readlines()
     f.close()
     res=0
     cnt = 1
     for eachLine in allLines:
          idx=eachLine.find(str)
          if idx>0:
               res = 1
               print eachLine[0:]
               cnt+=1
     cnt=cnt-1
     if cnt>0:
          print filename,'contains',str,cnt,'times.'
          print '--------------------------------------------------'
     return res

#change phonenum to hex
def phone2hex(phoneStr):
     res = ''
     for i in phoneStr:
          res = res +'3'+i
     return res

def findWhichFile(L,str):
     existFiles = []
#     print 'find in these files',L
     for file in L:
          res = isInFile(str,LOGDIR+os.sep+file)
          if res==1:
               existFiles.append(file)
     return existFiles

#check hour arg is good format
def chkhour(hr):
     res =0
     if isNum(hr) and len(hr)==2:
          res =1
     return res

#chk is a num
def isNum(str):
     res = 1
     numLs = ['0','1','2','3','4','5','6','7','8','9']
     numCnt = 0
     for itr in str:
          for anum in numLs:
               if itr ==anum:
                    numCnt+=1
     if numCnt != len(str):
          res=0
     return res
    
#check args and call func
def chkArgs():
     argc=len(sys.argv)
     if argc < 3:
          usage()
     sim = ''
     day =''
     hour1='00' #start hour
     hour2='23' #end hour
     if argc >=3:
          if isNum(sys.argv[1]):     #check sim num is number
               #3 args 
               #findCarInTSLog simCardNum time
               sim=sys.argv[1]
               day=sys.argv[2]
               #4 args
               #change phone to hex or find car by hour1
               #findCarInTSLog simCardNum time [-c]
               #findCarInTSLog simCardNum time [hour1]
               if argc == 4:
                    if sys.argv[3]=='-c':
                         sim=phone2hex(sys.argv[1])     #change sim num to hex
                    elif isNum(sys.argv[3]) and len(argv[3])==2: #check hour1 is a number and length=2
                         hour1=sys.argv[3]
               #5 args
               #findCarInTSLog simCardNum time [-c]     [hour1]
               #findCarInTSLog simCardNum time [hour1] [hour2]
               elif argc == 5:
                    if sys.argv[3]=='-c':
                         sim=phone2hex(sys.argv[1])     #change sim num to hex
                    elif chkhour(sys.argv[3]) and chkhour(sys.argv[4]): #check hour1 is a number and length=2
                         hour1=sys.argv[3]
                         hour2=sys.argv[4]
               #6 args
               #findCarInTSLog simCardNum time [-c]     [hour1] [hour2]
               elif argc == 6:
                    if sys.argv[3]=='-c':
                         sim=phone2hex(sys.argv[1])     #change sim num to hex
                         if  chkhour(sys.argv[4]) and chkhour(sys.argv[5]):
                              hour1=sys.argv[4]
                              hour2=sys.argv[5]
          else:
               usage()
     else:
          usage()
    
     EXTL=findWhichFile(
          filterFilesByHour(
               filterFilesByDay(day),day,hour1,hour2)
          ,sim)
     print 'Find ',sim,' in these files: '
     for i in EXTL:
          print i
    
    
if __name__ == '__main__':
     chkArgs()
    
v4.5
#!/usr/bin/python

'''
<version>3</version>
<author>ernest</author>
<history>
2012-09-25     v0.1     findCarInTSLog.py [-c]  simCardNum day
2012-09-25     v0.2     add usage(),isNum()
2012-09-27     v0.3     add arg [hour1] [hour2] to filter hour1~hour2 files,change -c to third args
2012-09-28     v0.4    
</history>
'''

import sys
import string
import os

#STATIC STRS
LOGDIR='/root/Desktop/GpsBGServer/TransmissionServer8000/log'
#LOGDIR='D:\\testdata'
PREFIX='Full'
YEAR='2012'
WROD2SHOW=100

def usage():
     print '''usage:
               findCarInTSLog.py -so simCardNum day [-c] [hour1] [hour2]
                    -sd     find single car in oneday [hour1~hour2]
                    simCardNum     car's terminal number or the sim card num
                    day     which day you want to find,format:MM-DD
                    -c     change simCardNum to hex
                    hour1          start hour,default 00
                    hour2          end hour,default 23
               findCarInTSLog.py -st simCardNum day1 [hour1] day2 [hour2] [-c]
                    -ss     find single car in day1[hour1]~day2[hour2]
                    other args'meaning same as upons
               findCarInTSLog.py -as day1 [hour1] day2 [hour2]
                    -as     find all cars in day1[hour1]~day2[hour2],only give the file list
                    other args'meaning same as upons
               ask more:hch1317@foxmail.com'''
     sys.exit(1)
    
def filterFilesByDay(day):
     L = os.listdir( LOGDIR )
     resL=[]
     tmpFileName=PREFIX+YEAR+'-'+day
     cnt=0
     for i in L:
          idx=i.find(tmpFileName)
          if idx == 0:
               resL.append(i)
     return resL

def filterFilesByHour(L,day,h1,h2):
     resL=[]
     str1=PREFIX+YEAR+'-'+day+' '+h1
     str2=PREFIX+YEAR+'-'+day+' '+h2
    
     for f in L:
          if f>=str1 and f<=str2:
               resL.append(f)
     #print 'DEBUG--',resL
     return resL
    
#judge the str is in the file,filename and path was given in parameter filename
def isInFile(str,filename):
     f=open(filename,'r')
     allLines=f.readlines()
     f.close()
     res=0
     cnt = 1
     tmpShowStr=''
     for eachLine in allLines:
          idx=eachLine.find(str)
          if idx>0:
               res = 1
               tmpShowStr=tmpShowStr+eachLine[0:]
               #print eachLine[0:]
               cnt+=1
     cnt=cnt-1
     if tmpShowStr!='':
          print tmpShowStr
     if cnt>0:
          print filename,'contains',str,cnt,'times.'
          print '--------------------------------------------------'
     return res

#change phonenum to hex
def phone2hex(phoneStr):
     res = ''
     for i in phoneStr:
          res = res +'3'+i
     return res

def findWhichFile(L,str):
     existFiles = []
#     print 'find in these files',L
     for file in L:
          res = isInFile(str,LOGDIR+os.sep+file)
          if res==1:
               existFiles.append(file)
     return existFiles

#check hour arg is good format
def chkhour(hr):
     res =0
     if isNum(hr) and len(hr)==2:
          res =1
     return res

#chk is a num
def isNum(str):
     res = 1
     numLs = ['0','1','2','3','4','5','6','7','8','9']
     numCnt = 0
     for itr in str:
          for anum in numLs:
               if itr ==anum:
                    numCnt+=1
     if numCnt != len(str):
          res=0
     return res
    
#check args and call func
def chkArgs():
     argc=len(sys.argv)
     if argc < 3:
          usage()
     sim = ''
     day1 =''
     day2 =''
     hour1='00' #start hour
     hour2='23' #end hour
     if argc >=3:
          #S1:findCarInTSLog.py -so simCardNum day [-c] [hour1] [hour2]
          #S2:findCarInTSLog.py -st simCardNum day1 [hour1] day2 [hour2] [-c]
          if sys.argv[1] == '-so' or sys.argv[1]=='-ss':
               if isNum(sys.argv[2]):     #check sim num is number
                    #3 args 
                    #findCarInTSLog simCardNum time
                    sim=sys.argv[2]
                    day1=sys.argv[2]
                    #4 args
                    #change phone to hex or find car by hour1
                    #findCarInTSLog simCardNum time [-c]
                    #findCarInTSLog simCardNum time [hour1]
                    if argc == 4:
                         if sys.argv[3]=='-c':
                              sim=phone2hex(sys.argv[1])     #change sim num to hex
                         elif isNum(sys.argv[3]) and len(argv[3])==2: #check hour1 is a number and length=2
                              hour1=sys.argv[3]
                    #5 args
                    #findCarInTSLog simCardNum time [-c]     [hour1]
                    #findCarInTSLog simCardNum time [hour1] [hour2]
                    elif argc == 5:
                         if sys.argv[3]=='-c':
                              sim=phone2hex(sys.argv[1])     #change sim num to hex
                         elif chkhour(sys.argv[3]) and chkhour(sys.argv[4]): #check hour1 is a number and length=2
                              hour1=sys.argv[3]
                              hour2=sys.argv[4]
                    #6 args
                    #findCarInTSLog simCardNum time [-c]     [hour1] [hour2]
                    elif argc == 6:
                         if sys.argv[3]=='-c':
                              sim=phone2hex(sys.argv[1])     #change sim num to hex
                              if  chkhour(sys.argv[4]) and chkhour(sys.argv[5]):
                                   hour1=sys.argv[4]
                                   hour2=sys.argv[5]
               else:
                    usage()
     else:
          usage()
    
     EXTL=findWhichFile(
          filterFilesByHour(
               filterFilesByDay(day1),day1,hour1,hour2)
          ,sim)
     print 'Find ',sim,' in these files: '
     for i in EXTL:
          print i
    
    
if __name__ == '__main__':
     chkArgs()
    
    

     