# XYZ and xyY color space implementation.

# Imports
# -------

{creator} = require "ut1l/obj"

# xyY prototype
# -------------

xyyPrototype =

# Convert color from *xyY* to *XYZ* color space. Give optional *XYZ* color `T` to store the result.
  XYZ: (T = do require "./XYZ") ->
    T.X = @x * @Y / @y
    T.Y = @Y
    T.Z = (1 - @x - @y) * @Y / @y
    T

# Returns `true` if all components of the color are not `null` and not `undefined`.
  isDefined: ->
    @x? and @y? and @Y?

# Returns a human readable string serialization of the color.
  toString: ->
    "x=#{@x}, y=#{@y}, Y=#{@Y}"




# Public API
# ----------

module.exports = creator xyyPrototype, (@x, @y, @Y) -> return