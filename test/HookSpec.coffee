chai = require 'chai'
chai.should()
sinon = require 'sinon'
chai.use(require 'sinon-chai')

{ h } = require '@cycle/web'
{ Rx } = require '@cycle/core'
createElement = require 'virtual-dom/create-element'
diffTree = require 'virtual-dom/diff'
patchElement = require 'virtual-dom/patch'

hook = require '../src/view/hook'

describe 'view.hook', ->
  it 'is a function', ->
    hook.should.be.a 'function'

  it 'creates a virtual-dom hook instance', ->
    hook().should.respondTo('hook')
    hook().should.respondTo('unhook')

  it 'accepts a function that receives an observable', ->
    hook (e) ->
      e.should.be.an.instanceof Rx.Observable

  it 'allows subscribing to element creation events', ->
    whenCreated = sinon.stub()
    createElement h 'div', {
      hook: hook (e) ->
        e.subscribeOnNext whenCreated
    }
    whenCreated.should.have.been.called

  it 'allows subscribing to element removal events', ->
    whenRemoved = sinon.stub()

    treeWithHook = h 'div', {
      hook: hook (e) ->
        e.subscribeOnCompleted whenRemoved
    }
    treeWithoutHook = h 'div', {}

    root = createElement treeWithHook
    patches = diffTree(treeWithHook, treeWithoutHook)
    patchElement root, patches

    whenRemoved.should.have.been.called
