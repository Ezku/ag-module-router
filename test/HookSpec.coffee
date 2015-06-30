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

  it 'makes a function into a hook instance', ->
    hook(->).should.have.property('hook').be.a 'function'

  describe 'instance', ->
    it 'is triggered when creating element', ->
      whenCreated = sinon.stub()
      createElement h 'div', {
        hook: hook(whenCreated)
      }
      whenCreated.should.have.been.called
