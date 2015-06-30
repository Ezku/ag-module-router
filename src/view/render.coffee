Immutable = require 'immutable'
{ h } = require '@cycle/web'

module.exports = renderViewstack = (viewstack) ->
  h 'div#viewstack', viewstack.get('views').map(renderView).toJS()

renderView = (view) ->
  h 'div.view', viewProps(view), view.get('components').map(renderComponent).toJS()

renderComponent = (component) ->
  h 'iframe', {
    attributes: componentAttributes component
  }

componentAttributes = do ->
  emptyParams = Immutable.OrderedMap()

  (component) ->
    component
      .get('params', emptyParams)
      .mapKeys((key) -> "data-#{key}")
      .merge(
        src: component.get('source')
        'data-module': true
      )
      .toJS()

viewProps = do ->
  emptyHooks = Immutable.OrderedMap()

  (view) ->
    view.get('hooks', emptyHooks).toJS()
