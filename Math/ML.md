

[梯度下降](http://baike.baidu.com/link?url=k-WiNGI0IRBtF94bCxZ3Smuzjm7OCx0IgE9tapLrorokqGowuaFOlWny6YupyrpSe8gBZp-QXyC5D3q0Hns9eNv-ZMdwt9I8odu5is8mx483SljNH5vueS8FVtR3yVrPW-85bpFG0rwoP9GJ-hy2hwrGVhBGVVIEltymhnxdu_QUyMxdzdqCbQXOotToubKr)


给定初始点x0=(1,1)，用最速下降法求函数f(x)=4*x1+6*x2-2*x1^2-2*x1*x2-2*x2^2的极大值，则迭代一次后x1=？

f(x)对x1求偏导, f'(x)(对x1) = 4 -4x1-2x2,
    对x2求偏导, f'(x)(对x2) = 6-2x1-4x2, 
    在(1,1)点, x1方向上的梯度为f'(1,1)(对x1) = 4 - 4 - 2 = -2
    在(1,1)点, x2方向上的梯度为f'(1,1)(对x2) = 6 - 2 - 4 = 0
    然后就是要计算此步的最优步长, 设置步长为y, 则下一次迭代的函数值为: 
    f(x + y*f'(x)) = f((1,1) + y*(-2,0)) = f(1-2y, 1) = 4*(1-2y) + 6*1 -2(1-2y)^2 - 2(1-2y) -2 = -2(1-2y)^2 + 2(1-2y) + 4 = -2(1-2y)^2 - 4y + 6
    把这个函数看成一个关于y的函数g(y), 对y求导g'(y) = 8(1-2y)  -4, 
    令g'(y) = 0, 求得y = 1/4 = 0.25
    即0.25为最优步长, 
    带入(1-2y, 1) 得到, (1/2, 1)为迭代一次的结果. 
