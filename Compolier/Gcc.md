

gcc 常用选项

-v ：查看gcc版本号 
-I：注意这是大写的 i，指定头文件目录，注意-I和目录之间没有空格 
-c ：只编译，生成.o文件，不进行链接 
-g ：包含调试信息 
-On ：n=0∼3 编译优化，n越大优化得越多 
-Wall ：提示更多警告信息 
-D ：编译时定义宏，注意-D和之间没有空格 
-E ：生成预处理文件 
-M ：生成.c文件与头文件依赖关系以用于Makefile，包括系统库的头文件 
-MM ：生成.c文件与头文件依赖关系以用于Makefile，不包括系统库的头文件 
-wl,option ：该选项把 option 传递给 linker，option选项用逗号分割
掌握这些常用的基本够用，后面如果用的别的命令，会在使用中进一步说明 。











