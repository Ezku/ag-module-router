chai = require 'chai'
chai.should()
sinon = require 'sinon'
chai.use(require 'sinon-chai')

{ h } = require '@cycle/web'
createElement = require 'virtual-dom/create-element'
diffTree = require 'virtual-dom/diff'
patchElement = require 'virtual-dom/patch'

hook = require '../src/view/hook'
noop = ->

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

      it 'allows subscribing to removal events', ->
        whenRemoved = sinon.stub()

        treeWithHook = h 'div', {
          hook: hook().subscribe(noop, noop, whenRemoved)
        }
        treeWithoutHook = h 'div', {}

        root = createElement treeWithHook
        patches = diffTree(treeWithHook, treeWithoutHook)
        patchElement root, patches

        whenRemoved.should.have.been.called
