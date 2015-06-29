require('chai').should()

modification = require '../src/model/modification'
viewstack = require '../src/model/viewstack'

emptyStack = viewstack()
emptyView = {
  components: []
}

describe 'model.modification', ->

  it 'is an object', ->
    modification.should.be.an 'object'

  describe 'push', ->
    it 'is a function', ->
      modification.should.have.property('push').be.a 'function'

    it 'accepts a view and returns a function that pushes that view to the stack', ->
      modification.push(emptyView)(emptyStack).get('views').size.should.equal 1

  describe 'pop', ->
    it 'is a function', ->
      modification.should.have.property('pop').be.a 'function'

    it 'pops an existing view off the stack', ->
      modification.pop()(viewstack(emptyView)).get('views').size.should.equal 0
