----
#os
import os
环境变量
os.environ
os.path.split('/Users/michael/testdir/file.txt')
os.path.splitext()可以直接让你得到文件扩展名
列出所有目录
[x for x in os.listdir('.') if os.path.isdir(x)]
列出所有py文件
[x for x in os.listdir('.') if os.path.isfile(x) and os.path.splitext(x)[1]=='.py']


---
#fork
```
import os

print 'Process (%s) start...' % os.getpid()
pid = os.fork()
if pid==0:
    print 'I am child process (%s) and my parent is %s.' % (os.getpid(), os.getppid())
else:
    print 'I (%s) just created a child process (%s).' % (os.getpid(), pid)
```

----
#multiprocessing
```
from multiprocessing import Process
import os

# 子进程要执行的代码
def run_proc(name):
    print 'Run child process %s (%s)...' % (name, os.getpid())

if __name__=='__main__':
    print 'Parent process %s.' % os.getpid()
    p = Process(target=run_proc, args=('test',)) #创建进程实例
    print 'Process will start.'
    p.start() 
    p.join() #等待子进程结束后再继续往下运行，通常用于进程间的同步
    print 'Process end.'
```

---
#pool
```
from multiprocessing import Pool
import os, time, random

def long_time_task(name):
    print 'Run task %s (%s)...' % (name, os.getpid())
    start = time.time()
    time.sleep(random.random() * 3)
    end = time.time()
    print 'Task %s runs %0.2f seconds.' % (name, (end - start))

if __name__=='__main__':
    print 'Parent process %s.' % os.getpid()
    p = Pool() #默认大小是CPU的核数
    for i in range(5):
        p.apply_async(long_time_task, args=(i,))
    print 'Waiting for all subprocesses done...'
    p.close()
    p.join()
    print 'All subprocesses done.'
```

---
#进程间通信
```
from multiprocessing import Process, Queue
import os, time, random

# 写数据进程执行的代码:
def write(q):
    for value in ['A', 'B', 'C']:
        print 'Put %s to queue...' % value
        q.put(value)
        time.sleep(random.random())

# 读数据进程执行的代码:
def read(q):
    while True:
        value = q.get(True)
        print 'Get %s from queue.' % value

if __name__=='__main__':
    # 父进程创建Queue，并传给各个子进程：
    q = Queue()
    pw = Process(target=write, args=(q,))
    pr = Process(target=read, args=(q,))
    # 启动子进程pw，写入:
    pw.start()
    # 启动子进程pr，读取:
    pr.start()
    # 等待pw结束:
    pw.join()
    # pr进程里是死循环，无法等待其结束，只能强行终止:
    pr.terminate()
```

---
#thread
Python的线程是Posix Thread
```
import time, threading

# 新线程执行的代码:
def loop():
    print 'thread %s is running...' % threading.current_thread().name
    n = 0
    while n < 5:
        n = n + 1
        print 'thread %s >>> %s' % (threading.current_thread().name, n)
        time.sleep(1)
    print 'thread %s ended.' % threading.current_thread().name

print 'thread %s is running...' % threading.current_thread().name
t = threading.Thread(target=loop, name='LoopThread') #创建实例
t.start()
t.join()
print 'thread %s ended.' % threading.current_thread().name
```

#lock
```
import time, threading
# 假定这是你的银行存款:
balance = 0

def change_it(n):
    # 先存后取，结果应该为0:
    global balance
    balance = balance + n
    balance = balance - n

def run_thread(n):
    for i in range(100000):
        change_it(n)

t1 = threading.Thread(target=run_thread, args=(5,))
t2 = threading.Thread(target=run_thread, args=(8,))
t1.start()
t2.start()
t1.join()
t2.join()
print balance


balance = 0
lock = threading.Lock()

def run_thread(n):
    for i in range(100000):
        # 先要获取锁:
        lock.acquire()
        try:
            # 放心地改吧:
            change_it(n)
        finally:
            # 改完了一定要释放锁:
            lock.release()
```
解释器执行代码时，有一个GIL锁：Global Interpreter Lock
任何Python线程执行前，必须先获得GIL锁，然后，每执行100条字节码，解释器就自动释放GIL锁，让别的线程有机会执行。这个GIL全局锁实际上把所有线程的执行代码都给上了锁，所以，多线程在Python中只能交替执行，即使100个线程跑在100核CPU上，也只能用到1个核。

#gevent 协程
gevent是第三方库，通过greenlet实现协程，其基本思想是：
当一个greenlet遇到IO操作时，比如访问网络，就自动切换到其他的greenlet，等到IO操作完成，再在适当的时候切换回来继续执行。由于IO操作非常耗时，经常使程序处于等待状态，有了gevent为我们自动切换协程，就保证总有greenlet在运行，而不是等待IO。



#threadlocal
```
import threading
# 创建全局ThreadLocal对象:
local_school = threading.local()
```

#分布式进程
```
# taskmanager.py

import random, time, Queue
from multiprocessing.managers import BaseManager

# 发送任务的队列:
task_queue = Queue.Queue()
# 接收结果的队列:
result_queue = Queue.Queue()

# 从BaseManager继承的QueueManager:
class QueueManager(BaseManager):
    pass

# 把两个Queue都注册到网络上, callable参数关联了Queue对象:
QueueManager.register('get_task_queue', callable=lambda: task_queue)
QueueManager.register('get_result_queue', callable=lambda: result_queue)
# 绑定端口5000, 设置验证码'abc':
manager = QueueManager(address=('', 5000), authkey='abc')
# 启动Queue:
manager.start()
# 获得通过网络访问的Queue对象:
task = manager.get_task_queue()
result = manager.get_result_queue()
# 放几个任务进去:
for i in range(10):
    n = random.randint(0, 10000)
    print('Put task %d...' % n)
    task.put(n)
# 从result队列读取结果:
print('Try get results...')
for i in range(10):
    r = result.get(timeout=10)
    print('Result: %s' % r)
# 关闭:
manager.shutdown()
```
```
# taskworker.py

import time, sys, Queue
from multiprocessing.managers import BaseManager

# 创建类似的QueueManager:
class QueueManager(BaseManager):
    pass

# 由于这个QueueManager只从网络上获取Queue，所以注册时只提供名字:
QueueManager.register('get_task_queue')
QueueManager.register('get_result_queue')

# 连接到服务器，也就是运行taskmanager.py的机器:
server_addr = '127.0.0.1'
print('Connect to server %s...' % server_addr)
# 端口和验证码注意保持与taskmanager.py设置的完全一致:
m = QueueManager(address=(server_addr, 5000), authkey='abc')
# 从网络连接:
m.connect()
# 获取Queue的对象:
task = m.get_task_queue()
result = m.get_result_queue()
# 从task队列取任务,并把结果写入result队列:
for i in range(10):
    try:
        n = task.get(timeout=1)
        print('run task %d * %d...' % (n, n))
        r = '%d * %d = %d' % (n, n, n*n)
        time.sleep(1)
        result.put(r)
    except Queue.Empty:
        print('task queue is empty.')
# 处理结束:
print('worker exit.')
```











---
#subprocess
这里的内容以Linux进程基础和Linux文本流为基础。subprocess包主要功能是执行外部的命令和程序。比如说，我需要使用wget下载文件。我在Python中调用wget程序。从这个意义上来说，subprocess的功能与shell类似。

1. subprocess以及常用的封装函数
当我们运行python的时候，我们都是在创建并运行一个进程。正如我们在Linux进程基础中介绍的那样，一个进程可以fork一个子进程，并让这个子进程exec另外一个程序。在Python中，我们通过标准库中的subprocess包来fork一个子进程，并运行一个外部的程序(fork，exec见Linux进程基础)。
subprocess包中定义有数个创建子进程的函数，这些函数分别以不同的方式创建子进程，所以我们可以根据需要来从中选取一个使用。另外subprocess还提供了一些管理标准流(standard stream)和管道(pipe)的工具，从而在进程间使用文本通信。
使用subprocess包中的函数创建子进程的时候，要注意:
1) 在创建子进程之后，父进程是否暂停，并等待子进程运行。
2) 函数返回什么
3) 当returncode不为0时，父进程如何处理。

subprocess.call()
父进程等待子进程完成
返回退出信息(returncode，相当于exit code，见Linux进程基础)
subprocess.check_call()
父进程等待子进程完成
返回0
检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性，可用try...except...来检查(见Python错误处理)。
subprocess.check_output()
父进程等待子进程完成
返回子进程向标准输出的输出结果
检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性和output属性，output属性为标准输出的输出结果，可用try...except...来检查。

这三个函数的使用方法相类似，我们以subprocess.call()来说明:
import subprocess 
rc = subprocess.call(["ls","-l"]) 
我们将程序名(ls)和所带的参数(-l)一起放在一个表中传递给subprocess.call()
可以通过一个shell来解释一整个字符串:
import subprocess 
out = subprocess.call("ls -l", shell=True) 
out = subprocess.call("cd ..", shell=True) 
我们使用了shell=True这个参数。这个时候，我们使用一整个字符串，而不是一个表来运行子进程。Python将先运行一个shell，再用这个shell来解释这整个字符串。
shell命令中有一些是shell的内建命令，这些命令必须通过shell运行，$cd。shell=True允许我们运行这样一些命令。
2. Popen
实际上，我们上面的三个函数都是基于Popen()的封装(wrapper)。这些封装的目的在于让我们容易使用子进程。当我们想要更个性化我们的需求的时候，就要转向Popen类，该类生成的对象用来代表子进程。
与上面的封装不同，Popen对象创建后，主程序不会自动等待子进程完成。我们必须调用对象的wait()方法，父进程才会等待 (也就是阻塞block)：
import subprocess 
child = subprocess.Popen(["ping","-c","5","www.google.com"]) 
print("parent process") 
从运行结果中看到，父进程在开启子进程之后并没有等待child的完成，而是直接运行print。
对比等待的情况:
import subprocess 
child = subprocess.Popen(["ping","-c","5","www.google.com"]) 
child.wait() 
print("parent process") 
此外，你还可以在父进程中对子进程进行其它操作，比如我们上面例子中的child对象:
child.poll()           # 检查子进程状态
child.kill()           # 终止子进程
child.send_signal()    # 向子进程发送信号
child.terminate()      # 终止子进程
子进程的PID存储在child.pid
3. 子进程的文本流控制
(沿用child子进程) 子进程的标准输入，标准输出和标准错误也可以通过如下属性表示:
child.stdin
child.stdout
child.stderr
我们可以在Popen()建立子进程的时候改变标准输入、标准输出和标准错误，并可以利用subprocess.PIPE将多个子进程的输入和输出连接在一起，构成管道(pipe):
import subprocess 
child1 = subprocess.Popen(["ls","-l"], stdout=subprocess.PIPE) 
child2 = subprocess.Popen(["wc"], stdin=child1.stdout,stdout=subprocess.PIPE) 
out = child2.communicate() 
print(out)
subprocess.PIPE实际上为文本流提供一个缓存区。child1的stdout将文本输出到缓存区，随后child2的stdin从该PIPE中将文本读取走。child2的输出文本也被存放在PIPE中，直到communicate()方法从PIPE中读取出PIPE中的文本。
要注意的是，communicate()是Popen对象的一个方法，该方法会阻塞父进程，直到子进程完成。
我们还可以利用communicate()方法来使用PIPE给子进程输入:
import subprocess 
child = subprocess.Popen(["cat"], stdin=subprocess.PIPE) 
child.communicate("vamei") 
我们启动子进程之后，cat会等待输入，直到我们用communicate()输入"vamei"。
通过使用subprocess包，我们可以运行外部程序。这极大的拓展了Python的功能。如果你已经了解了操作系统的某些应用，你可以从Python中直接调用该应用(而不是完全依赖Python)，并将应用的结果输出给Python，并让Python继续处理。shell的功能(比如利用文本流连接各个应用)，就完全可以在Python中实现。这也是Python经常被称为脚本语言，并拿来和bash以及Perl进行比较的原因之一。相对于bash和perl，Python的语法更加动态灵活，也大大提高了脚本的可读性与可维护性。当然，bash和perl也有各自的优势(比如bash更加贴近系统，而perl有更强大的正则表达式工具)，我们可以根据自身需要进行选择。
总结:
subprocess.call
subprocess.check_call()
subprocess.check_output()
subprocess.Popen(), subprocess.PIPE
Popen.wait(), Popen.communicate()



