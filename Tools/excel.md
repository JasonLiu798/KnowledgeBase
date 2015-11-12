
#求AB列差集 
c列
=IF(COUNTIF($B:$B,A2)=0,A2,"")
c列
=IF(ISERROR(VLOOKUP(A2,$B:$B,1,FALSE)), A2,"")
#交集
=IF(COUNTIF($B:$B,A2)>0,A2,"")

=VLOOKUP(A2,$B:$B,1,FALSE)
























