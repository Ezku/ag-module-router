require('chai').should()

{ makeHTMLDriver } = require '@cycle/web'

describe "ag-module-router root", ->
  before ->
    global.window = {}

  it "should be defined", ->
    require('../src').should.exist

  it "is a function", ->
    require('../src').should.be.a 'function'

  it "exposes itself to window", ->
    global.window.should.have.property('ag').property('module').property('router').be.a 'function'

  it "can be run", ->
    require('../src')(
      "body"
      {}
      -> makeHTMLDriver()
    )
