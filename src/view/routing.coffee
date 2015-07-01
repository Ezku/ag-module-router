module.exports = applyModuleRouting = (moduleRoot) ->
  route = routeSourceByModuleRoot moduleRoot

  (viewstack) ->
    viewstack.update 'views', (views) ->
      views.map (view) ->
        view.update 'components', (components) ->
          components.map (component) ->
            component.update 'source', route

routeSourceByModuleRoot = (moduleRoot) -> (source) ->
  "#{moduleRoot}/#{source}"
