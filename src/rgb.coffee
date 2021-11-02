# Imports / Shortcuts
# -------------------


O = require "ut1l/create/object"

round = Math.round

# Helpers
# -------


toByte = (d) ->
  round d * 255 if d?

validRgbEl = (x) ->
  (isFinite x) and 0 <= x <= 1

# RGB prototype
# -------------

rgbPrototype =

  RGB: (T = do require "./RGBInt") ->
    T.R = toByte @r
    T.G = toByte @g
    T.B = toByte @b
    T

  set: (@r, @g, @b) ->
    @

  isDefined: ->
    @r? and @g? and @b?

  isValid: ->
    do @isDefined and (validRgbEl @r) and (validRgbEl @g) and (validRgbEl @b)

  toString: ->
    "r=#{@r}, g=#{@g}, b=#{@b}"



# Public api
# ----------

module.exports =  O (extendRgb: (f) -> f rgbPrototype), ((@r, @g, @b) ->), rgbPrototype