chai = require 'chai'
chai.should()
sinon = require 'sinon'
chai.use(require 'sinon-chai')

{ Rx } = require '@cycle/core'
Immutable = require 'immutable'
createElement = require 'virtual-dom/create-element'
renderViewstack = require '../src/view/render'
viewstack = require '../src/model/viewstack'
modification = require '../src/model/modification'

transition = require '../src/view/transition'

runTransition = (t) ->
  t.map(renderViewstack).map(createElement).subscribe()

describe 'view.transition', ->
  it 'is a function', ->
    transition.should.be.a 'function'

  it 'accepts transition hook handlers and produces a function', ->
    transition({}).should.be.a 'function'

  describe 'hook handlers', ->
    describe 'pop', ->
      it 'is triggered when a view with a pop transition is created', ->
        whenShown = sinon.stub()
        runTransition transition(
          pop: whenShown
        )(viewstack(
          transition: 'pop'
          components: []
        ))
        whenShown.should.have.been.called

      it 'receives the hook event as an argument', ->
        runTransition transition(
          pop: (event) ->
            event.should.have.keys('node', 'previousValue', 'propertyName')
        )(viewstack(
          transition: 'pop'
          components: []
        ))

    describe 'push', ->
      it 'is triggered when a view with a push transition is created', ->
        whenHidden = sinon.stub()
        runTransition transition(
          push: whenHidden
        )(viewstack(
          transition: 'push'
          components: []
        ))
        whenHidden.should.have.been.called

      it 'receives the hook event as an argument', ->
        runTransition transition(
          push: (event) ->
            event.should.have.keys('node', 'previousValue', 'propertyName')
        )(viewstack(
          transition: 'push'
          components: []
        ))

  it 'turns the viewstack into a stream of viewstacks with successive transition states', ->
    transition({})(viewstack()).should.be.an.instanceof Rx.Observable

  describe 'stream', ->
    describe 'without transition hooks', ->
      init = viewstack(
        components: []
      )

      it 'yields the input viewstack', ->
        transition({})(init).subscribeOnNext (result) ->
          result.equals(init).should.be.true

      it 'completes immediately', ->
        whenCompleted = sinon.stub()
        transition({})(init).subscribeOnCompleted(whenCompleted)
        whenCompleted.should.have.been.called

    describe 'with transition hooks', ->
      init = viewstack(
        show: true
        transition: 'pop'
        components: []
      )
      emptyHooks = Immutable.OrderedMap()

      it 'yields a start state and a complete state', ->
        transition(
          pop: ->
        )(init).map(-> 1).sum().subscribeOnNext (numberOfStates) ->
          numberOfStates.should.equal 2

      it 'yields the stack with hooks applied as the first item', ->
        transition(
          pop: ->
        )(init).take(1).subscribeOnNext (stack) ->
          stack
            .get('views')
            .first()
            .get('hooks', emptyHooks)
            .has('pop')
            .should.equal true

      it 'yields the stack without hooks as the second item', ->
        transition(
          pop: ->
        )(init).skip(1).subscribeOnNext (stack) ->
          stack
            .get('views')
            .first()
            .get('hooks', emptyHooks)
            .has('pop')
            .should.equal false
