chai = require 'chai'
chai.should()

{ Rx } = require '@cycle/core'

createCommandIO = require '../src/intent/io'

describe 'intent.io', ->
  it 'is a function', ->
    createCommandIO.should.be.a 'function'

  it 'should produce input and output objects', ->
    createCommandIO().should.have.property('input')
    createCommandIO().should.have.property('output')

  describe 'output', ->
    it 'is an observable', ->
      createCommandIO().output.should.be.an.instanceof Rx.Observable

  describe 'input', ->
    describe 'push', ->
      it 'is a function', ->
        createCommandIO().input.push.should.be.a 'function'

      it 'produces a push-event', ->
        view = {}
        { input, output } = createCommandIO()
        output.subscribeOnNext (e) ->
          e.should.have.property('type').equal 'push'
          e.should.have.property('params').deep.equal { view }
        input.push view

    describe 'pop', ->
      it 'is a function', ->
        createCommandIO().input.pop.should.be.a 'function'

      it 'produces a pop-event', ->
        { input, output } = createCommandIO()
        output.subscribeOnNext (e) ->
          e.should.have.property('type').equal 'pop'
        input.pop()
