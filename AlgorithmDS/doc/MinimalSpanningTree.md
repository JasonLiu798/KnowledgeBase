#最小生成树的 prim 和 kruskal 算法 
---
原讨论链接：http://community.csdn.net/expert/topicview1.asp?id=3027341 


#克鲁斯卡尔算法 
假设 WN=(V,{E}) 是一个含有 n 个顶点的连通网，则按照克鲁斯卡尔算法构造最小生成树的过程为：先构造一个只含 n 个顶点，而边集为空的子图，若将该子图中各个顶点看成是各棵树上的根结点，则它是一个含有 n 棵树的一个森林。之后，从网的边集 E 中选取一条权值最小的边，若该条边的两个顶点分属不同的树，则将其加入子图，也就是说，将这两个顶点分别所在的两棵树合成一棵树；反之，若该条边的两个顶点已落在同一棵树上，则不可取，而应该取下一条权值最小的边再试之。依次类推，直至森林中只有一棵树，也即子图中含有 n-1条边为止。 

#普里姆算法 
假设 WN=(V,{E}) 是一个含有 n 个顶点的连通网，TV 是 WN 上最小生成树中顶点的集合，TE 是最小生成树中边的集合。显然，在算法执行结束时，TV=V，而 TE 是 E 的一个子集。在算法开始执行时，TE 为空集，TV 中只有一个顶点，因此，按普里姆算法构造最小生成树的过程为：在所有“其一个顶点已经落在生成树上，而另一个顶点尚未落在生成树上”的边中取一条权值为最小的边，逐条加在生成树上，直至生成树中含有 n-1条边为止。 

-------------------------------------------------------------- 
参考例程 
```c
//kruskal 
void MiniSpanTree_Kruskal(CGraph gn) 
{ 
//按算法构造网gn的最小生成树并输出生成树上各条边/ 
  T.init(gn.vexes,null);  
  hp.init(gn)  //堆初始化，堆中元素    
  heap_sort(hp);  //为网gn的所有边     
  while( (hp.Last>0) && (T.Arcn<g.vexn-1) )   
  { 
    e = hp.fo[1]; //取堆中最小代价边             
    fix_mfset(T.set,e.v1,i);  //确定边的两端点   
    fix_mfset(T.set,e.v2,j);  //所在的集合      
    if(i != j) 
    {                            
      T.addArc(e.v1,e.v2);  //增加一条边       
      mix_mfset(T.set,i,j); //合并两个集合           
    }    
    hp.fo[1]=hp.fo[Last];  
    dec(hp.Last);     
    if( hp.Last>1 )       
      heap_sift(hp,1,hp.Last);//求下一条最小代价边   
  } 
  if( T.Arcn<g.vexn-1 )                    
    error("Not Connected")/网gn非连通        
}//endp Kruskal 
```

------------------------------------------------------------------------------ 
```c
//prim 
#include <stdio.h> 
#include <stdlib.h> 

#define MAXVEX 30 
#define MAXCOST 1000 

/*每一步扫描数组lowcost，在V-U中找出离U最近的顶点，令其为k，并打印边(k,closest[k])*/ 
/*然后修改lowcost和closest，标记k已经假如U 。c表示图邻接矩阵，弱不存在边(i,j),则c[i][j]的值为一个大于任何权而小于无限打的阐述，这里用MAXCOST表示*/ 
void prim (int c[MAXVEX][MAXVEX], int n)/*一直图的顶点为{1,2,...,n},c[i][j]为(i,j)的权，打印最小生成树的每条边*/ 
{ 
int i,j,k,min,lowcost[MAXVEX],closest[MAXVEX]; 
for (i=2;i<=n;i++) /*从顶点1开始*/ 
{ 
lowcost[i]=c[1][i]; 
closest[i]=1; 
} 
closest[1]=0; 
for (i=2;i<=n;i++) /*从U之外求离U中某一顶点最近的顶点*/ 
{ 
min=MAXCOST; 
j=1; 
k=i; 
while (j<=n) 
{ 
if (lowcost[j]<min && closest[j]!=0) 
{ 
min=lowcost[j]; 
k=j; 
} 
j++; 
} 
printf ("(%d,%d)",closest[k],k); /*打印边*/ 
closest[k]=0; /* k假如到U中 */ 
for (j=2;j<=n;j++) 
if (closest[j]!=0 && c[k][j]<lowcost[j]) 
{ 
lowcost[j]=c[k][j]; 
closest[j]=k; 
} 
} 
} 

void main() 
{ 
int n=7,i,j,mx[MAXVEX][MAXVEX]; 
for (i=0;i<=n;i++) 
for (j=0;j<=n;j++) 
mx[i][j]=MAXCOST; 
mx[1][2]=50; 
mx[1][3]=60; 
mx[2][4]=65; 
mx[2][5]=40; 
mx[3][4]=52; 
mx[3][7]=45; 
mx[4][5]=50; 
mx[5][6]=70; 
mx[4][6]=30; 
mx[4][7]=42; 
printf("最小生成树边集：\n"); 
prim(mx,n); 
}
```
--------------------------------------------------------------- 

1.为何两个for循环都是从下标2开始的？尤其是第二个想不通； 

答：因为Prim算法可以任选起点，通常选定点1为起点，也就是说点1一开始就在U里面了，自然不必出现在第二个循环(在V-U中寻找点)中。 

2.lowcost数组顾名思义知道是存放最小代价信息的数组，但是具体的说lowcost放着是什么的最小代价，比如“lowcost[i]=c[1][i];”表示的是什么意思（我要带i的语言描述）？ 

答：存放的是当前从点集U到点集V-U的最短边长，lowcost[i] = c[1][i]是初始化，开始时点集U中只有点1，因此当前点集U到点集V-U的各最短边长lowcost[i]就等于点1到点i的边权。 

3.closest[i]=1 又是什么含意呢？ 

答：closest[i]记录对应lowcost[i]的边的起点，因为lowcost[i]是当前终点为i的各条边中的最小值，再加上一个closest[i]记录起点，就能确定最小生成树的边了。closest[i] = 1是初始化，自然每一个边都是从点1出发的。 

4.求教第二个for循环的整层循环是写什么，我要每一行的注释。到底是在作什么？？ 

答： 
```
for (i=2;i<=n;i++) /*从U之外求离U中某一顶点最近的顶点*/ 
{ 
min=MAXCOST; // 这一段是在U之外找最小值，closest[j] != 0表示是U之外 
j=1; 
k=i; 
while (j<=n) 
{ 
if (lowcost[j]<min && closest[j]!=0) 
{ 
min=lowcost[j]; 
k=j; 
} 
j++; 
} 
printf ("(%d,%d)",closest[k],k); /*打印边，这里就看出closest[k]的用途了嘛*/ 
closest[k]=0; /* 将点k加入集合U */ 
for (j=2;j<=n;j++) // 更新最短边和相应起点 
if (closest[j]!=0 && c[k][j]<lowcost[j]) //若点j在集合U外(cloest[j] != 0)，而且从U中的点k出发，到达点j的边权小于当前以j为终点的最小权值(c[k][j] < lowcost[j]) 
{ 
lowcost[j]=c[k][j]; //更新最小权值 
closest[j]=k; //记录新边的起点 
} 
} 
```
--------------------------------------------------------------- 

帖一个我写的Prim的例程，提升一下这个帖子。cc~ 

Program Example_Prim; 
Const 
  Infinity = MaxLongInt; { 无穷大 } 
  M = MaxLongInt; 
  MaxP = 3; 
  map : Array [1..MaxP, 1..MaxP] Of LongInt 

