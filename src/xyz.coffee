# XYZ and xyY color space implementation.

# Imports
# -------

createConstructor = (require "ut1l/obj").createConstructor

# XYZ prototype
# -------------

xyzPrototype =

  # Convert the color from *XYZ* to *xyY* color space. Give optional *xyY* color `T` to store the result.
  xyY: (T = do createXyy) ->
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


# xyY prototype
# -------------

xyyPrototype =

# Convert color from *xyY* to *XYZ* color space. Give optional *XYZ* color `T` to store the result.
  XYZ: (T = do createXyz) ->
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

module.exports =
  XYZ: createXyz = createConstructor xyzPrototype, (@X, @Y, @Z) -> return
  xyY: createXyy = createConstructor xyyPrototype, (@x, @y, @Y) -> return
