
module.exports = commands =
  push: (view) -> new Command 'push', view
  pop: -> new Command 'pop'

class Command
  constructor: (@type, @params = {}) ->
