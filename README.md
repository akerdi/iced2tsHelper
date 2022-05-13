# iced2tsHelper
iced 转化 Typescript 便捷函数

先抛出答案，使用：

`const [err, result] = await callAsync(defer2Promise(icedScript.icedCallbackFunc, [params]))`

实现：

```
_ = require "lodash"
###
# deferFunc iced要await的函数
# params any[] 必须是数组参数
###
module.exports.defer2Promise = (deferFunc, params)->
  new Promise((resolve, reject)->
    return reject(new Error("参数必须是数组")) unless _.isArray(params)
    curryingFunc = (err, result)->
      if err
        return reject(err)
      resolve(result)
    params.push curryingFunc
    deferFunc.apply(null, params)
  )
```

由于iced 使用await defer在iced1.x 、iced2.x、iced3.x中有不同实现，iced1.x 是采用编译原理直接替换await 为iced_deferrals / _iced_passed_deferral等参数，无法同Typescript 的await 和平共处。

转换方法内不方便提供await defer：因为iced 不支持参数解构！那么我们直接在函数体外提供数组对象。同时，方法最后提供柯里化函数，使用callback 形式调用。

最后，我们提供js原生支持的 apply 函数，调用起回调方法。

总结: 以上解决了Iced 重构 Typescript 过程中，无法平滑过渡的隐患(可能导致牵连多个Iced 脚本，无法在Typescript中进行 await 调用的老大难题)

[参考iced2ts](https://akerdi.github.io/tags/iced2ts/)

有其他疑问可以issue提出
