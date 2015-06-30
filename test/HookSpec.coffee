chai = require 'chai'
chai.should()
sinon = require 'sinon'
chai.use(require 'sinon-chai')

{ h } = require '@cycle/web'
createElement = require 'virtual-dom/create-element'

hook = require '../src/view/hook'

describe 'view.hook', ->
  it 'is a function', ->
    hook.should.be.a 'function'

  it 'creates a hook instance', ->
    hook().should.respondTo('hook')

  describe 'instance', ->
    describe 'subscribe', ->
      it 'is a function', ->
        hook().should.have.property('subscribe').be.a 'function'

      it 'allows subscribing to creation events', ->
        whenCreated = sinon.stub()
        createElement h 'div', {
          hook: hook().subscribe(whenCreated)
        }
        whenCreated.should.have.been.called
