


daemon
http://www.cnblogs.com/montya/archive/2013/01/06/python.html

http://www.360doc.com/content/14/0208/23/13008142_350861806.shtml

http://www.cnblogs.com/wuerping/archive/2005/10/29/264671.html





---
cgi
<html>
<head>
     <title>Haha</title>
</head>
<body>
<form action="/cgi-bin/friends1.py">
<p>Enter your name:</p>
<input type=text name=person value="New User" size=15>
<p>How old are you?</p>
<input type=radio name=howmany value="0" checked>0
<input type=radio name=howmany value="10" >10
<input type=radio name=howmany value="20" >20
<p>
<input type=submit>
</form>
</body>
</html>


228597961

0513 81961076

#!/usr/bin/env python

import cgi

reshtml='''Content-Type: text/html\n
<html><head><title>
Hello
</title></head>
<body>
<h3>haha</h3>
Hello,%s you have %s d
</body></html>'''

form=cgi.FieldStorage()
who=form['person'].value
howmany=form['howmany'].value
print (reshtml % who,howmany)










