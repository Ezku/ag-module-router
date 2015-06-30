Immutable = require 'immutable'
{ Rx } = require '@cycle/core'

hook = require './hook'

module.exports = transition = (handlers) ->
  addTransitions = (viewstack) ->
    Rx.Observable.of(
      viewstack.update 'views', (views) ->
        views
          .map (view) ->
            return view unless view.has 'show'
            switch
              when view.get('show') and handlers.show? then addHook view, 'show', handlers.show
              when !view.get('show') and handlers.hide? then addHook view, 'hide', handlers.hide
              else view
    )

addHook = do ->
  emptyHooks = Immutable.OrderedMap()

  (view, name, handler) ->
    view.update 'hooks', emptyHooks, (hooks) ->
      hooks.set name, hook (e) ->
        e.subscribeOnNext(handler)