




http://blog.csdn.net/yczz/article/details/39034223


java -agentlib:<agent-lib-name>=<options> Sample
注意，这里的共享库路径是环境变量路径，例如 java -agentlib:foo=opt1,opt2，java启动时会从linux的LD_LIBRARY_PATH或windows的PATH环境变量定义的路径处装载foo.so或foo.dll，找不到则抛异常

java -agentpath:<path-to-agent>=<options> Sample
这是以绝对路径的方式装载共享库，例如 java -agentpath:/home/admin/agentlib/foo.so=opt1,opt2



# 使用

```java
// agentmain方式
public class AgentAfterMain  
{  
    public static void agentmain(String args, Instrumentation inst)  
    {  
        System.out.println("loadagent after main run.args=" + args);  
  
        Class<?>[] classes = inst.getAllLoadedClasses();  
  
        for (Class<?> cls : classes)  
        {  
            System.out.println(cls.getName());  
        }  
  
        System.out.println("agent run completely.");  
    }  
}  

public class RunAttach  
{  
  
    public static void main(String[] args) throws Exception{  
        // args[0]传入的是某个jvm进程的pid  
        String targetPid = args[0];  
        VirtualMachine vm = VirtualMachine.attach(targetPid); 
        vm.loadAgent("xxx/agentmain.jar",  
                "toagent");  
    }  
}  
```


[构建Java Agent，而不是使用框架](http://www.importnew.com/15768.html)
https://github.com/raphw/byte-buddy

[Native Agent Vs Java Agent利与弊](http://mini.eastday.com/mobile/171216134416011.html)






