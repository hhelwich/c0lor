rgbM = require './rgb'

floor = Math.floor

# see: http://de.wikipedia.org/wiki/HSV-Farbraum

class Hsv
  constructor: (@h, @s, @v) ->

  rgb: (T = rgbM.rgb()) ->
    if @s == 0 # simplification
      T.set @v, @v, @v
    else
      h = (@h - floor @h) * 6  # 0 <= h < 6
      f = h - floor h          # 0 <= f < 1
      p = @v * (1 - @s)
      q = @v * (1 - @s * f)
      t = @v * (1 - @s * (1 - f))
      switch floor h
        when 0 then T.set @v,  t,  p
        when 1 then T.set  q, @v,  p
        when 2 then T.set  p, @v,  t
        when 3 then T.set  p,  q, @v
        when 4 then T.set  t,  p, @v
        when 5 then T.set @v,  p,  q

  toString: ->
    "h=#{@h}, s=#{@s}, v=#{@v}"


# extend rgb model

rgbM.hsv = (h, s, v) ->
  new Hsv(h, s, v)


rgbM.extendRgb (rgb) ->

  rgb::hsv = (T = new Hsv()) ->
    max = Math.max @r, @g, @b
    min = Math.min @r, @g, @b
    T.v = max
    d = max - min
    T.s = if max != 0 then d / max else 0
    if T.s == 0
      T.h = 0
    else
      switch max
        when @r
          T.h = if @g < @b then 6 else 0
          T.h += (@g - @b) / d
        when @g
          T.h = 2 + (@b - @r) / d
        else # blue
          T.h = 4 + (@r - @g) / d
      T.h /= 6
    T
