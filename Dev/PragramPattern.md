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
#泛型 (5,6 stack;7 use stack)
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







































