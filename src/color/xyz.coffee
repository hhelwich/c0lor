
class XYZ
  constructor: (@X, @Y, @Z) ->

  # Convert XYZ color to xyY color
  xyY: (T = @) ->
    new xyY T.X / (T.X + T.Y + T.Z),
            T.Y / (T.X + T.Y + T.Z),
            T.Y


class xyY
  constructor: (@x, @y, @Y) ->

  # Convert xyY color to XYZ color
  XYZ: (T = @) ->
    new XYZ T.x * T.Y / T.y,
            T.Y,
            (1 - T.x - T.y) * T.Y / T.y


# public api
module.exports =
  XYZ: (X, Y, Z) ->
    new XYZ X, Y, Z

  xyY: (x, y, Y) ->
    new xyY x, y, Y
