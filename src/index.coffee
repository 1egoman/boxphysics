{TextMap} = require './textmap'

module.exports = (env, argv) ->

  map = new TextMap

  # larger box
  map.box
    x: 1
    y: 10
    w: 5
    h: 5

  # smaller box
  map.box
    # filled: true
    x: 0
    y: 0
    w: 3
    h: 3

  map.box
    # filled: true
    x: 3
    y: 0
    w: 5
    h: 3

  map.redraw()

  setInterval ->
    map.render()
    console.log "rendered tick #{map.ticks}"
    map.redraw()
  , 1000
