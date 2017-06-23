


[思源黑体](https://github.com/adobe-fonts/source-han-sans/tree/release)


要实现替换字体，其实很简单，就两行代码：

/*字体样式，字体阴影*/
*:not([class*="icon"]):not(i){font-family: "微软雅黑" !important;}
/*
*:not([class*="icon"]):not(i){font-family: "思源黑体 Regular" !important;}
*/
*{text-shadow:0.01em 0.01em 0.01em #999999 !important;}
保存之后就能立马看到效果了，引号中的字体可以任意替换。
我机子上试了下思源黑体，效果没有雅黑好....

/t/201393 这个帖子中的插件会导致字重有问题，有些粗体看起来和普通没区别，我这样做则不会。

然后又看到了其他的一些样式优化代码，一起分享给大家：

/*滚动条*/
::-webkit-scrollbar{width: 6px;height: 6px;}
::-webkit-scrollbar-track-piece{background-color: #CCCCCC;-webkit-border-radius: 6px;}
::-webkit-scrollbar-thumb:vertical{height: 5px;background-color: #999999;-webkit-border-radius: 6px;}
::-webkit-scrollbar-thumb:horizontal{width: 5px;background-color: #CCCCCC;-webkit-border-radius: 6px;}
::-webkit-scrollbar {width: 9px;height: 9px;}
::-webkit-scrollbar-track-piece {background-color: transparent;}
::-webkit-scrollbar-track-piece:no-button {}
::-webkit-scrollbar-thumb {background-color: #3994EF;border-radius: 3px;}
::-webkit-scrollbar-thumb:hover {background-color: #A4EEF0;}
::-webkit-scrollbar-thumb:active {background-color: #666;}
::-webkit-scrollbar-button:vertical { width: 9px; }
::-webkit-scrollbar-button:horizontal { width: 9px; }
::-webkit-scrollbar-button:vertical:start:decrement { background-color: white; }
::-webkit-scrollbar-button:vertical:end:increment { background-color: white; }
::-webkit-scrollbar-button:horizontal:start:decrement { background-color: white; }
::-webkit-scrollbar-button:horizontal:end:increment { background-color: white; }
body::-webkit-scrollbar-track-piece {background-color: white;}

/*指向图片绿光*/
img:hover{box-shadow: 0px 0px 4px 4px rgba(130,190,10,0.6) !important;-webkit-transition-property: box-shadow;-webkit-transition-duration: .31s;}
img{-webkit-transition-property: box-shadow;-webkit-transition-duration: .31s;}

/*输入框美化*/
input { border:#ccc 1px solid; border-radius: 6px; -webkit-border-radius: 6px;-webkit-border-radius: 6px;}
input[type=”text”]:focus, input[type=”password”]:focus, textarea:focus {border: 2px solid #6FA1D9 !important;-webkit-box-shadow:0px 0px 5px #6FA1D9 !important;outline:none}
input[type=”checkbox”]:focus,input[type=”submit”]:focus,input[type=”reset”]:focus, input[type=”radio”]:focus {border: 1px solid #6FA1D9 !important; outline:none}
input:focus, select:focus, textarea:focus {outline: 1px solid #10bae0 ;-webkit-outline-radius: 3px ;}
body a:hover:active {color: #10bae0;}
body *:focus {outline: 2px solid rgba(16,186,224,0.5) ;outline-offset: 1px ;outline-radius: 2px ;-webkit-outline-radius: 2px ;}
body a:focus {outline-offset: 0px ;}
body button:focus,
body input[type=reset]:focus, body input[type=button]:focus, body input[type=submit]:focus {outline-radius: 2px !important;-webkit-outline-radius: 2px !important;}
body textarea:focus, body button:focus, body select:focus, body input:focus {outline-offset: -1px !important;}

/*淡蓝色样式*/
a{-webkit-transition: all 0.3s ease-out;}
a:hover{color: #39F !important;text-shadow:-5px 3px 18px #39F !important;-webkit-transition: all 0.3s ease-out;}
*::-webkit-selection {background: #333333 !important; color: #00FF00 !important; }

/*去除下划线*/
*{text-decoration:none!important}
a:hover{text-decoration:none!important}
a{
/*color: #014A8F;*/
-webkit-transition-property:color;
-webkit-transition-duration: 0.0s;
}

/*指向文字加粗*/
a:hover {
/*color: #0000FF ;*/
-webkit-transition-property:color;
-webkit-transition-duration: 0.0s;
font-weight:bold
}






