Immutable = require 'immutable'

module.exports = applyModuleRouting = (moduleRoot) ->
  route = routeSourceByModuleRoot moduleRoot
  empty = Immutable.List()

  (viewstack) ->
    viewstack.update 'views', empty, (views) ->
      views.map (view) ->
        view.update 'components', empty, (components) ->
          components.map (component) ->
            component.update 'source', route

routeSourceByModuleRoot = (moduleRoot) -> (source) ->
  "#{moduleRoot}/#{source}"
