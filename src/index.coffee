{ Rx, h } = Cycle
Promise = supersonic.internal.Promise

module.exports =
  run: (targetSelector, options, createInitialViewstack) ->
    options.moduleRoot ?= "/components"
    Cycle.run main(Immutable.fromJS(createInitialViewstack(Viewstack)), createViewstackRenderer(options.moduleRoot)), {
      DOM: Cycle.makeDOMDriver targetSelector
    }

if window?
  window.ag ?= {}
  window.ag.module ?= {}
  window.ag.module.router = module.exports


main = (initialViewstack, renderViewstack) -> (drivers) ->
  DOM: do ->
    Rx.Observable.of(initialViewstack)
      .merge(pushPopModification())
      .scan((viewstack, modification) -> modification viewstack)
      .map(renderViewstack)
      .doOnError(
        (error) ->
          console.error error
      )


Viewstack = do ->
  views: (views...) -> { views }
  view: (components, show = true) -> { components, show }
  components: (components...) -> [components...]
  component: (route, params) -> { route, params }
  args: (args) ->
    object = {}
    for key, value of args
      object[key] = value
    object


createViewstackRenderer = (moduleRoot) ->
  render = do ->
    route = (name) ->
      "#{moduleRoot}/#{name}.html"

    componentAttributes = (component) ->
      component
        .get('params')
        .mapKeys((key) -> "data-#{key}")
        .merge({
          src: route component.get('route')
          'data-module': 'true'
        })
        .toJS()

    viewAttributes = (view) ->
      if view.get('show')
        styles: "display: block;"
      else
        styles: "display: hidden;"

    viewstack: (viewstack) ->
      h 'div#viewstack', (viewstack.get('views').map(render.view)).toJS()

    view: (view) ->
      h 'div.view', {
        attributes: viewAttributes view
      }, view.get('components').map(render.component).toJS()

    component: (component) ->
      h 'iframe', {
        attributes: componentAttributes component
      }

  return render.viewstack


pushPopModification = do ->
  modifications =
    push: (request) -> (viewstack) ->
      viewstack.update 'views', (views) ->
        views
          .update(-1, (view) ->
            view.set('show', false)
          )
          .push(
            Immutable.fromJS(
              request.push
            )
          )
    pop: (request) -> (viewstack) ->
      viewstack.update 'views', (views) ->
        views
          .pop()
          .update(-1, (view) ->
            view.set('show', true)
          )
    nothing: (viewstack) -> viewstack

  ->
    viewstackRequests = new Rx.Subject

    window.top.viewstack =
      push: (componentName, componentArgs) ->
        do ({view, components, component, args} = Viewstack) ->
          viewstackRequests.onNext {
            push:
              view(
                components(
                  component(componentName, args componentArgs)
                )
              )
          }

        supersonic.ui.animate("slideFromRight", {
          duration: 0.5
          curve: "easeInOut"
        }).perform().then ->
          steroids.view.displayLoading()
          Promise.delay(1000).then ->
            steroids.view.removeLoading()

      pop: ->
        viewstackRequests.onNext {
          pop: true
        }
        supersonic.ui.animate("slideFromLeft", {
          duration: 0.5
          curve: "easeInOut"
        }).perform()

    viewstackRequests
      .map((request) ->
        switch
          when request.push? then modifications.push request
          when request.pop? then modifications.pop request
          else modifications.nothing
      )
