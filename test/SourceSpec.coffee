require('chai').should()

source = require '../src/model/source'

describe 'model.source', ->
  it 'is a function', ->
    source.should.be.a 'function'

  it 'accepts an input Viewstack and produces an Observable', ->
    source({}).subscribe (viewstack) ->
      viewstack.should.deep.equal {}
