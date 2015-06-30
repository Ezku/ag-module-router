
module.exports = (f) ->
  new class Hook
    hook: (node, propertyName, previousValue) ->
      f(node, propertyName, previousValue)
