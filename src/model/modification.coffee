Immutable = require 'immutable'

module.exports =
  push: (view) -> (viewstack) ->
    viewstack.update 'views', (views) ->
      views
        .map((view) ->
          view
            .set('show', false)
            .remove('transition')
        )
        .push(view.merge {
          show: true
          transition: 'push'
        })

  pop: () -> (viewstack) ->
    viewstack.update 'views', (views) ->
      views.withMutations (v) ->
        v
          .pop()
          .update(-1, (view) ->
            view?.merge {
              show: true
              transition: 'pop'
            }
          )
