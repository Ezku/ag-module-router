Immutable = require 'immutable'

module.exports = commandToModification = (modifications) ->
  modifications = Immutable.fromJS modifications

  (command) ->
    if !modifications.has(command.type)
      throw new Error "Unknown command: #{command.type}"
    else
      modification = modifications.get(command.type)
      modification(Immutable.fromJS deepClone command.params)

deepClone = (object) ->
  JSON.parse JSON.stringify object
