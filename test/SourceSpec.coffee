require('chai').should()

viewstack = require '../src/model/viewstack'

source = require '../src/model/source'

describe 'model.source', ->
  it 'is a function', ->
    source.should.be.a 'function'

  it 'accepts an input Viewstack and produces an Observable', ->
    source({
      views: [
        {
          components: []
        }
      ]
    }).subscribe (vs) ->
      vs.toJS().should.deep.equal {
        views: [
          components: []
        ]
      }
