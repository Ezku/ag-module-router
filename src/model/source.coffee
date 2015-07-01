{ Rx } = require '@cycle/core'

viewstack = require './viewstack'

module.exports = (initialViewstack) ->
  Rx.Observable.of(viewstack(initialViewstack.views...))
