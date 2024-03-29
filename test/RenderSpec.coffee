require('chai').should()
select = require 'vtree-select'

render = require '../src/view/render'
viewstack = require '../src/model/viewstack'
view = require '../src/model/view'
hook = require '../src/view/hook'

describe 'view.render', ->
  it 'is a function', ->
    render.should.be.a 'function'

  it 'accepts a viewstack and produces a virtual-dom tree', ->
    select('DIV.viewstack').matches(render(viewstack())).should.be.true

  describe 'view', ->
    emptyView = view()

    it 'is rendered as a div', ->
      select('.viewstack DIV.view')(render(viewstack(emptyView))).length.should.equal 1

    it 'can have vtree hooks applied', ->
      h = hook()
      [ renderedView ] = select('.view')(render(viewstack(
        components: []
        hooks:
          hook: h
      )))
      renderedView.should.have.property('hooks').have.property('hook').equal h

    describe 'when show is set to false', ->
      hiddenView = view(show: false)

      it 'is rendered as hidden', ->
        select('.viewstack .view.hidden')(render(viewstack(hiddenView))).length.should.equal 1

      it 'has display set to hidden', ->
        [ renderedView ] = select('.viewstack .view')(render(viewstack(hiddenView)))
        renderedView.properties.should.have.property('attributes').have.property('styles').match /display: hidden/

    describe 'component', ->
      emptyComponent = {}

      it 'is rendered as an iframe with the data-module flag', ->
        select('.view IFRAME[data-module]')(render(viewstack({
          components: [ emptyComponent ]
        }))).length.should.equal 1

      describe 'source', ->
        it 'is rendered as the src attribute', ->
          [ renderedComponent ] = select('IFRAME')(render(viewstack({
            components: [
              source: '/path/to/component.html'
            ]
          })))
          renderedComponent.properties.attributes.should.have.property('src').equal '/path/to/component.html'

      describe 'params', ->
        it 'is rendered as attributes with the data-prefix', ->
          [ renderedComponent ] = select('IFRAME')(render(viewstack({
            components: [
              params:
                foo: 'bar'
            ]
          })))
          renderedComponent.properties.attributes.should.have.property('data-foo').equal 'bar'
