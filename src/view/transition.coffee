Immutable = require 'immutable'

hook = require './hook'

module.exports = transition = (handlers) ->
  addTransitions = (viewstack) ->
    viewstack.update 'views', (views) ->
      views
        .filter((view) -> view.has 'show')
        .map (view) ->
          switch
            when view.get('show') and handlers.show? then addHook view, 'show', handlers.show
            when !view.get('show') and handlers.hide? then addHook view, 'hide', handlers.hide
            else view

addHook = do ->
  emptyHooks = Immutable.OrderedMap()

  (view, name, handler) ->
    view.update 'hooks', emptyHooks, (hooks) ->
      hooks.set name, hook handler
