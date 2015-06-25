{TextMap} = require './textmap'

module.exports = (env, argv) ->

  map = new TextMap
  map.box
    x: 1
    y: 0
    w: 5
    h: 5
  map.box
    x: 1
    y: 0
    w: 3
    h: 3

  map.redraw()
