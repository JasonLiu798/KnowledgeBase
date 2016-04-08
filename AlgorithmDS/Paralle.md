#并行算法
---
#Dynamic multithreading
```
Fib(n)
    if n<2
        then return n
    x<-spawn Fib(n-1)
    y<-spawn Fib(n-2)
    sync
    return (x-y)
```
spawn:subroutine can execute at same time as parent.
sync:wait until all children are done.
Logical parallelism ,not actual,
A scheduler determine how to map dynamically unfolding execution onto processors.

Multi-threaded computation
Parallel instruction stream=dag(Directed Acylic Graph 有向非循环图)
Vertices are threads -maximal seq of instruction containing parallel control(spawn ,sync,return )

##Performance mesaures
```latex
T_p=running time on Pprocessors
T_1=work=serial time
T_\infty=critical-path length=longest path
Ex.Fib(4) has T_1=17(线性执行时间),T_\infty=8(关键路径长度)
  (unit-times threads)

Lower bounds on T_p
T_p>=T_1/p  -  P processor can do <=P work in 1 step
T_p>=T_\infty - P processor can't do more work than \infty processors
```

##Speedup
T_1=/T_p=speedup on Pprocessors
T_1/T_p=\theta(p)=>linear speedup
T_1/T_p>P=>superlinear speedup,(not possible)

Max possible speedup given T_1,T_\infty is 
T_1/T_\infty=parallelism
=average mount of work can be done in parallel along each step of crit path
=\bar{p}

##Scheduling
Map computation to Pprocessors
Done by runtime system.
On-line schedulers are complex
illustrate ideas using $\underline{offline} scheduler

#Greedy scheduler(P procs)
do as much as possible on every step
Complete step >=P threads ready to run. Execute any P
Incomplete step <=P threads ready to run.Execute all of them.

theorem (Graham ,Brant) a greedy scheduler executes any computation G with work T,and cut path length T_\infty in time
    T_p<=T_1/p+T_\infty 
in a computer with P procs.

Proof
complete steps<=T_1/p
since otherwise more than T_1 work can be done.Consider an incomplete step,and let G' be subgraph of G that remains to be executed
Threads with in-degree O in G' are ready to be executed. 
Crit-path length of G reduced by 1






















