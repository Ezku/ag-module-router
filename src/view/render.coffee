{ h } = require '@cycle/web'

module.exports = renderViewstack = (viewstack) ->
  h 'div#viewstack', viewstack.get('views').map(renderView).toJS()

renderView = (view) ->
  h 'div.view', view.get('components').map(renderComponent).toJS()

renderComponent = (component) ->
  h 'iframe', {
    attributes: componentAttributes component
  }

componentAttributes = (component) ->
  src: component.get('source')
  'data-module': true
