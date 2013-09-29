_ = require 'color/lab'
xyz = require 'color/xyz'
white = require 'color/whites'

describe 'Lab Colorspace module', ->

  XYZ1 = XYZ2 = Lab1 = Lab2 = LCh1 = LCh2 = labCs = null

  beforeEach ->

    labCs = _(white.D50)
    XYZ1 = xyz.XYZ 0.1, 0.2, 0.3
    XYZ2 = xyz.XYZ 0.0001, 0.002, 0.003
    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = _.Lab 51.8372, -57.4865, -25.7804
    Lab2 = _.Lab 1.8066, -7.3832, -2.5470

    # reference values generated here: http://www.brucelindbloom.com/
    toRad = (a) ->
      (if a > 180 then a - 360 else a) * Math.PI / 180
    LCh1 = _.LCh 51.8372, 63.0026, toRad 204.1543
    LCh2 = _.LCh 1.8066, 7.8102, toRad 199.0330

    @addMatchers
      toApprox: (require './matcher').toApprox


  describe 'fromXYZ() function', ->

    it 'maps correctly to XYZ', ->

      expect(labCs.fromXYZ XYZ1).toApprox Lab1, 0.01
      expect(labCs.fromXYZ labCs.toXYZ Lab1).toApprox Lab1, 0.00000000000001
      expect(labCs.fromXYZ XYZ2).toApprox Lab2, 0.001
      expect(labCs.fromXYZ labCs.toXYZ Lab2).toApprox Lab2, 0.00000000000001


  describe 'toXYZ() function', ->

    it 'maps correctly to Lab', ->

      expect(labCs.toXYZ Lab1).toApprox XYZ1, 0.00001
      expect(labCs.toXYZ labCs.fromXYZ XYZ1).toApprox XYZ1, 0.0000000000000001
      expect(labCs.toXYZ Lab2).toApprox XYZ2, 0.0000001
      expect(labCs.toXYZ labCs.fromXYZ XYZ2).toApprox XYZ2, 0.00000000000000001


  describe 'fromXYZderivL()', ->

    it 'seems to linear approximate the function at some random point', ->

      f = (Y) -> (labCs.fromXYZ xyz.XYZ null, Y, null).L
      f_ = (Y) -> labCs.fromXYZderivL Y
      Y = 0.3 # examine around some point Y
      t1 = (x) -> (f Y) + (f_ Y) * (x - Y) # taylor's theorem
      (expect t1 Y).toBe f Y
      (expect t1 Y + 0.001).toApprox (f Y + 0.001), 0.0001
      (expect t1 Y - 0.001).toApprox (f Y - 0.001), 0.0001


  describe 'Lab.LCh() function', ->

    it 'maps correctly to LCh', ->

      (expect Lab1.LCh()).toApprox LCh1, 0.00001
      (expect Lab2.LCh()).toApprox LCh2, 0.0001


  describe 'LCh.Lab() function', ->

    it 'maps correctly to Lab', ->

      (expect LCh1.Lab()).toApprox Lab1, 0.0001
      (expect LCh2.Lab()).toApprox Lab2, 0.0001
