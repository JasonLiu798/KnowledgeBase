#!/bin/bash
function trim()
{
        res=`echo $1 | sed -e "s/^[ \s]\{1,\}//g" | sed -e "s/[ \s]\{1,\}$//g"`
        echo $res
}

function contain()
{
local res=$(echo $1 | grep "$2")
echo $res
}

function isempty()
{
local res=false
local str=`trim $1`
if [ "$str" =  "" ]; then
        res=true
fi
if echo $str|grep -qe '^#' ;then
        res=true
fi
echo $res
}

function strlen()
{
    echo `expr length $1`
}


function strtrim()
{
    echo `echo "$1"`
}

#获取字符串子串
#输入：字符串 截取起始位置
#输入：字符串 截取起始位置 截取长度
function substring()
{
    if [ $# -eq 2 ]; then
        len=`strlen $1`
        echo `expr substr $1 $2 $len`
    elif [ $# -eq 3 ]; then
        echo `expr substr $1 $2 $3`
    else
        echo
    fi
}


#将字符串中字符全部转换为大写
#输入：字符串
function str_toupper()
{
    echo $(echo $1 | tr '[a-z]' '[A-Z]')
}
 
#将字符串中字符全部转换为小写
#输入：字符串
function str_tolower()
{
    echo $(echo $1 | tr '[A-Z]' '[a-z]')
}


#delete slash in filename
#input:  xxx/yyy
#output: yyy
function del_slash_in_filename()
{
local upfilepath=$1
i=1

while((1==1))
do
        split=`echo $upfilepath|cut -d "/" -f$i`
        if [ "$split" != "" ]; then
                ((i++))
        else
                ((i--))
                split=`echo $upfilepath|cut -d "/" -f$i`
                local RES=$split
                break
        fi
done
echo $RES
}

#get file name behind the path
#input: /aaa/bbb/ccc   	xxx	sdd/ddd
#output: ccc		xxx	ddd
function get_filename(){
local res=''
local raw=$1
raw=${raw#"/"}
#echo "raw $raw \r\n"

if [[ "$raw" =~ "/" ]]; then
        res=`del_slash_in_filename $raw`
else
        res=$raw
fi
echo $res
}

#TEST
#a=`del_slash_in_filename "dsfsdf/sdfds"`
#echo "a:" $a
#b=`get_filename "fdf/sdfjkldjks"`
#echo "res " $b
