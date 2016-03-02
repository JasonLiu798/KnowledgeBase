#program pattern
---
#类型系统C语言(2~4)
大端
0000 0001
小端
0001 0000
high    low

double存储方式

struct
array

---
#泛型 (5,6 stack;7 use stack/heap;8 malloc,stack seg)
void指针
char指针

##static
内部函数，无法被其他文件调用

```java
//7
int main(){
    const char *friends[]={"ai","bob","carl"};
    Stack stringStack;
    StackNew(&stringStack,sizeof(char*));
    for(int i=0;i<3;i++){
        char *copy=strdup(friends[i]);
        //ATTENTION: &copy 字符数组的地址
        StackPush(&stringStack,&copy);
    }

    char *name;
    for (int i=0;i<3;i++){
        StackPop(&stringStack,&name);
        printf("%s\n",name);
        free(name);
    }
    StackDispose(&stringStack);
}  
```


freefn包含了elem的指针类型
```java
typedef struct {
    void *elems;
    int elemSize;
    int logLength;
    int alocLength;
    void (*freefn)(void *);
};
void StackNew(Stack *s,int elemSize,void (*freefn)(void *));
void StackDispose(Stack *s){
    if(s->freefn!=null){
        for(int i=0;i<s->logLength;i++){
            s->freefn((char*)s->elems+i*s->elemSize);
        }
    }
    free(s->elems);
}
StackNew(&stringStack,sizeof(char *),StringFree);
void StringFree(void * elem){
    free(*(char**)elem);
}
```

memcpy
关于重叠区域
```c
/**
 * 把front-middle内容拷贝到末尾，其他数据前移
 * front    middle          end
 * 
 */
void rotate(void* front,void * middle,void* end){
    int frontSize=(char*)middle-(char*)front;
    int backSize=(char*)end-(char*)middle;
    char buffer[frontSize];
    memcpy(buffer,front,frontSize);//front->buffer
    memmove(front,middle,backSize);//middle->front,memcpy 没有对重叠区域做校验
    memcpy((char*)end-frontSize,buffer,frontSize);//buffer->front
}
```

```c
void qsort(void* base,int size,int elemSize,int (*cmpfn)(void *,void *)){

}

```

#head segment
```
//内存分布
2^32-1
    -------------------------------
                            s-end
            stack segment
    s-start
    -------------------------------
                            h-end
            head segment
    h-start 
    -------------------------------
0
```


```c
//以下均为heap segment
void *a=malloc(40);
|    40     |
void *b=maclloc(60);
|    40     |       60      |
free(a);
|   free    |       60      |
void *c=malloc(44);
|           |       60      |   44      |   
void *d=malloc(20);
|  20 |     |       60      |   44      |   
```

空闲空间管理：freenodes linkedlist

int * arr = malloc(40*sizeof(int));
|4 |  4*40 |
a  b       c
arr point to b

int * arr = malloc(100*sizeof(int));
|4 |        4*100      |
a  b=4        c=60       d=404
free(arr+60); //it will free arr+60 地址内存储的数字大小的内存空间

int array[100];

free(array);

句柄
二跳指针，内存压缩
void **handle=NewHandle(40);
Handlelock(handle);//
HandleUnlock(handle);


#Stack Segment
```c
void A(){
    int a;
    short b[4];
    double c;
    B();
    C();
    return;
}
stackframe
|       | a
|   |   | b
|   |   | 
|       | c

void B()
{
    int x;
    char *y;
    char *z[2];
}
|       | x
|       | y
|       | z
|       |

void C(){
    double m[3];
    int n;
}
|       | m
|       | 
|       |
|       | n
```

ALU
Register

Memory

#assembly 
##基础
int i;
int j;
i=10;
j=i+7;
j++;

M[R1+4]=10;//store
R2=M[R1+4];//load
R3=R2+7;//ALU
M[R1]=R3;//store
R2=M[R1];
R2=R2+1;
M[R1]=R2;

##寄存器的高低位
int i;
short s1;
short s2;
|            | i
|  s2 |  s1  |

i=200;  =>  M[R1+4]=200;
s1=i;   =>  R2=M[R1+4];
        =>  M[R1+2]=.2 R2;  .2表示低2位
s2=s1+1;=>  R2=.2 M[R1+2];
        =>  R3=R2+1;
        =>  M[R1]=.2 R3;

##循环
```c
int array[4];
int i;
for(i=0;i<4;i++){
    array[i]=0;
}
i--;
```
```assembly
M[R1]=0;
R2=M[R1];
BGE R2,4,PC+10*4
R3=M[R1];
R4=R3*4;
R5=R1+4;
R6=R4+R5;
M[R6]=0;

R2=M[R1];
R2=R2+1;
M[R1]=R2;
JMP PC-10*4;
```

opcode

##结构体 和 指针强制转换
```c
struct fraction{
    int num;
    int dnum;
};
    |  451  |
    |       | dnum
 R1 |       | num

struct fraction pi;
pi.num=22;  => M[R1]=22;
pi.dnum=7;  => M[R1+4]=7;
((struct fraction *)&pi.dnum)->dnum=451;
                    M[R1+8]=451;
```


---
#C10
##活动记录
```c
void foo(int bar,int*baz ){
    char snak[4];
    short * why;
}
|       |baz
|       |bar
|       |   调用方，依赖于pc
| | | | |snak
|       |why
```

```c
int main(int arg,char **argv){
    int i=4;
    foo(i,&i);
    return 0;
}

high
|         |argv
|    2    |arg
|saved pc |        //sp(main)
|    4    |        //main called sp
|         |
|    4    |       //foo called sp  4 copy from M[SP+8]
|         |       //saved pc
|  | |< | |       
|         |       //foo:sp-8

void foo(int bar,int *baz){
    char mark[4];
    short * why;
    why=(shrot* )(snink+2);
    *why=50;
}


SP=SP-4;    //stack pointer 
M[SP]=4;    //i=4
SP=SP-8;    //为foo参数留出空间
R1=M[SP+8]; //i
R2=SP+8;    //&i
M[SP]=R1;   //i
M[SP+4]=R2; //&i
CALL<foo>
SP=SP+8;    //recycle local variable

foo:
SP=SP-8; //for lolcal variable mark,why
R1=SP+4+2; //snink+2
M[SP]=R1;  //why=(shrot* )R1
R1=M[SP];  //address of why
M[R1]=.2 50;//*why=50;
SP=SP+8; 
RET


//RV between call and caller store return information
```


##活动记录
| parameters |  alloced and inited by caller
| spc        |   
| local      |   allocated and inited by callee ，局部变量

##递归函数
```c
int fact(int n)
{
    if (n==0)
        return 1;
    return fact(n)*n;
}

<fact>:
R1=M[SP+4]；
BNE R1,0,PC+12
RV=1;
RET;
R1=M[SP+4];
R1=R1-1
SP=SP-4;
M[SP]=R1;
CALL <fact>
SP=SP+4;
R1=M[SP+4];
RV=RV*R1
RET;

|   4   | n
| spc   |
|   3   |
| spc   |
...


```

---
#C11 引用
```c
void foo()
{
    int x;
    int y;
    x=11;
    y=17;
    swap(&x,&y);
}

stack
| spc |
| 11    | x
| 17    | y
|       | point to x
|       | point to y

foo:
SP=SP-8;
M[SP+4]=11;
M[SP]=17;
R1=SP;      //&y
R2=SP+4;    //&x
SP=SP-8;
M[SP]=R2;
M[SP+4]=R1;
CALL <swap>
SP=SP+8;

SP=SP+8;
RET;

//--------------------------------------------
void swap(int *ap,int *bp){
    int tmp=*ap;
    *ap=*bp;
    *bp=tmp;
}

swap:
|       |bp
|       |ap
| spc   |
|       |tmp
|

swap:
SP=SP-4; //for tmp
R1=M[SP+8];
R2=M[R1];
M[SP]=R2; //tmp=*ap
R1=M[SP+12];//*bp
R2=M[R1]; //load *bp
R3=M[SP+8];//*ap
M[R3]=R2; //copy to *ap
R1=M[SP];
R2=M[SP+12];
M[R2]=R1;

SP=SP+4;
RET;


void swap(int &ap,int &bp){
    int tmp=ap;
    ap=bp;
    bp=tmp;
}
|       |b 
|       |a
| spc   |
|       |tmp

```

##类
隐式传递的对象引用

---
#C12 宏 include
##宏

```
//assert
#ifdef NDEBUG
    #define assert(cond) (void)0
#else
    #define assert(cond) \
    (cond) ? ((void) 0): 
        fprintf(stderr,.... ),exit(0)
#endif

```

gcc -E xxx.c #只进行预处理
 
---
#C13 编译 缓冲区溢出
```c
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
int main()
{
    void * mem=malloc(400);
    assert(mem!=Null);
    print('yeah!');
    free(mem);
    return 0;
}

mem.o
SP=SP-4
call <melloc>
call<printf>
call<free>
RV=0
RET;

link
=>

a.out

//在编译时，gcc会对于未声明的函数会做推测函数原型（宏也可能会被推测为函数），根据实参类型
//函数原型 为了让callee caller达成一致


int main(){
    int num=65;
    int length=strlen((char*)&num,num);
    printf("length=%d\n",length);
    return 0;
}

int memcmp(void *v);//int memcmp(void* v1,void*v2,int size);

{
    int n=17;
    int m=memcmp(&n);
}
|   17  |n  size
|       |m  v2
|       |   v1
| spc   |
```

seg fault
    错误的指针解引用
bus error
    如int只能用4倍数的地址

缓冲区溢出
```c
//死循环
int main(){
    int i;
    int array[4];
    for(i=0;i=4;i++){
        array[i]=0;
    }
    return 0;
}


void foo()
{
    int array[4];
    int  i;
    for(i=0;i<=4;i++){
        array[i]-=4; //save pc
    }
}

```

---
#C14
C语言函数调用完成后，不会清理活动记录，因此下个函数调用可以读取到上个函数留下的数据
```
initArray();
printArray();
```

##可变参数数量
```c
printf(char *,...);
printf("%d+%d=%d",4,4,8);

|  8    |
|  4    | 
|  4    |
|       | "%d+%d=%d"
| spc   |

struct base{
    int abc;
};
struct typeone{
    int code;


};
struct typetwo{
    int code;
};
```

##进程切换
内存管理
虚地址->物理地址

---
#C15 进程切换
共享变量
临界区
信号量
```c
while(true){
    SemaphoreWait(lock);
    if(*numTicket==0) 
        break;
    (*numTickets)--;
    SemaphoreSignal(lock);
}
SemaphoreSignal(lock);

```

---
#C16 
信号量
生产者-消费者
死锁：哲学家问题

---
#C17
多进程下载同步问题
用信号量进程调度

---
#C18
冰淇淋店问题

---
#C19 OOP
producure 不关心返回值
function 面向返回值
functional language:scheme
```bash
(define c->f(temp)
    (+32(*1.8 temp)))

> (c->f 100)
212
```

##kawa语言
[The Kawa Scheme language](http://www.gnu.org/software/kawa/index.html)
```
>4
4
>"hello"
hello
>#f
#f
>#t
#t
>11.752
11.752
>11/5
11/5
>22/4
11/2
>(+ 1 2 3)
6
>(*(+ 4 4))
    (+ 5 5))
80
>(> 4 2)
#t
>(< 10 5)
#f
>(and (> 4 2)
      (< 10 5))
#f
```

##car
```
>(car '(1 2 3 4 5))
1
```

##cdr
```
>(cdr '(1 2 3 4 5))
(2 3 4 5)
>(car(cdr (cdr '(1 2 3 4 5))))
3
```
AR address register
DR data register

##cms
```
>(cms 1 '(2 3 4 5))
(1 2 3 4 5)
>(cmd '(1 2 3) '(4 5))
((1 2 3) 4 5)
```

```
>(append (1 2 3) (4 5))
(1 2 3 4 5)

>(define add (x y)
    (+ x y)) 
ADD
>(add 10 7)
17
>(add "H" "there")
>(sum-of '(1 2 3 4))
(define sum-of(numlist)
    (if (null? numlist) 0
        (+ (car numlist)
           (sum-of (car numlist)))))
```

#C20
```
>(define sum-list(num-list)
    (if (null? num-list) 0
        (+ (car num-list)
           (num-list (cdr num-list)))))
>(sum-list ("hello" 1 2 3 4 5))
```

##fib
```
>(define fib(n)
    (if (zero? n) 0
        (if (= n 1) 1
            (+ (fib (- n 1))
               (fib (- n 2))))))

>(define fib(n)
    (if (or (= n 0)
            (= n 1)) n
        (+ (fib (- n 1))
            (fib (- n 2))))
)
>(if (zero? 0) 4
     (+ "hello" 4.5 '(8 2)))
```


##flatten
```
>(flatten '(1 2 3 4))
(1 2 3 4)
>(flatten '(1 (2 3) 4 ((5))))
(1 2 3 4 5)
```

##cond

##cons
```
>(cons 4 '(1 5 7))
(4 1 5 7)
```


```
(define flatten (sequence)
    (cond (((null? sequence) '())
           ((list? (car sequence))
                (append (flatten (car sequence))
                        (flatten (cdr sequence) ) )
           )
           (else (cons (car sequence)
                    (flatten (cdr sequence))))
            )))
```

##sorted
```
>(sorted? '(1 2 2 4 7))
#t

(define sorted? (num-list)
    (or (< (length num-list) 2)
        (and (<= (car num-list)
                 (cadr num-list))
             (sorted? (cdr num-list)))))

```

##函数式编程实现
符号表
函数对象，指向代码

---
#C21
apply
eval
lambda

---
#C22 let permute
powerset

##let
```
(define (ps set)
    (if (null? set) '(())
        (let ((ps-rset (ps (cdr set))))
            (append ps-rest 
                (map (lambda (subset)
                    (cons (car set) subset))
                    ps-rest)))))

(let* ((x expr1)
      (y expr2)
      (z expr3)
      for(x,y,z) )
```

```
(define (permute items)
    (if (null? items) '(())
    (apply append 
        (map (lambda (elem) 
            (map (lambda (permutation)
                (cms elem permutation))
                (permute (remove items elem))))
        items)
    )
)



```

#C23 scheme实现
#C24 python基础
#C25 python对象实质
#C26 xml解析
#C27 rss xml解析
#C28 haskell
lisp/scheme 1959
ML/OCaml 1979
miranda 1985
Haskell 98 (2003)






















