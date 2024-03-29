require('chai').should()
Immutable = require 'immutable'

modification = require '../src/model/modification'
viewstack = require '../src/model/viewstack'
view = require '../src/model/view'

emptyStack = viewstack()
emptyView = view()

describe 'model.modification', ->

  it 'is an object', ->
    modification.should.be.an 'object'

  describe 'push', ->
    it 'is a function', ->
      modification.should.have.property('push').be.a 'function'

    it 'accepts a view and returns a function that pushes that view to the stack', ->
      modification.push(emptyView)(emptyStack)
        .get('views')
        .size.should.equal 1

    it 'marks the view below the top one as not shown', ->
      modification.push(emptyView)(viewstack(emptyView))
        .get('views')
        .first()
        .get('show', true)
        .should.equal false

    it 'marks the view on top as being pushed', ->
      modification.push(emptyView)(viewstack(emptyView))
        .get('views')
        .last()
        .get('transition')
        .should.equal 'push'

    it 'removes transition state from views except the one affected', ->
      modification.push(emptyView)(modification.push(emptyView)(viewstack(emptyView)))
        .get('views')
        .filter((view) -> view.has('transition'))
        .size.should.equal 1

  describe 'pop', ->
    it 'is a function', ->
      modification.should.have.property('pop').be.a 'function'

    it 'pops an existing view off the stack', ->
      modification.pop()(viewstack(emptyView))
        .get('views')
        .size.should.equal 0

    it 'marks the view left on top as shown', ->
      modification.pop()(viewstack(emptyView, emptyView))
        .get('views')
        .last()
        .get('show', false)
        .should.equal true

    it 'marks the view on top with a pop transition', ->
      modification.pop()(viewstack(emptyView, emptyView))
        .get('views')
        .last()
        .get('transition')
        .should.equal 'pop'

    it 'ensures only view left on top has transition state', ->
      modification.pop()(modification.push(emptyView)(viewstack(emptyView)))
        .get('views')
        .filter((view) -> view.has('transition'))
        .size.should.equal 1
