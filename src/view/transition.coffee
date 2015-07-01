Immutable = require 'immutable'
{ Rx } = require '@cycle/core'

hook = require './hook'

module.exports = transition = (handlers) ->
  handlers = Immutable.fromJS handlers

  if handlers.size is 0
    (viewstack) ->
      Rx.Observable.of viewstack
  else
    (viewstack) ->
      Rx.Observable.from [
        addHooks viewstack, handlers
        viewstack
      ]

addHooks = (viewstack, handlers) ->
  viewstack.update 'views', Immutable.List(), (views) ->
    views
      .map (view) ->
        return view unless view.has 'show'
        switch
          when view.get('show') and handlers.has('pop') then addHook view, 'pop', handlers.get('pop')
          when !view.get('show') and handlers.has('push') then addHook view, 'push', handlers.get('push')
          else view

addHook = do ->
  emptyHooks = Immutable.OrderedMap()

  (view, name, handler) ->
    view.update 'hooks', emptyHooks, (hooks) ->
      hooks.set name, hook (e) ->
        e.subscribeOnNext(handler)
