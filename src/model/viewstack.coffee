Immutable = require 'immutable'

module.exports = (views...) ->
  Immutable.fromJS {
    views
  }
