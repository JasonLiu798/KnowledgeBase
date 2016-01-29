#program pattern
---
#2~4 c类型系统
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

```
//7
int main(){
    const char *friends={"ai","bob","carl"};
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

```
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









































