chai = require 'chai'
chai.should()
sinon = require 'sinon'
chai.use(require 'sinon-chai')

{ Rx } = require '@cycle/core'
createElement = require 'virtual-dom/create-element'
renderViewstack = require '../src/view/render'
viewstack = require '../src/model/viewstack'

transition = require '../src/view/transition'

runTransition = (t) ->
  t.map(renderViewstack).map(createElement).subscribe()

describe 'view.transition', ->
  it 'is a function', ->
    transition.should.be.a 'function'

  it 'accepts transition hook handlers and produces a function', ->
    transition({}).should.be.a 'function'

  describe 'hook handlers', ->
    describe 'show', ->
      it 'is triggered when a view with show state enabled is created', ->
        whenShown = sinon.stub()
        runTransition transition(
          show: whenShown
        )(viewstack(
          show: true
          components: []
        ))
        whenShown.should.have.been.called

      it 'receives the hook event as an argument', ->
        runTransition transition(
          show: (event) ->
            event.should.have.keys('node', 'previousValue', 'propertyName')
        )(viewstack(
          show: true
          components: []
        ))

    describe 'hide', ->
      it 'is triggered when a view with show state disabled is created', ->
        whenHidden = sinon.stub()
        runTransition transition(
          hide: whenHidden
        )(viewstack(
          show: false
          components: []
        ))
        whenHidden.should.have.been.called

      it 'receives the hook event as an argument', ->
        runTransition transition(
          hide: (event) ->
            event.should.have.keys('node', 'previousValue', 'propertyName')
        )(viewstack(
          show: false
          components: []
        ))

  it 'turns the viewstack into a stream of viewstacks with successive transition states', ->
    transition({})(viewstack()).should.be.an.instanceof Rx.Observable

  describe 'stream', ->
    it 'yields the input viewstack if there are no transition hooks', ->
      init = viewstack()
      transition({})(init).subscribeOnNext (result) ->
        result.equals(init).should.be.true
