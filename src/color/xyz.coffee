
class XYZ
  constructor: (@X, @Y, @Z) ->

  # Convert XYZ color to xyY color
  xyY: (T = new xyY) ->
    T.x = @X / (@X + @Y + @Z)
    T.y = @Y / (@X + @Y + @Z)
    T.Y = @Y
    T


class xyY
  constructor: (@x, @y, @Y) ->

  # Convert xyY color to XYZ color
  XYZ: (T = new XYZ) ->
    T.X = @x * @Y / @y
    T.Y = @Y
    T.Z = (1 - @x - @y) * @Y / @y
    T


# public api
module.exports =
  XYZ: (X, Y, Z) ->
    new XYZ X, Y, Z

  xyY: (x, y, Y) ->
    new xyY x, y, Y
