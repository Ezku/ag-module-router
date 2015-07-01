chai = require 'chai'
chai.should()

commands = require '../src/intent/commands'

createInterpreter = require '../src/intent/interpret'

describe 'intent.interpret', ->
  it 'is a function', ->
    createInterpreter.should.be.a 'function'

  it 'accepts known modifications and produces a command interpreter', ->
    createInterpreter({}).should.be.a 'function'

  describe 'command mapping', ->
    it 'does not accept unknown commands', ->
      (-> createInterpreter({})(foo: 'do stuff')).should.throw Error

    it 'translates a command to its modification', ->
      createInterpreter(
        push: (v) -> 'result'
      )(commands.push({})).should.equal 'result'

    it 'sanitizes command params before modification', ->
      view = {
        components: []
      }
      createInterpreter(
        push: (v) ->
          v.toJS().should.deep.equal view
      )(commands.push(view))
