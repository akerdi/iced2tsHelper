_ = require "lodash"
###
#param deferFunc target method
#param params any[] 必须是数组参数
# 支持ts中转化cb函数为promise 手段(utils.promise 无法转换所有该类型)
# usage: const [err, result] = await callAsync(defer2Promise(icedScript.icedCallbackFunc, [params]))
###
defer2Promise = (deferFunc, params)->
  new Promise((resolve, reject)->
    return reject(new Error("[defer2Promise]参数必须是数组")) unless _.isArray(params)
    curryingFunc = (err, result)->
      if err
        return reject(err)
      resolve(result)
    params.push curryingFunc
    deferFunc.apply(null, params)
  )

module.exports.defer2Promise = defer2Promise

###
#param promiseFunc target method
#param params any[] 必须是数组参数
# usage: await promise2Defer utils.pump, [fs.createReadStream(localPath), fs.createWriteStream(targetFile)], defer err
###
promise2Defer = (promiseFunc, params, cb)->
  return cb("[promise2Defer]参数必须是数组") unless _.isArray(params)
  promiseFunc.apply(null, params)
    .then((data)-> cb(null, data))
    .catch((e) -> cb(e, null))
module.exports.promise2Defer = promise2Defer

module.exports.default = {
  defer2Promise
  promise2Defer
}
