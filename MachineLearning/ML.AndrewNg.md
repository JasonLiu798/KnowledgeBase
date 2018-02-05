# 机器学习笔记，(吴恩达)
http://study.163.com/course/courseMain.htm?courseId=1004570029
适合初级

---
# 绪论
## 监督学习
'right answers' given
### 回归
选择模型，直线还是曲线

### 分类问题
特征值

## 非监督学习
### 聚类

鸡尾酒会算法
[W,s,v]=svd((repmat(sum(x.*x,1),size(x,1),1).*x)*x');


octave

---
# 单变量线性回归
数据集
m
x's input variable/features
y's output variable/target features
(x,y) one training example
(x^(i),y^(i)) i^th training example

hypothesis:
h_θ(x)=θ_0+θ_1*x

parameters:
θ_0 θ_1

cost function:
J(θ_0,θ_1)=1/2m*\sum_{i=1}^m(h_θ(x^(i)-y^(i)))^2
h_θ(x^(i)=θ_0+θ_1x^(i)

Goal:
minimize J(θ_0,θ_1)

Simplified
h_θ(x)
J(θ_1)=1/2m*\sum_{i=1}^m(h_θ(x^(i)-y^(i)))^2
minimize J(θ_1)

J(1.5)=
J(1)=0
J(0.5)=0.58
J(0)=2.3 
=> 抛物线

J(θ_0,θ_1)=>碗曲面

等高线
同一高度的J(θ_0,θ_1)值相同


# 梯度下降
最小化 J
start with some θ_0,θ_1
keep changing θ_0,θ_1 to reduce J(θ_0,θ_1) until we hopefully end up at a minimum
不同的起点可能会得到不同的局部最优解

## 算法
repeat until convergence{
	θ_j := θ_j - α \frac{\partial }{\partial θ_j} * J(θ_0,θ_1)  (for j=0 and j=1)
}
:= assignment 
α learning rate，下降速率，越小越慢
导数项 \frac{\partial }{\partial θ_j}

同时更新





















