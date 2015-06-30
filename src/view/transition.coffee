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
  viewstack.update 'views', (views) ->
    views
      .map (view) ->
        return view unless view.has 'show'
        switch
          when view.get('show') and handlers.has('show') then addHook view, 'show', handlers.get('show')
          when !view.get('show') and handlers.has('hide') then addHook view, 'hide', handlers.get('hide')
          else view

addHook = do ->
  emptyHooks = Immutable.OrderedMap()

  (view, name, handler) ->
    view.update 'hooks', emptyHooks, (hooks) ->
      hooks.set name, hook (e) ->
        e.subscribeOnNext(handler)
