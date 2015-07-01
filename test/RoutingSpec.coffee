require('chai').should()

viewstack = require '../src/model/viewstack'

applyModuleRouting = require '../src/view/routing'

describe 'view.routing', ->
  it 'is a function', ->
    applyModuleRouting.should.be.a 'function'

  it 'accepts a module root and produces a function', ->
    applyModuleRouting('').should.be.a 'function'

  it 'applies module root to all component sources within a viewstack', ->
    applyModuleRouting('/module-root-path')(viewstack(
      components: [
        source: 'foo.html'
      ]
    ))
    .get('views')
    .first()
    .get('components')
    .first()
    .get('source')
    .should.equal '/module-root-path/foo.html'
