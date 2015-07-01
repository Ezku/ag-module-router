require('chai').should()
{ Rx } = require '@cycle/core'

createCommandIO = require '../src/intent/io'

main = require '../src/main'

describe 'main', ->
  it 'is a function', ->
    main.should.be.a 'function'

  it 'produces a vtree stream', ->
    main(
      createCommandIO().output
      initialViewstack ={
        views: []
      }
      transitionHooks = {}
      moduleRoot = '/path-to-modules'
    ).should.be.an.instanceof Rx.Observable
