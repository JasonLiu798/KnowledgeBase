#!/bin/bash

function ip2locate()
{
#$1=ip
res=`wget -q -O- http://ip.ws.126.net/ipquery?ip="$1" | iconv -f gbk -t utf-8 `
#|native2ascii -reverse|iconv -f gbk -t utf-8`

#taobao
#http://ip.taobao.com/service/getIpInfo.php?ip=
#{"code":0,"data":{"country":"\u4e2d\u56fd","country_id":"CN","area":"\u534e\u4e2d","area_id":"400000","region":"\u6cb3\u5357\u7701","region_id":"410000","city":"\u90d1\u5dde\u5e02","city_id":"410100","county":"","county_id":"-1","isp":"\u7535\u4fe1","isp_id":"10

#sina
#http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=123.160.165.114
#var remote_ip_info = {"ret":1,"start":-1,"end":-1,"country":"\u4e2d\u56fd","province":"\u6cb3\u5357","city":"\u90d1\u5dde","district":"","isp":"","type":"","desc":""};

#126
#http://ip.ws.126.net/ipquery?ip=123.160.165.114
#var lo="河南省", lc="郑州市"; var localAddress={city:"郑州市", province:"河南省"}

echo $res
}


#echo `ip2locate $1`
#echo $a
