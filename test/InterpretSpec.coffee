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

    it 'passes command params to the modification', ->
      view = {}
      createInterpreter(
        push: (v) -> v.should.equal view
      )(commands.push(view))
