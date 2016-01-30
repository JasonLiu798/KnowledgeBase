#angularjs
------
#docs
[学习笔记](http://www.zouyesheng.com/angular.html#toc68)
[如何衡量一个人的 AngularJS 水平](http://www.zhihu.com/question/36040694)

---
#settings
##Tag
Changing the syntax in Angular is very easy. This can be done when defining your Angular application module using Angular’s $interpolateProvider.
```
    var sampleApp = angular.module('sampleApp', [], function($interpolateProvider) {
        $interpolateProvider.startSymbol('<%');
        $interpolateProvider.endSymbol('%>');
    });
```

---
#循环
```html
<div ng-app="" ng-init="names=['Jani','Hege','Kai']">
  <p>使用 ng-repeat 来循环数组</p>
  <ul>
    <li ng-repeat="x in names">
      {{ x }}
    </li>
  </ul>
<div>
```

http get
```html
<div ng-app="" ng-controller="customersController">
    <ul>
      <li ng-repeat="x in names">
        {{ x.Name + ', ' + x.Country }}
      </li>
    </ul>
</div>
<script>
function customersController($scope,$http) {
    $http.get("http://www.w3cschool.cc/try/angularjs/data/Customers_JSON.php")
    .success(function(response) {$scope.names = response;});
}
</script>
```

show/hide
```html
<div ng-app="">
<p ng-show="true">我是可见的。</p>
<p ng-show="false">我是不可见的。</p>
</div>
```

disable
```html
<div ng-app="">
<p>
<button ng-disabled="mySwitch">点我！</button>
</p>
<p>
<input type="checkbox" ng-model="mySwitch">按钮
</p>
</div>
```

click
```html
<div ng-app="" ng-controller="myController">
<button ng-click="count = count + 1">点我！</button>
<p>{{ count }}</p>
</div>
```









