chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"

_ = require '../src/xyz'

describe 'XYZ Colorspace module', ->

  XYZ = null
  xyY = null

  beforeEach ->

    XYZ = _.XYZ 0.1, 0.2, 0.3
    # same color in xyY color space
    xyY = _.xyY 1/6,  1/3, 0.2


  describe 'XYZ constructors', ->

    it 'creates a new expected XYZ object', ->

      expect(XYZ.X).to.equal 0.1
      expect(XYZ.Y).to.equal 0.2
      expect(XYZ.Z).to.equal 0.3

    it 'creates a new expected xyY object', ->

      expect(xyY.x).to.equal 1/6
      expect(xyY.y).to.equal 1/3
      expect(xyY.Y).to.equal 0.2


  describe 'XYZ <-> xyY', ->

    it 'XYZ maps correctly to xyY', ->

      expect(XYZ.xyY()).to.approx xyY, 0

    it 'can map XYZ to xyY in place', ->

      x = _.xyY 0.1,  0.1, 0.1
      y = XYZ.xyY(x)
      expect(y).to.approx xyY, 0
      expect(y).to.equal(x)

    it 'xyY maps correctly to XYZ', ->

      expect(xyY.XYZ()).to.approx XYZ, 0.0000000000000001

    it 'can map xyY to XYZ in place', ->

      x = _.XYZ 0.4,  0.4, 0.4
      y = xyY.XYZ(x)
      expect(y).to.approx XYZ, 0.0000000000000001
      expect(y).to.equal(x)


  describe 'XYZ.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(_.XYZ().isDefined()).to.equal false
      expect(_.XYZ(1).isDefined()).to.equal false
      expect(_.XYZ(0.1, 0.2, 0.3).isDefined()).to.equal true


  describe 'xyY.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(_.xyY().isDefined()).to.equal false
      expect(_.xyY(0.1).isDefined()).to.equal false
      expect(_.xyY(0.1, 0.2, 0.3).isDefined()).to.equal true


  describe 'XYZ.toString()', ->

    it 'creates informative output', ->

      (expect "#{XYZ}").to.equal "X=0.1, Y=0.2, Z=0.3"


  describe 'xyY.toString()', ->

    it 'creates informative output', ->

      (expect "#{_.xyY 0.2, 0.3, 0.4}").to.equal "x=0.2, y=0.3, Y=0.4"
