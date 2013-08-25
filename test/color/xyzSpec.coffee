_ = require 'color/xyz'

describe 'XYZ Colorspace module', ->

  XYZ = null
  xyY = null

  beforeEach ->

    XYZ = _.XYZ 0.1, 0.2, 0.3
    # same color in xyY color space
    xyY = _.xyY 1/6,  1/3, 0.2

    # checks if actual object contains all expected properties and that the number values are similar
    @addMatchers
      toApprox: (expected, maxEps) ->
        for key, numb of expected
          expect(@actual[key]).toBeDefined()
          if (Math.abs @actual[key] - numb) > maxEps
            return false
        true


  describe 'XYZ constructors', ->

    it 'creates a new expected XYZ object', ->

      expect(XYZ.X).toBe 0.1
      expect(XYZ.Y).toBe 0.2
      expect(XYZ.Z).toBe 0.3

    it 'creates a new expected xyY object', ->

      expect(xyY.x).toBe 1/6
      expect(xyY.y).toBe 1/3
      expect(xyY.Y).toBe 0.2


  describe 'XYZ <-> xyY', ->

    it 'XYZ maps correctly to xyY', ->

      expect(XYZ.xyY()).toApprox xyY, 0

    it 'xyY maps correctly to XYZ', ->

      expect(xyY.XYZ()).toApprox XYZ, 0.0000000000000001