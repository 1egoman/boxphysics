_ = require "underscore"
uuid = require "uuid"

class TextMap

  constructor: ->
    @objects = []
    [@rw, @rh] = [20, 10]

    # these chars make up the corners of glyphs
    @cornerChars = ['+', '\u253C', '\u250C', '\u2510', '\u2514', '\u2518']

    # these chars make up the edges to the glyphs
    @lineChars = ['\u2502', '\u2500']

    # these characters always take preferance over a + or other corner char
    @overwriteableToPlus = ['▓'].concat @cornerChars


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
            if b[i][j] not in [' ', null, undefined] and (b[i][j] in @overwriteableToPlus or renderscreen[i][j] not in @cornerChars)
              # check about corners to be sure we are doing the right
              # replacements - for now, all corners that are to be replaced
              # go into pluses
              if b[i][j] in @cornerChars and (renderscreen[i][j] in @lineChars or renderscreen[i][j] in @cornerChars)
                b[i][j] = '\u253C'

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


    if obj.data.filled
      # for a filled box, the middle is just the filled character
      middle = [0...h-2].map(-> [0...w].map(-> obj.data.filledWith or '▓').join '').join '\n'
      topHorisontalExpanse = middle
      botHorisontalExpanse = middle
    else
      # unfilled box

      # for each vertical line
      middle = [0...h-2].map(-> "\u2502#{[0...w-2].map(-> ' ').join ''}\u2502").join '\n'

      # render the initial horisontal expanse and the final one
      topHorisontalExpanse = "\u250C#{[0...w-2].map(-> '―').join ''}\u2510"
      botHorisontalExpanse = "\u2514#{[0...w-2].map(-> '―').join ''}\u2518"

    # return the finished box
    box = _.flatten([topHorisontalExpanse, middle, botHorisontalExpanse]).join '\n'

    # offset the correct distance
    @offsetGlyph x, y, box
    
exports.TextMap = TextMap
