#Machine Learning
---
#docs
斯坦福大学机器学习课程原始讲义
http://download.csdn.net/detail/blackring007/4679238
http://download.csdn.net/detail/flybirds98/1934334

[基于Python的卷积神经网络和特征提取](http://www.csdn.net/article/2015-08-27/2825549)

[Twitter情感分析技术](http://www.infoq.com/cn/news/2015/12/Twitter-api-notion)
[deeplearning](http://www.deeplearningbook.org/)
[Github上的十大机器学习项目](http://geek.csdn.net/news/detail/52337)
[深度学习2015年文章整理（CVPR2015）](http://blog.csdn.net/u010402786/article/details/50548996)
---
#book
统计学习方法
Pattern Recognition And Machine Learning
数据科学实战
数据检索导论



统计学习方法.李航
All of Statistics
统计学习基础-数据挖掘、推理与预测


PRML, ESL, MLAPP,
Linear Algebra Done Right



机器学习及其应用
All of Statistics.LarryWasserman
机器学习.TomMitchell
PRML.pdf
PRML读书会合集打印版.pdf
Programming Collective Intelligence.pdf
[奥莱理] Machine Learning for Hackers.pdf
大数据：互联网大规模数据挖掘与分布式处理
推荐系统实践.pdf
数据挖掘-实用机器学习技术（中文第二版）.pdf
数据挖掘_概念与技术.pdf
机器学习导论.pdf
模式分类第二版中文版Duda.pdf（全）.pdf
深入搜索引擎--海量信息的压缩、索引和查询.pdf
矩阵分析.美国 Roger.A.Horn.扫描版.pdf

机器学习实战
LDA数学八卦.pdf

---
#C1 base 序论
CS principal
数据结构，基本算法
概率统计
线性代数
人工智能、概率和统计，计算复杂性，信息论，心理学和神经生物学、控制论、以及哲学
Matlab
Octave

#监督学习
回归
provide standard answer
[七种回归技术](http://www.csdn.net/article/2015-08-19/2825492)

#非监督学习
归类

#加强型学习
good dog or bad dog

##适合的领域
数据挖掘问题
没有高效算法的领域
动态地适应变化的领域

##1.1 学习问题的标准描述
定义： 对于某类任务T和性能度量P，如果一个计算机程序在T上以P衡量的性能随着经验E而自我完
善，那么我们称这个计算机程序在从经验E学习
特征：
任务的种类；
衡量任务提高的标准；
经验的来源。
如：
任务T：下西洋跳棋
性能标准P：比赛中击败对手的百分比
训练经验E：和自己进行对弈

##1.2 设计一个学习系统
训练样例：
    直接
    间接
        信用分配
训练样例序列
训练样例的分布能多好地表示实例分布，而最终系统的性能P是通过后者来衡量
    掌握了样例的一种分布，不一定会导致对其他的分布也有好的性能
    目前：基于训练样例与测试样例分布一致这一前提

现在需要选择：
1. 要学习的知识的确切类型
a)选择目标函数
    ChooseMove:B→M来表示这个函数以合法棋局集合中的棋盘状态作为输入，并从合法走子集合中产生某个走子作为输出
评估函数
    令这个目标函数为V，并用V：B→ℜ 
    表示V把任何合法的棋局映射到某一个实数值（用ℜ来表示实数集合）
准确值应该是多少？
    不可操作的定义：不能高效运算的目标函数
    所以学习任务简化成：理想目标函数V的可操作描述，实际达到V很困难，因此可以取近似approximation，过程成为逼近function approximation
    用Vˆ表示程序中实际学习到的函数，以区别理想目标函数V。
b)对于这个目标知识的表示-选择目标函数的表示
    表、规则集合、多项函数、神经网络
    西洋跳棋程序的部分设计：
        任务T：下西洋跳棋
        性能标准P：世界锦标赛上击败对手的百分比
        训练经验E：和自己进行训练对弈
        目标函数：V：B→ℜ
        目标函数的表示：Vˆ(b)=w0+w1x1+w2x2+w3x3+w4x4+w5x5+w6x
c)学习机制-选择函数逼近算法
    估计训练值
    难点：
        最终输赢未必能说明这盘棋当中的每一个棋盘状态的好或坏
        训练值具有内在的模糊性
    西洋棋训练值估计法则：
        Vtrain(b)←Vˆ(Successor(b))
        Successor(b) 表示b之后再轮到程序走棋时的棋盘状态
    权值调整
        最佳拟合（best fit）
```        
        #使训练值和假设预测出的值间的误差平方E最小
        E≡          Σ        (Vtrain(b)-V^(b))^2
            <b,vtrain(b)>∈训练样例
```
    
    LMS训练法则，最小均方法（least mean squares），
        可以在有了新的训练样例时进一步改进权值，并且它对估计的训练数据中的差错有好的健壮性
    对于每一个训练样例<b，Vtrain(b)>
        使用当前的权计算Vˆ(b)
        对每一个权值wi进行如下更新
            wi←wi+η(Vtrain(b)-Vˆ(b))xi
        这里η是一个小的常数（比如0.1）用来调整权值更新的幅度。为了直观地理解这个权值更新法则的工作原理，请注意当误差（Vtrain-Vˆ(b))为0时，权不会被改变
d)最终设计
Experiment Generator-试验生成器
    以当前的假设（当前学到的函数）作为输入，输出一个新的问题（例如，最初的棋局）供执行系统去探索
New Problem(initial game board)-新问题（初始棋局）
Performance System-执行系统
Solution trace(game history)-解答路线（对弈历史）
Critic-鉴定器
    以对弈的路线或历史记录作为输入，输出目标函数的一系列训练样例
Training examples-训练样例
Generalizer-泛化器
    以训练样例作为输入，输出一个假设，作为它对目标函数的估计
Hypothesis-假设

##1.3机器学习的一些观点和问题
算法，什么条件收敛到期望的函数
多少训练数据是充足的
先验知识是怎样引导从样例进行泛化的过程的
怎样把学习任务简化为一个或多个函数逼近问题

----
#C2概念学习和一般到特殊序
概念学习定义：是指从有关某个布尔函数的输入输出训练样例中，推断出该布尔函数。
##2.2 一个概念学习任务
实例（instance）集合
    概念定义在一个实例（instance）集合之上，这个集合表示为X
目标概念(target concept)
    待学习的概念或函数称为，记作c
    一般来说，c可以是定义在实例X上的任意布尔函数，即c:X→{0, 1}
训练样例（training examples）
    每个样例为X中的一个实例x以及它的目标概念值c(x)
    c(x)=1的实例被称为正例(positive example)，或称为目标概念的成员。
    c(x)=0的实例为反例(negative example)，或称为非目标概念成员
    经常可以用序偶<x,c(x)>来描述训练样例，表示其包含了实例x和目标概念值c(x)
    符号D用来表示训练样例的集合
可能假设(all possible hypotheses)
    符号H来表示所有可能假设(all possible hypotheses)的集合，，这个集合内才是为确定目标概念所考虑的范围
    H中每个的假设h表示X上定义的布尔函数，即h:X→{0,1}
机器学习的目标就是寻找一个假设h，使对于X中的所有x，h(x)=c(x)

归纳学习假设
    任一假设如果在足够大的训练样例集中很好地逼近目标函数，它也能在未见实例中很好地逼近目标函数

##2.3 作为搜索的概念学习
概念学习可以看作是一个搜索的过程
范围：假设的表示所隐含定义的整个空间
目标：为了寻找能最好地拟合训练样例的假设

假设的一般到特殊序
定义： 令hj和hk为在X上定义的布尔函数。定义一个more-general-than-or-equal-to关系，记做≥g。称hj≥ghk 当且仅当
(∀x∈X)[(hk(x)=1)→(hj(x)=1)]
hj严格的more-general-than hk（写作hj＞ghk），当且仅当( hj ≥ g hk )∧¬( hk ≥ g hj )
“比……更特殊”为hj more-specific-than hk，当hk more-general-than hj

##2.4 Find-S：寻找极大特殊假设
1. 将h初始化为H中最特殊假设
2. 对每个正例x
    对h的每个属性约束a
    如果x满足ai
        那么 不做任何事
    否则 将h中ai替换为x满足的紧邻的更一般约束
3. 输出假设h
简单地忽略每一个反例
    由于假定目标概念c在H中，而且它一定是与所有正例一致的，那么c一定比h更一般。而目标概念c不会覆盖一个反例，因此h也不会（由more-general-than的定义）。因此，对反例，h不需要作出任何修改。

未解决问题：
学习过程是否收敛到了正确的目标概念？如不能，至少要描述出这种不确定性。
为什么要用最特殊的假设。
训练样例是否相互一致？错误或噪声
如果有多个极大特殊假设怎么办？

##2.5 变型空间和候选消除算法
候选消除算法（Candidate-Elimination）
一致的定义： 
    一个假设h与训练样例集合D一致(consistent)，当且仅当对D中每一个样例<x,c(x)>，h(x)=c(x)
    Consistent(h,D)≡(∀<x,c(x)> ∈ D) h(x)=c(x)

一个样例x在h(x)=1时称为满足假设h，不论x是目标概念的正例还是反例
然而，这一样例是否与h一致与目标概念有关，即是否h(x)=c(x)

变型空间(version space)定义：
    关于假设空间H和训练样例集D的变型空间(version space)，标记为VSsub(H,D)，是H中与训练样例D一致的所有假设构成的子集。
    VSsub(H,D)≡{h∈H|Consistent(h,D)}

列表后消除（List-Then-Eliminate）算法
列表后消除算法
1. 变型空间VersionSpace←包含H中所有假设的列表
2. 对每个训练样例<x, c(x)>
    从变型空间中移除所有h(x)≠c(x)的假设h
3. 输出VersionSpace中的假设列表

原则上，只要假设空间是有限的，就可使用列表后消除算法

一般边界（General boundary）G定义：
    关于假设空间H和训练数据D的一般边界（General boundary）G，是在H中与D相一致的极大一般（maximally general）成员的集合。
    G≡{ g∈H | Consistent(g, D)∧(¬∃g´∈H)[(g´ ＞sub(g)g)∧Consistent(g´, D)]}

特殊边界定义： 
    关于假设空间H和训练数据D的特殊边界（Specific boundary）S，是在H中与D相一致的极大特殊（maximally specific）成员的集合
    S≡{ s∈H | Consistent(s, D)∧(¬∃s´∈H)[(s＞sub(g)s´) ∧Consistent(s´, D)]}

定理2-1变型空间表示定理。
    令X为一任意的实例集合，H与为X上定义的布尔假设的集合。令c: X→{0, 1}为X上定义的任一目标概念，并令D为任一训练样例的集合{<x, c(x)>}。对所有的X，H，c，D以及良好定义的S和G：
    VSsub(H,D) = { h∈H | (∃s∈S) (∃g∈G) (g≥gh≥gs)}
证明：为证明该定理只需证明：(1)每一个满足上式右边的h都在VSs)}

使用变型空间的候选消除算法
将G集合初始化为H中极大一般假设
将S集合初始化为H中极大特殊假设
对每个训练样例d，进行以下操作：
    如果d是一正例
        从G中移去所有与d不一致的假设
        对S中每个与d不一致的假设s
            从S中移去s
            把s的所有的极小泛化式h加入到S中，其中h满足
                h与d一致，而且G的某个成员比h更一般
            从S中移去所有这样的假设：它比S中另一假设更一般
    如果d是一个反例
        从S中移去所有与d不一致的假设
        对G中每个与d不一致的假设g
            从G中移去g
            把g的所有的极小特化式h加入到G中，其中h满足
                h与d一致，而且S的某个成员比h更特殊
            从G中移去所有这样的假设：它比G中另一假设更特殊

2.5.5 算法示例
##2.6 关于变型空间和候选消除的说明

##2.7 归纳偏置
###一个有偏的假设空间
Example:
    Sky     airtemp ... EnjoySport
1   sunny   warm    ...  yes
2   cloudy  warm    ...  yes
3   rainy   warm    ...  no  
<?, Warm, Nornal, Strong, Cool, Change>它将第三个样例错误地划为正例

###无偏的学习器
可教授概念(every teachable concept)
幂集（power set）:集合X所有子集的集合

定义一个新的假设空间H´，它能表示实例的每一个子集，也就是把H´对应到X的幂集。
定义H´的一种办法是，允许使用前面的假设的任意析取、合取和否定式

无偏学习的无用性：学习器如果不对目标概念的形式做预先的假定，它从根本上无法对未见实例进行分类

归纳偏置（Inductive bias）定义：
一般情况下任意的学习算法L
为任意目标概念c提供的任意训练数据Dc={<x, c(x)>
训练过程结束后，L需要对新的实例xi进行分类。
令L(xi, Dc)表示在对训练数据Dc学习后L赋予xi的分类（正例或反例），我们可以如下描述L所进行的这一归纳推理过程：
(Dc∧xi) >- L(xi,Dc)
这里的记号y >- z ，表示z从y归纳推理得到
定义L的归纳偏置为前提集合B，使所有的新实例xi满足。
(B∧Dc∧xi) ├ L(xi, Dc)
这里的记号y├z表示z从y演绎派生（follow deductively，或z可以由y证明得出）

定义： 
考虑对于实例集合X的概念学习算法L。
令c为X上定义的任一概念，并令Dc={<x, c(x)>}为c的任意训练样例集合。
令L(xi, Dc)表示经过数据Dc的训练后，L赋予实例xi的分类。
L的归纳偏置是最小断言集合B，它使任意目标概念c和相应的训练样例Dc满足：
(∀xi∈X)[(B∧Dc∧xi) ├ L(xi, Dc)]




---
#C4 神经网络
神经网络学习方法对于逼近实数值、离散值或向量值的目标函数提供了一种鲁棒性很强的方法
















