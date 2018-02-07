

方法一： 
最简单也是最直接的方法就是直接修改DomNode的style属性： 
如下面的代码`

var node = document.getElementById('node');
node.style.color = 'red';
方式二： 
因为表现应该是表现层的也就是css所所的事，所以可以这样代码如下：

 var node = document.getElementById('node');
 node.className = 'testStyle';
方法三： 
上面两个方式都不适用于批量处理；接下来是第三种代码如下

<script type="text/javascript">
    //创建一个结点，把传入的参数当作样式
        function addStyleNode(str){
            var styleNode = document.createElement('style');
            styleNode.type  = 'text/css';
            if(styleNode.styleSheet){
                styleNode.styleSheet.cssText = str;//ie下要通过style.cssText进行写操作
            }else{
                styleNode.innHTML = str;//firefox可以直接对innHTML进行操作
            }
            document.getElementsByTagName('head')[0].appendChild(styleNode);
        }
        addStyleNode('span{font-size:40px;background:#000,color:#fff} #test{color:red}');
    </script>







    
