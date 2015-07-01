Immutable = require 'immutable'

module.exports = (view = {}) ->
  Immutable.fromJS({
    components: view.components ? []
  })
  .merge(Immutable.fromJS view)
