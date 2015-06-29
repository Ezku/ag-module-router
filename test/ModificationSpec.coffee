require('chai').should()

modification = require '../src/model/modification'
viewstack = require '../src/model/viewstack'

describe 'model.modification', ->

  it 'is an object', ->
    modification.should.be.an 'object'

  describe 'push', ->
    it 'is a function', ->
      modification.should.have.property('push').be.a 'function'

    emptyStack = viewstack()
    emptyView = {
      components: []
    }

    it 'accepts a view and returns a function that pushes that view to the stack', ->
      modification.push(emptyView)(emptyStack).get('views').size.should.equal 1
