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
      toApprox: (require './matcher').toApprox


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

    it 'can map XYZ to xyY in place', ->

      x = _.xyY 0.1,  0.1, 0.1
      y = XYZ.xyY(x)
      expect(y).toApprox xyY, 0
      expect(y).toBe(x)

    it 'xyY maps correctly to XYZ', ->

      expect(xyY.XYZ()).toApprox XYZ, 0.0000000000000001

    it 'can map xyY to XYZ in place', ->

      x = _.XYZ 0.4,  0.4, 0.4
      y = xyY.XYZ(x)
      expect(y).toApprox XYZ, 0.0000000000000001
      expect(y).toBe(x)


  describe 'XYZ.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(_.XYZ().isDefined()).toBe false
      expect(_.XYZ(1).isDefined()).toBe false
      expect(_.XYZ(0.1, 0.2, 0.3).isDefined()).toBe true


  describe 'xyY.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(_.xyY().isDefined()).toBe false
      expect(_.xyY(0.1).isDefined()).toBe false
      expect(_.xyY(0.1, 0.2, 0.3).isDefined()).toBe true


  describe 'XYZ.toString()', ->

    it 'creates informative output', ->

      (expect "#{XYZ}").toBe "X=0.1, Y=0.2, Z=0.3"


  describe 'xyY.toString()', ->

    it 'creates informative output', ->

      (expect "#{_.xyY 0.2, 0.3, 0.4}").toBe "x=0.2, y=0.3, Y=0.4"
