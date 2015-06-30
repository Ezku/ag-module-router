{ Rx } = require '@cycle/core'

module.exports = (withHandler = null) ->
  h = new Hook
  withHandler?(h.subject)
  h

class Hook
  subject: null

  constructor: ->
    @subject = new Rx.Subject

  hook: (node, propertyName, previousValue) ->
    @subject.onNext new HookEvent(node, propertyName, previousValue)

  unhook: (node, propertyName, previousValue) ->
    @subject.onCompleted()
    @subject.dispose()

class HookEvent
  constructor: (@node, @propertyName, @previousValue) ->
