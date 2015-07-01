Immutable = require 'immutable'

module.exports = commandToModification = (modifications) ->
  modifications = Immutable.fromJS modifications

  (command) ->
    if !modifications.has(command.type)
      throw new Error "Unknown command: #{command.type}"
    else
      modification = modifications.get(command.type)
      modification(command.params)

