[Linux如何控制 CPU 利用率](http://blog.csdn.net/bb6lo/article/details/46966689?ref=myread)




```c
//glibc-2.12.2\nptl\sysdeps\i386\pthread_spin_lock.c
#ifndef LOCK_PREFIX
# ifdef UP
#  define LOCK_PREFIX    /* nothing */
# else
#  define LOCK_PREFIX    "lock;"
# endif
#endif
 
int
pthread_spin_lock (lock)
     pthread_spinlock_t *lock;
{
  asm ("\n"
       "1:\t" LOCK_PREFIX "decl %0\n\t"
       "jne 2f\n\t"
       ".subsection 1\n\t"
       ".align 16\n"
       "2:\trep; nop\n\t"
       "cmpl $0, %0\n\t"
       "jg 1b\n\t"
       "jmp 2b\n\t"
       ".previous"
       : "=m" (*lock)
       : "m" (*lock));
 
  return 0;
}

```


#fork
[一个fork的面试题](http://coolshell.cn/articles/7965.html)
题目：请问下面的程序一共输出多少个“-”？
```c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
 
int main(void)
{
   int i;
   for(i=0; i<2; i++){
      fork();
      printf("-");
   }
 
   wait(NULL);
   wait(NULL);
 
   return 0;
}
//printf("-\n");
```






















