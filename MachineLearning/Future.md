# 未来，应用

[未来 3~5 年内，哪个方向的机器学习人才最紧缺](https://www.zhihu.com/question/63883507)
0. 背景
工业界未来需要什么样的机器学习人才？老生常谈，能将模型应用于专业领域的人，也就是跨领域让机器学习落地的人。有人会问现在我们不就需要这样的人吗？答案是肯定的，我们需要并将长期需要这样的人才，现阶段的机器学习落地还存在各种各样的困难。这样的需求不会是昙花一现，这就跟web开发是一个道理，从火热到降温也经过了十年的周期。一个领域的发展有特定的周期，机器学习的门槛比web开发高而且正属于朝阳期，所以大家致力于成为“专精特定领域”的机器学习专家不会过时。

什么是特定领域的机器学习专家？举个例子，我以前曾回答“人工智能是否会替代财务工作者”时提到我曾在某个公司研究如何用机器学习自动化一部分审计工作，但遇到的最大困难是我自己对审计的了解有限，而其他审计师对我的工作不是非常支持导致进展缓慢。所以如果你有足够的机器学习知识，并对特定领域有良好的理解，在职场供求中你肯定可以站在优势的那一边。以我的另一个回答为例「阿萨姆：反欺诈(Fraud Detection)中所用到的机器学习模型有哪些？」，特定领域的知识帮助我们更好的解释机器学习模型的结果，得到老板和客户的认可，这才是算法落了地。能写代码、构建模型的人千千万，但理解自己在做什么，并从中结合自己的领域知识提供商业价值的人少之又少。所以调侃一句，哪个方向的机器学习人才最紧缺？答：每个领域都需要专精的机器学习人才，你对特定领域的理解就是你的武器。

当然，给喂鸡汤不给勺很不厚道，所以我也会给出一些具体建议。再次申明，我的建议仅给以就业为目的的朋友，走研究路线我有不同的建议，本文不再赘述。

1. 基本功

说到底机器学习还是需要一定的专业知识，这可以通过学校学习或者自学完成。但有没有必要通晓数学，擅长优化呢？我的看法是不需要的，大前提是需要了解基本的数学统计知识即可，更多的讨论可以看我这个答案「阿萨姆：如何看待「机器学习不需要数学，很多算法封装好了，调个包就行」这种说法？」。最低程度下我建议掌握五个小方向，对于现在和未来几年内的工业界够用了。再一次重申，我对于算法的看法是大部分人不要造轮子，不要造轮子，不要造轮子！只要理解自己在做什么，知道选择什么模型，直接调用API和现成的工具包就好了。

回归模型(Regression)。学校的课程中其实讲得更多的都是分类，但事实上回归才是工业届最常见的模型。比如产品定价或者预测产品的销量都需要回归模型。现阶段比较流行的回归方法是以数为模型的xgboost，预测效果很好还可以对变量重要性进行自动排序。而传统的线性回归(一元和多元)也还会继续流行下去，因为其良好的可解释性和低运算成本。如何掌握回归模型？建议阅读Introduction to Statistical Learning的2-7章，并看一下R里面的xgboost的package介绍。
分类模型(Classification)。这个属于老生常谈了，但应该对现在流行并将继续流行下去的模型有深刻的了解。举例，随机森林(Random Forests)和支持向量机(SVM)都还属于现在常用于工业界的算法。可能很多人想不到的是，逻辑回归(Logistic Regression)这个常见于大街小巷每一本教科书的经典老算法依然占据了工业界大半壁江山。这个部分推荐看李航《统计学习方法》，挑着看相对应的那几章即可。
神经网络(Neural Networks)。我没有把神经网络归结到分类算法还是因为现在太火了，有必要学习了解一下。随着硬件能力的持续增长和数据集愈发丰富，神经网络的在中小企业的发挥之处肯定会有。三五年内，这个可能会发生。但有人会问了，神经网络包含内容那么丰富，比如结构，比如正则化，比如权重初始化技巧和激活函数选择，我们该学到什么程度呢？我的建议还是抓住经典，掌握基本的三套网络: a. 普通的ANN b. 处理图像的CNN c. 处理文字和语音的RNN(LSTM)。对于每个基本的网络只要了解经典的处理方式即可，具体可以参考《深度学习》的6-10章和吴恩达的Deep Learning网课(已经在网易云课堂上线)。
数据压缩/可视化(Data Compression & Visualization)。在工业界常见的就是先对数据进行可视化，比如这两年很火的流形学习(manifold learning)就和可视化有很大的关系。工业界认为做可视化是磨刀不误砍柴工，把高维数据压缩到2维或者3维可以很快看到一些有意思的事情，可能能节省大量的时间。学习可视化可以使用现成的工具，如Qlik Sense和Tableau，也可以使用Python的Sklearn和Matplotlib。
无监督学习和半监督学习(Unsupervised & Semi-supervised Learning)。工业界的另一个特点就是大量的数据缺失，大部分情况都没有标签。以最常见的反诈骗为例，有标签的数据非常少。所以我们一般都需要使用大量的无监督，或者半监督学习来利用有限的标签进行学习。多说一句，强化学习在大部分企业的使用基本等于0，估计在未来的很长一阵子可能都不会有特别广泛的应用。
基本功的意义是当你面对具体问题的时候，你很清楚可以用什么武器来处理。而且上面介绍的很多工具都有几十年的历史，依然历久弥新。所以以3-5年的跨度来看，这些工具依然会非常有用，甚至像CNN和LSTM之类的深度学习算法还在继续发展迭代当中。无论你现在还在学校还是已经开始工作，掌握这些基本的技术都可以通过自学在几个月到一两年内完成。

2. 秘密武器

有了基本功只能说明你可以输出了，怎么才能使得你的基本功不是屠龙之术？必须要结合领域知识，这也是为什么我一直劝很多朋友不要盲目转机器学习从零做起。而学生朋友们可以更多的关注自己感兴趣的领域，思考如何可以把机器学习运用于这个领域。比如我自己对历史和哲学很感兴趣，常常在思考机器学习和其他文科领域之间的联系，也写过一些开脑洞的文章「 带你了解机器学习(一): 机器学习中的“哲学”」。

而已经有了工作/研究经验的朋友，要试着将自己的工作经历利用起来。举例，不要做机器学习里面最擅长投资的人，而要做金融领域中最擅长机器学习的专家，这才是你的价值主张(value proposition)。最重要的是，机器学习的基本功没有大家想的那么高不可攀，没有必要放弃自己的本专业全职转行，沉没成本太高。通过跨领域完全可以做到曲线救国，化劣势为优势，你们可能比只懂机器学习的人有更大的行业价值。

举几个我身边的例子，我的一个朋友是做传统软件工程研究的，前年他和我商量如何使用机器学习以GitHub上的commit历史来识别bug，这就是一个很好的结合领域的知识。如果你本身是做金融出身，在你补足上面基本功的同时，就可以把机器学习交叉运用于你自己擅长的领域，做策略研究，我已经听说了无数个“宣称”使用机器学习实现了交易策略案例。虽不可尽信，但对特定领域的深刻理解往往就是捅破窗户的那最后一层纸，只理解模型但不了解数据和数据背后的意义，导致很多机器学习模型只停留在好看而不实用的阶段。

换个角度思考，不同领域的人都有了对机器学习的理解能更好的促进这个技术落地，打破泡沫的传言。而对于大家而言，不用再担心自己会失业，还能找到自己的角度在这个全民深度学习的时代找到“金饭碗”。所以我建议各行各业的从业者不必盲目的转计算机或者机器学习，而应该加深对本专业的了解并自学补充上面提到的基本功，自己成为这个领域的机器学习专家。

3. 弹药补给 

没有什么不会改变，这个时代的科技迭代速度很快。从深度学习开始发力到现在也不过短短十年，所以没有人知道下一个会火的是什么？以深度学习为例，这两年非常火的对抗生成网络(GAN)，多目标学习(multi-lable learning)，迁移学习(transfer learning)都还在飞速的发展。有关于深度学习为什么有良好泛化能力的理论猜想文章在最新的NIPS听说也录了好几篇。这都说明了没有什么行业可以靠吃老本一直潇洒下去，我们还需要追新的热点。但机器学习的范围和领域真的很广，上面所说的都还是有监督的深度学习，无监督的神经网络和深度强化学习也是现在火热的研究领域。所以我的建议是尽量关注、学习了解已经成熟和已经有实例的新热点，不要凡热点必追。

如果你有这些基本功和良好的领域结合能力，三年五年绝不是职业的瓶颈期，甚至十年都还太早。科技时代虽然给了我们很大的变革压力，但也带给了我们无限的可能。技术总会过时，热点总会过去，但不会过去的是我们不断追求新科技的热情和对自己的挑战。










