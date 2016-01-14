#react

babel src --out-dir build

[ryf](http://www.ruanyifeng.com/blog/2015/03/react.html)
[使用 React 的一些经验](http://segmentfault.com/a/1190000002432718)
[facebook get start](http://facebook.github.io/react/docs/getting-started.html)

```
<script type="text/babel">
ReactDOM.render(
  <h1>Hello, world!</h1>,
  document.getElementById('example')
);
</script>
```

数组
```
<script type="text/babel">
  var names = ['Alice', 'Emily', 'Kate'];
  ReactDOM.render(
    <div>
    {
      names.map(function (name) {
        return <div>Hello, {name}!</div>
      })
    }
    </div>,
    document.getElementById('example')
  );

  var arr = [
    <h1>Hello world!</h1>,
    <h2>React is awesome</h2>,
  ];
  ReactDOM.render(
    <div>{arr}</div>,
    document.getElementById('example')
  );
</script>
```


#组件
```
//HelloMessage
var HelloMessage = React.createClass({
    render: function() {
      return <h1>Hello {this.props.name}</h1>;
    }
});
ReactDOM.render(<HelloMessage name="John" />,document.getElementById('example'));
```
注意，组件类的第一个字母必须大写，否则会报错，比如HelloMessage不能写成helloMessage。另外，组件类只能包含一个顶层标签，否则也会报错。

##属性
可任意加入，比如 <HelloMessage name="John"> ，就是 HelloMessage 组件加入一个 name 属性，值为 John。组件的属性可以在组件类的 this.props 对象上获取

##this.props.children
[doc](https://facebook.github.io/react/docs/top-level-api.html#react.children)
```
var NotesList = React.createClass({
        render: function() {
          return (
            <ol>
              {
                React.Children.map(this.props.children, function (child) {
                  return <li>{child}</li>;
                })
              }
            </ol>
          );
        }
      });
      ReactDOM.render(
        <NotesList>
          <span>hello</span>
          <span>world</span>
        </NotesList>,
        document.body
      );
```


---
#PropTypes
组件类的PropTypes属性，就是用来验证组件实例的属性是否符合要求
```
var data = 123;
      var MyTitle = React.createClass({
        propTypes: {
          title: React.PropTypes.string.isRequired,
        },

        render: function() {
          return <h1> {this.props.title} </h1>;
        }
      });

      ReactDOM.render(
        <MyTitle title={data} />,
        document.body
      );

//getDefaultProps 方法可以用来设置组件属性的默认值。
var MyTitle = React.createClass({
  getDefaultProps : function () {
    return {
      title : 'Hello World'
    };
  },
  render: function() {
     return <h1> {this.props.title} </h1>;
   }
});
ReactDOM.render(
  <MyTitle />,
  document.body
);

```

#获取真实的DOM节点
ref 属性
```
var MyComponent = React.createClass({
  handleClick: function() {
    this.refs.myTextInput.focus();
  },
  render: function() {
    return (
      <div>
        <input type="text" ref="myTextInput" />
        <input type="button" value="Focus the text input" onClick={this.handleClick} />
      </div>
    );
  }
});

ReactDOM.render(
  <MyComponent />,
  document.getElementById('example')
```
由于 this.refs.[refName] 属性获取的是真实 DOM ，所以必须等到虚拟 DOM 插入文档以后，才能使用这个属性，否则会报错。

[Supported Events](http://facebook.github.io/react/docs/events.html#supported-events)

#this.state
React 的一大创新，就是将组件看成是一个状态机，一开始有一个初始状态，然后用户互动，导致状态变化，从而触发重新渲染 UI
```
var LikeButton = React.createClass({
  getInitialState: function() {
    return {liked: false};
  },
  handleClick: function(event) {
    this.setState({liked: !this.state.liked});
  },
  render: function() {
    var text = this.state.liked ? 'like' : 'haven\'t liked';
    return (
      <p onClick={this.handleClick}>
        You {text} this. Click to toggle.
      </p>
    );
  }
});

ReactDOM.render(
  <LikeButton />,
  document.getElementById('example')
);
```
getInitialState 方法用于定义初始状态，也就是一个对象，这个对象可以通过 this.state 属性读取。
当用户点击组件，导致状态变化，this.setState 方法就修改状态值，每次修改以后，自动调用 this.render 方法，再次渲染组件。
this.props 表示那些一旦定义，就不再改变的特性
this.state 是会随着用户互动而产生变化的特性

#表单
用户在表单填入的内容，属于用户跟组件的互动，所以不能用 this.props 读取
```
var Input = React.createClass({
  getInitialState: function() {
    return {value: 'Hello!'};
  },
  handleChange: function(event) {
    this.setState({value: event.target.value});
  },
  render: function () {
    var value = this.state.value;
    return (
      <div>
        <input type="text" value={value} onChange={this.handleChange} />
        <p>{value}</p>
      </div>
    );
  }
});
ReactDOM.render(<Input/>, document.body);
```
文本输入框的值，不能用 this.props.value 读取，而要定义一个 onChange 事件的回调函数，通过 event.target.value 读取用户输入的值

---
#组件的生命周期
组件的生命周期分成三个状态：
Mounting：已插入真实 DOM
Updating：正在被重新渲染
Unmounting：已移出真实 DOM

will 函数在进入状态之前调用
did 函数在进入状态之后调用，三种状态共计五种处理函数
componentWillMount()
componentDidMount()
componentWillUpdate(object nextProps, object nextState)
componentDidUpdate(object prevProps, object prevState)
componentWillUnmount()

componentWillReceiveProps(object nextProps)
已加载组件收到新的参数时调用
shouldComponentUpdate(object nextProps, object nextState)
组件判断是否重新渲染时调用

```
var Hello = React.createClass({
  getInitialState: function () {
    return {
      opacity: 1.0
    };
  },
  componentDidMount: function () {
    this.timer = setInterval(function () {
      var opacity = this.state.opacity;
      opacity -= .05;
      if (opacity < 0.1) {
        opacity = 1.0;
      }
      this.setState({
        opacity: opacity
      });
    }.bind(this), 100);
  },
  render: function () {
    return (
      <div style={{opacity: this.state.opacity}}>
        Hello {this.props.name}
      </div>
    );
  }
});
ReactDOM.render(
  <Hello name="world"/>,
  document.body
);
```

另外，组件的style属性的设置方式也值得注意，不能写成
style="opacity:{this.state.opacity};"
而要写成
style={{opacity: this.state.opacity}}
这是因为 React 组件样式是一个对象，所以第一重大括号表示这是 JavaScript 语法，第二重大括号表示样式对象。



---
#ajax
Ajax组件的数据来源，通常是通过 Ajax 请求从服务器获取，可以使用 componentDidMount 方法设置 Ajax 请求，等到请求成功
再用 this.setState 方法重新渲染 UI 



























































