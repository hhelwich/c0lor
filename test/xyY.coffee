XYZ = require "chai"
expect = XYZ.expect

XYZ.use require "./approxAssertion"

_ = require '../src/XYZ'
xyYM = require '../src/xyY'

describe 'XYZ Colorspace module', ->

  XYZ = null
  xyY = null

  beforeEach ->

    XYZ = _ 0.1, 0.2, 0.3
    # same color in xyY color space
    xyY = xyYM 1/6,  1/3, 0.2


  describe 'XYZ constructors', ->

    it 'creates a new expected xyY object', ->

      expect(xyY.x).to.equal 1/6
      expect(xyY.y).to.equal 1/3
      expect(xyY.Y).to.equal 0.2


  describe 'XYZ <-> xyY', ->


    it 'xyY maps correctly to XYZ', ->

      expect(xyY.XYZ()).to.approx XYZ, 0.0000000000000001

    it 'can map xyY to XYZ in place', ->

      x = _ 0.4,  0.4, 0.4
      y = xyY.XYZ(x)
      expect(y).to.approx XYZ, 0.0000000000000001
      expect(y).to.equal(x)




  describe 'xyY.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(xyYM().isDefined()).to.equal false
      expect(xyYM(0.1).isDefined()).to.equal false
      expect(xyYM(0.1, 0.2, 0.3).isDefined()).to.equal true




  describe 'xyY.toString()', ->

    it 'creates informative output', ->

      (expect "#{xyYM 0.2, 0.3, 0.4}").to.equal "x=0.2, y=0.3, Y=0.4"
