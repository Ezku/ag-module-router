(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var Promise, Rx, Viewstack, continuousIncreaseModification, h, initialViewstack, main, pushPopModification, render,
    slice = [].slice;

  Rx = Cycle.Rx, h = Cycle.h;

  Promise = supersonic.internal.Promise;

  main = function(drivers) {
    return {
      DOM: (function() {
        return Rx.Observable.of(initialViewstack).merge(pushPopModification()).scan(function(viewstack, modification) {
          return modification(viewstack);
        }).map(render.viewstack).doOnError(function(error) {
          return console.error(error);
        });
      })()
    };
  };

  Viewstack = (function() {
    return {
      views: function() {
        var views;
        views = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return {
          views: views
        };
      },
      view: function(components, show) {
        if (show == null) {
          show = true;
        }
        return {
          components: components,
          show: show
        };
      },
      components: function() {
        var components;
        components = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return slice.call(components);
      },
      component: function(route, params) {
        return {
          route: route,
          params: params
        };
      },
      args: function(args) {
        var key, object, value;
        object = {};
        for (key in args) {
          value = args[key];
          object[key] = value;
        }
        return object;
      }
    };
  })();

  initialViewstack = (function(arg) {
    var args, component, components, view, views;
    views = arg.views, view = arg.view, components = arg.components, component = arg.component, args = arg.args;
    return Immutable.fromJS(views(view(components(component("tasks/index", args({
      'date-format': "MMMM Do YYYY, h:mm:ss a"
    }))))));
  })(Viewstack);

  continuousIncreaseModification = function() {
    var duplicateFirstView;
    duplicateFirstView = function(viewstack) {
      return viewstack.update('views', function(views) {
        return views.push(views.get(0));
      });
    };
    return Rx.Observable.interval(5000).map(function() {
      return duplicateFirstView;
    });
  };

  pushPopModification = (function() {
    var modifications;
    modifications = {
      push: function(request) {
        return function(viewstack) {
          return viewstack.update('views', function(views) {
            return views.update(-1, function(view) {
              return view.set('show', false);
            }).push(Immutable.fromJS(request.push));
          });
        };
      },
      pop: function(request) {
        return function(viewstack) {
          return viewstack.update('views', function(views) {
            return views.pop().update(-1, function(view) {
              return view.set('show', true);
            });
          });
        };
      },
      nothing: function(viewstack) {
        return viewstack;
      }
    };
    return function() {
      var viewstackRequests;
      viewstackRequests = new Rx.Subject;
      window.top.viewstack = {
        push: function(componentName, componentArgs) {
          (function(arg) {
            var args, component, components, view;
            view = arg.view, components = arg.components, component = arg.component, args = arg.args;
            return viewstackRequests.onNext({
              push: view(components(component(componentName, args(componentArgs))))
            });
          })(Viewstack);
          return supersonic.ui.animate("slideFromRight", {
            duration: 0.5,
            curve: "easeInOut"
          }).perform().then(function() {
            steroids.view.displayLoading();
            return Promise.delay(1000).then(function() {
              return steroids.view.removeLoading();
            });
          });
        },
        pop: function() {
          viewstackRequests.onNext({
            pop: true
          });
          return supersonic.ui.animate("slideFromLeft", {
            duration: 0.5,
            curve: "easeInOut"
          }).perform();
        }
      };
      return viewstackRequests.map(function(request) {
        switch (false) {
          case request.push == null:
            return modifications.push(request);
          case request.pop == null:
            return modifications.pop(request);
          default:
            return modifications.nothing;
        }
      });
    };
  })();

  render = (function() {
    var componentAttributes, route, viewAttributes;
    route = function(name) {
      return "/components/supersonic-base-module/" + name + ".html";
    };
    componentAttributes = function(component) {
      return component.get('params').mapKeys(function(key) {
        return "data-" + key;
      }).merge({
        src: route(component.get('route')),
        'data-module': 'true'
      }).toJS();
    };
    viewAttributes = function(view) {
      if (view.get('show')) {
        return {
          styles: "display: block;"
        };
      } else {
        return {
          styles: "display: hidden;"
        };
      }
    };
    return {
      viewstack: function(viewstack) {
        return h('div#viewstack', (viewstack.get('views').map(render.view)).toJS());
      },
      view: function(view) {
        return h('div.view', {
          attributes: viewAttributes(view)
        }, view.get('components').map(render.component).toJS());
      },
      component: function(component) {
        return h('iframe', {
          attributes: componentAttributes(component)
        });
      }
    };
  })();

  Cycle.run(main, {
    DOM: Cycle.makeDOMDriver('body')
  });

}).call(this);

},{}]},{},[1]);
