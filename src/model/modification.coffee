Immutable = require 'immutable'

module.exports =
  push: (view) -> (viewstack) ->
    viewstack.update 'views', (views) ->
      views
        .map((view) -> view.remove 'show')
        .withMutations (v) ->
          v
            .update(-1, (view) ->
              view?.set('show', false)
            )
            .push Immutable.fromJS view

  pop: () -> (viewstack) ->
    viewstack.update 'views', (views) ->
      views.withMutations (v) ->
        v
          .pop()
          .update(-1, (view) ->
            view?.set('show', true)
          )
