{ h } = require '@cycle/web'

module.exports = renderViewstack = (viewstack) ->
  h 'div#viewstack', viewstack.get('views').map(renderView).toJS()

renderView = (view) ->
  h 'div.view'
