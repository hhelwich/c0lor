chai = require "chai"
expect = chai.expect

chai.use require "../approxAssertion"

_ = require '../../src/space/lab'
xyz = require '../../src/XYZ'
Lab = require '../../src/Lab'
LCh = require '../../src/Lab'
white = require '../../src/white'

describe 'Lab Colorspace', ->


  XYZ1 = XYZ2 = Lab1 = Lab2 = LCh1 = LCh2 = labCs = null

  beforeEach ->

    labCs = _ white.D50
    XYZ1 = xyz 0.1, 0.2, 0.3
    XYZ2 = xyz 0.0001, 0.002, 0.003
    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = Lab 51.8372, -57.4865, -25.7804
    Lab2 = Lab 1.8066, -7.3832, -2.5470

    # reference values generated here: http://www.brucelindbloom.com/
    toRad = (a) ->
      (if a > 180 then a - 360 else a) * Math.PI / 180
    LCh1 = LCh 51.8372, 63.0026, toRad 204.1543
    LCh2 = LCh 1.8066, 7.8102, toRad 199.0330


  describe 'fromXYZ() function', ->

    it 'maps correctly to XYZ', ->

      expect(labCs.fromXYZ XYZ1).to.approx Lab1, 0.01
      expect(labCs.fromXYZ labCs.toXYZ Lab1).to.approx Lab1, 0.00000000000001
      expect(labCs.fromXYZ XYZ2).to.approx Lab2, 0.001
      expect(labCs.fromXYZ labCs.toXYZ Lab2).to.approx Lab2, 0.00000000000001


  describe 'toXYZ() function', ->

    it 'maps correctly to Lab', ->

      expect(labCs.toXYZ Lab1).to.approx XYZ1, 0.00001
      expect(labCs.toXYZ labCs.fromXYZ XYZ1).to.approx XYZ1, 0.0000000000000001
      expect(labCs.toXYZ Lab2).to.approx XYZ2, 0.0000001
      expect(labCs.toXYZ labCs.fromXYZ XYZ2).to.approx XYZ2, 0.00000000000000001


  describe 'fromXYZderivL()', ->

    it 'seems to linear approximate the function at some random point', ->

      f = (Y) -> (labCs.fromXYZ xyz null, Y, null).L
      f_ = (Y) -> labCs.fromXYZderivL Y
      Y = 0.3 # examine around some point Y
      t1 = (x) -> (f Y) + (f_ Y) * (x - Y) # taylor's theorem
      (expect t1 Y).to.equal f Y
      (expect t1 Y + 0.001).to.approx (f Y + 0.001), 0.0001
      (expect t1 Y - 0.001).to.approx (f Y - 0.001), 0.0001


