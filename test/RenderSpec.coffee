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
    emptyView = {
      components: []
    }

    it 'is rendered as a div', ->
      select('#viewstack DIV.view')(render(viewstack(emptyView))).length.should.equal 1

    describe 'component', ->
      emptyComponent = {}

      it 'is rendered as an iframe with the data-module flag', ->
        select('.view IFRAME[data-module]')(render(viewstack({
          components: [ emptyComponent ]
        }))).length.should.equal 1
