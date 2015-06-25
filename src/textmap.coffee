_ = require "underscore"
uuid = require "uuid"

class TextMap

  constructor: ->
    @objects = []
    [@rw, @rh] = [20, 10]


  box: (opts) ->
    @objects.push
      type: "box"
      id: uuid.v4()
      data: opts

  redraw: ->
    renderlist = _.flatten @objects
    renderbuffer = []

    renderscreen = []
    [rw, rh] = [@rw, @rh] # screen hight hack (I tried to replace but then weird errors)
    for obj in renderlist

      switch obj.type
        when 'box', 'cube' then renderbuffer.push @drawBox obj


    # create map
    renderscreen = [0...rh].map -> [0...rw].map -> ' '
      
    # merge all renders together
    for buf in renderbuffer
      b = buf.split('\n').map (a) -> a.split ''
      for i in [0...rh]
        for j in [0...rw]
          try
            if b[i][j] not in [' ', null, undefined] and renderscreen[i][j] isnt '+'
              renderscreen[i][j] = b[i][j] or ' '
          catch error
            renderscreen[i][j] = renderscreen[i][j] or ' '


    # draw map to screen
    console.log [0...rw].map(-> '-').join ''
    console.log renderscreen.map((ln) -> ln.join '').join '\n'
    console.log [0...rw].map(-> '-').join ''

  
  ##############
  # drawing code
  ##############
  offsetGlyph: (x, y, glyph) ->
    # x offset
    glyph = glyph.split('\n').map (ln) -> "#{[0...x].map(-> '  ').join ''}#{ln}"

    # y offset
    glyph.unshift [0...@rh-y-glyph.length].map(-> [0...glyph[0].length].map(-> ' ').join '').join '\n'

    glyph.join '\n'


  # draw a normal box
  drawBox: (obj) ->
    {x, y, w, h} = obj.data

    # render the initial horisontal expanse and the final one
    horisontalExpanse = "+#{[0...w-2].map(-> '―').join ''}+"

    # for each vertical line
    middle = [0...h-2].map(-> "\u2502#{[0...w-2].map(-> ' ').join ''}\u2502").join '\n'

    # return the finished box
    box = _.flatten([horisontalExpanse, middle, horisontalExpanse]).join '\n'

    # offset the correct distance
    @offsetGlyph x, y, box
    
exports.TextMap = TextMap
