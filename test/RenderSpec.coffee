require('chai').should()
select = require 'vtree-select'

render = require '../src/view/render'
viewstack = require '../src/model/viewstack'

describe 'view.render', ->
  it 'is a function', ->
    render.should.be.a 'function'

  it 'accepts a viewstack and produces a virtual-dom tree', ->
    select('DIV#viewstack').matches(render(viewstack())).should.be.true

  describe 'view', ->
    it 'is rendered as a div', ->
      select('DIV.view')(render(viewstack({}))).length.should.equal 1
