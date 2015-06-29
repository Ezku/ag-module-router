Immutable = require 'immutable'

module.exports =
  push: (view) -> (viewstack) ->
    viewstack.update 'views', (views) ->
      views.push Immutable.fromJS view
