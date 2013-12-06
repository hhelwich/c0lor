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

    it 'creates a new expected XYZ object', ->

      expect(XYZ.X).to.equal 0.1
      expect(XYZ.Y).to.equal 0.2
      expect(XYZ.Z).to.equal 0.3



  describe 'XYZ <-> xyY', ->

    it 'XYZ maps correctly to xyY', ->

      expect(XYZ.xyY()).to.approx xyY, 0

    it 'can map XYZ to xyY in place', ->

      x = xyYM 0.1,  0.1, 0.1
      y = XYZ.xyY(x)
      expect(y).to.approx xyY, 0
      expect(y).to.equal(x)



  describe 'XYZ.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(_().isDefined()).to.equal false
      expect(_(1).isDefined()).to.equal false
      expect(_(0.1, 0.2, 0.3).isDefined()).to.equal true




  describe 'XYZ.toString()', ->

    it 'creates informative output', ->

      (expect "#{XYZ}").to.equal "X=0.1, Y=0.2, Z=0.3"


