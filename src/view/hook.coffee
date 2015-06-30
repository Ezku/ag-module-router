{ Rx } = require '@cycle/core'

module.exports = ->
  new Hook

class Hook
  subject: null

  constructor: ->
    @subject = new Rx.Subject

  hook: (node, propertyName, previousValue) ->
    @subject.onNext new HookEvent(node, propertyName, previousValue)

  subscribe: (args...) =>
    @subject.subscribe(args...)
    this

class HookEvent
  constructor: (@node, @propertyName, @previousValue) ->
