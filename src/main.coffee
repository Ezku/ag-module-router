createInitialViewstackStream = require './model/source'
modification = require './model/modification'
commandsToModifications = require('./intent/interpret')(modification)
applyTransitionStates = require './view/transition'
applyModuleRouting = require './view/routing'
renderViewstack = require './view/render'

module.exports = main = (commandStream, initialViewstack, transitionHooks, moduleRoot) ->
  createInitialViewstackStream(initialViewstack)
    .merge(commandStream.map(commandsToModifications))
    .scan((viewstack, modification) -> modification viewstack)
    .map(applyModuleRouting moduleRoot)
    .map(applyTransitionStates transitionHooks)
    .merge(1)
    .map(renderViewstack)
