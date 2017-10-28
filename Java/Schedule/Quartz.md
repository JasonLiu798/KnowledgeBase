

[Quartz应用与集群原理分析](http://www.360doc.com/content/14/0926/08/15077656_412418636.shtml)

#实现
[Quartz源码分析](http://blog.csdn.net/cutesource/article/details/4965520)

最核心的地方是QuartzSchedulerThread运行机制。下面解析一下它的run方法：
```java
public void run() {  
        boolean lastAcquireFailed = false;  
          
        while (!halted) {  
            try {  
                // check if we're supposed to pause...  
                synchronized (pauseLock) {  
                    while (paused && !halted) {  
                        try {  
                            // wait until togglePause(false) is called...  
                            pauseLock.wait(100L);  
                        } catch (InterruptedException ignore) {  
                        }  
                    }  
      
                    if (halted) {  
                        break;  
                    }  
                }
           ......
           }  
      }
}
```
以上是run的最开头的一段，不难看出这是在等待scheduler的start，实际上Quartz就是通过线程的wait或sleep来实现时间调度。继续看代码：
```java
Trigger trigger = null;  
long now = System.currentTimeMillis();  
signaled = false;  
try {  
    trigger = qsRsrcs.getJobStore().acquireNextTrigger(  
            ctxt, now + idleWaitTime);  
    lastAcquireFailed = false;  
} catch (JobPersistenceException jpe) {  
    if(!lastAcquireFailed) {  
        qs.notifySchedulerListenersError(  
            "An error occured while scanning for the next trigger to fire.",  
            jpe);  
    }  
    lastAcquireFailed = true;  
} catch (RuntimeException e) {  
    if(!lastAcquireFailed) {  
        getLog().error("quartzSchedulerThreadLoop: RuntimeException "  
                +e.getMessage(), e);  
    }  
    lastAcquireFailed = true;  
}  
```
这段代码是从jobStore里拿到下一个要执行的trigger，一般情况下jobStore使用的是RAMJobStore，即trigger等相关信息存放在内存里，如果需要把任务持久化就得使用可持久化JobStore。继续看代码：
```java
now = System.currentTimeMillis();  
long triggerTime = trigger.getNextFireTime().getTime();  
long timeUntilTrigger = triggerTime - now;  
long spinInterval = 10;  
int numPauses = (int) (timeUntilTrigger / spinInterval);  
while (numPauses >= 0 && !signaled) {  
    try {  
        Thread.sleep(spinInterval);  
    } catch (InterruptedException ignore) {  
    }  
    now = System.currentTimeMillis();  
    timeUntilTrigger = triggerTime - now;  
    numPauses = (int) (timeUntilTrigger / spinInterval);  
}  
if (signaled) {  
    try {  
        qsRsrcs.getJobStore().releaseAcquiredTrigger(  
                ctxt, trigger);  
    } catch (JobPersistenceException jpe) {  
        qs.notifySchedulerListenersError(  
                "An error occured while releasing trigger '"  
                        + trigger.getFullName() + "'",  
                jpe);  
        // db connection must have failed... keep  
        // retrying until it's up...  
        releaseTriggerRetryLoop(trigger);  
    } catch (RuntimeException e) {  
        getLog().error(  
            "releaseTriggerRetryLoop: RuntimeException "  
            +e.getMessage(), e);  
        // db connection must have failed... keep  
        // retrying until it's up...  
        releaseTriggerRetryLoop(trigger);  
    }  
    signaled = false;  
    continue;  
}  
```
此段代码是计算下一个trigger的执行时间和现在系统时间的差，然后通过循环线程sleep的方式暂停住此线程，一直等到trigger的执行时间点。继续看代码：
```java
import org.quartz.core.JobRunShell;  
JobRunShell shell = null;  
try {  
    shell = qsRsrcs.getJobRunShellFactory().borrowJobRunShell();  
    shell.initialize(qs, bndle);  
} catch (SchedulerException se) {  
    try {  
        qsRsrcs.getJobStore().triggeredJobComplete(ctxt,  
                trigger, bndle.getJobDetail(), Trigger.INSTRUCTION_SET_ALL_JOB_TRIGGERS_ERROR);  
    } catch (SchedulerException se2) {  
        qs.notifySchedulerListenersError(  
                "An error occured while placing job's triggers in error state '"  
                        + trigger.getFullName() + "'", se2);  
        // db connection must have failed... keep retrying  
        // until it's up...  
        errorTriggerRetryLoop(bndle);  
    }  
    continue;  
}  
if (qsRsrcs.getThreadPool().runInThread(shell) == false) {  
    try {  
        getLog().error("ThreadPool.runInThread() return false!");  
        qsRsrcs.getJobStore().triggeredJobComplete(ctxt,  
                trigger, bndle.getJobDetail(), Trigger.INSTRUCTION_SET_ALL_JOB_TRIGGERS_ERROR);  
    } catch (SchedulerException se2) {  
        qs.notifySchedulerListenersError(  
                "An error occured while placing job's triggers in error state '"  
                        + trigger.getFullName() + "'", se2);  
        // db connection must have failed... keep retrying  
        // until it's up...  
        releaseTriggerRetryLoop(trigger);  
    }  
}  
```
此段代码就是包装trigger，然后通过以JobRunShell为载体，在threadpool里执行trigger所关联的jobDetail。
之后的代码就是清扫战场，就不在累述。


























