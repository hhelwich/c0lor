_ = require 'color/lab'
xyz = require 'color/xyz'
white = require 'color/whites'

describe 'Lab Colorspace module', ->

  XYZ1 = null
  XYZ2 = null
  Lab1 = null
  Lab2 = null
  labCs = null

  beforeEach ->

    labCs = _(white.D50)
    XYZ1 = xyz.XYZ 0.1, 0.2, 0.3
    XYZ2 = xyz.XYZ 0.0001, 0.002, 0.003
    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = _.Lab 51.8372, -57.4865, -25.7804
    Lab2 = _.Lab 1.8066, -7.3832, -2.5470

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
