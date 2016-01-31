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

















