require('chai').should()
select = require 'vtree-select'

render = require '../src/view/render'

describe 'view.render', ->
  it 'is a function', ->
    render.should.be.a 'function'

  it 'accepts a viewstack and produces a virtual-dom tree', ->
    select('DIV#viewstack').matches(render({})).should.be.true
