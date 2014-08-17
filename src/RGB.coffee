

O = require "ut1l/create/object"


fromByte = (b) ->
  if b == undefined then b else b / 255

to2Hex = (b) ->
  hex = do (b.toString 16).toUpperCase
  if hex.length == 1 then "0" + hex else hex

from2Hex = (str) ->
  parseInt str, 16

isValid = (n) ->
  0 <= n <= 255 and n % 1 == 0

# RGB 24 bit prototype
# --------------------

rgb24Prototype =

  rgb: (T = do require "./rgb") ->
    T.r = fromByte @R
    T.g = fromByte @G
    T.b = fromByte @B
    T

  hex: (str) ->
    if str?
      @R = from2Hex str.substring 0, 2
      @G = from2Hex str.substring 2, 4
      @B = from2Hex str.substring 4, 6
      @
    else
      if do @isDefined then (to2Hex @R) + (to2Hex @G) + (to2Hex @B) else undefined

  isDefined: ->
    @R? and @G? and @B?

  isValid: ->
    @isDefined() and (isValid @R) and (isValid @G) and (isValid @B)

  toString: ->
    "R=#{@R}, G=#{@G}, B=#{@B}"



# Public api
# ----------

module.exports = O ((@R, @G, @B) ->), rgb24Prototype