{ Rx } = require '@cycle/core'

commands = require './commands'

module.exports = createCommandIO = ->
  commandStream = new Rx.Subject

  output: commandStream
  input:
    push: (view) ->
      commandStream.onNext commands.push view

    pop: ->
      commandStream.onNext commands.pop()
