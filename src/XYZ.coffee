# XYZ and xyY color space implementation.

# Imports
# -------

{creator} = require "ut1l/obj"

# XYZ prototype
# -------------

xyzPrototype =

  # Convert the color from *XYZ* to *xyY* color space. Give optional *xyY* color `T` to store the result.
  xyY: (T = do require "./xyY") ->
    T.x = @X / (@X + @Y + @Z)
    T.y = @Y / (@X + @Y + @Z)
    T.Y = @Y
    T

  # Returns `true` if all components of the color are not `null` and not `undefined`.
  isDefined: ->
    @X? and @Y? and @Z?

  # Returns a human readable string serialization of the color.
  toString: ->
    "X=#{@X}, Y=#{@Y}, Z=#{@Z}"




# Public API
# ----------

module.exports = creator xyzPrototype, (@X, @Y, @Z) -> return
