chai = require 'chai'
sinon = require 'sinon'
chai.should()
chai.use(require 'sinon-chai')

{ Rx } = require '@cycle/core'
createCommandIO = require '../src/intent/io'

main = require '../src/main'

describe 'main', ->
  it 'is a function', ->
    main.should.be.a 'function'

  it 'produces a vtree stream', ->
    main(
      createCommandIO().output
      initialViewstack = {
        views: []
      }
      transitionHooks = {}
      moduleRoot = '/path-to-modules'
    ).should.be.an.instanceof Rx.Observable

  it 'triggers transition hooks when issued commands', ->
    whenShown = sinon.stub()
    whenHidden = sinon.stub()
    commands = createCommandIO()
    main(
      commands.output
      {
        views: []
      }
      {
        show: whenShown
        hide: whenHidden
      }
      '/path-to-modules'
    ).subscribe ->
      whenShown.should.not.have.been.called
      whenHidden.should.not.have.been.called
      commands.input.push({
        components: [
          source: 'foo.html'
        ]
      })
      whenShown.should.have.been.called
      commands.input.pop()
      whenHidden.should.have.been.called
