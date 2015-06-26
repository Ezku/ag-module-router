require('chai').should()

describe "ag-module-router root", ->
  it "should be defined", ->
    require('../src').should.exist