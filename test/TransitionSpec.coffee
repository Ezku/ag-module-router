chai = require 'chai'
chai.should()
sinon = require 'sinon'
chai.use(require 'sinon-chai')

createElement = require 'virtual-dom/create-element'
renderViewstack = require '../src/view/render'
viewstack = require '../src/model/viewstack'

transition = require '../src/view/transition'

describe 'view.transition', ->
  it 'is a function', ->
    transition.should.be.a 'function'

  it 'accepts transition hook handlers and produces a function', ->
    transition({}).should.be.a 'function'

  describe 'hook handlers', ->
    describe 'show', ->
      it 'is triggered when a view with show state enabled is created', ->
        whenShown = sinon.stub()
        createElement renderViewstack transition(
          show: whenShown
        )(viewstack(
          show: true
          components: []
        ))
        whenShown.should.have.been.called

    describe 'hide', ->
      it 'is triggered when a view with show state disabled is created', ->
        whenHidden = sinon.stub()
        createElement renderViewstack transition(
          hide: whenHidden
        )(viewstack(
          show: false
          components: []
        ))
        whenHidden.should.have.been.called
