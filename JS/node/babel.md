

# exports is not defined 报错的处理
这是使用了CommonJs写法，而在应用中并没有做相应的模块转换使得浏览器能够识别。而导致这个问题是因为balbel的配置文件.babelrc的问题：
{
  "presets": [
    ["env", { "modules": false }],
    "stage-2"
  ],
  "plugins": ["transform-runtime"],
  "comments": false,
  "env": {
    "test": {
      "presets": ["env", "stage-2"],
      "plugins": [ "istanbul" ]
    }
  }
}
其中{ "modules": false }阻止了babel进行模块转换，具体见modules配置的说明，所以，将modules改为默认设置即可，或者删除该配置。
