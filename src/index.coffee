Cycle = require '@cycle/core'
{ makeDOMDriver } = require '@cycle/web'

createCommandIO = require './intent/io'
main = require './main'

module.exports = run = (target, options = {}, makeDriver = makeDOMDriver) ->
  commands = createCommandIO()

  Cycle.run (->
    DOM: main(
      commands.output
      options.initialViewstack ? { views: [] }
      options.transitionHooks ? {}
      options.moduleRoot ? "/components"
    ).doOnError(
      (error) ->
        console.error error
    )
  ), {
    DOM: makeDriver target
  }

  commands.input

if window?
  window.ag ?= {}
  window.ag.module ?= {}
  window.ag.module.router = module.exports
