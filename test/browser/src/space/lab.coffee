C = require "../indexToTest"


describe "Lab Colorspace", ->

  XYZ1 = XYZ2 = Lab1 = Lab2 = LCh1 = LCh2 = labCs = null

  beforeEach ->

    labCs = C.space.lab C.white.D50
    XYZ1 = C.XYZ 0.1, 0.2, 0.3
    XYZ2 = C.XYZ 0.0001, 0.002, 0.003
    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = C.Lab 51.8372, -57.4865, -25.7804
    Lab2 = C.Lab 1.8066, -7.3832, -2.5470

    # reference values generated here: http://www.brucelindbloom.com/
    toRad = (a) ->
      (if a > 180 then a - 360 else a) * Math.PI / 180
    LCh1 = C.LCh 51.8372, 63.0026, toRad 204.1543
    LCh2 = C.LCh 1.8066, 7.8102, toRad 199.0330

    jasmine.addMatchers require "../matcher"


  describe "fromXYZ() function", ->

    it "maps correctly to XYZ", ->

      expect(labCs.Lab XYZ1).toAllBeCloseTo Lab1, 2
      expect(labCs.Lab labCs.XYZ Lab1).toAllBeCloseTo Lab1, 13
      expect(labCs.Lab XYZ2).toAllBeCloseTo Lab2, 3
      expect(labCs.Lab labCs.XYZ Lab2).toAllBeCloseTo Lab2, 13


  describe "toXYZ() function", ->

    it "maps correctly to Lab", ->

      expect(labCs.XYZ Lab1).toAllBeCloseTo XYZ1, 4
      expect(labCs.XYZ labCs.Lab XYZ1).toAllBeCloseTo XYZ1, 16
      expect(labCs.XYZ Lab2).toAllBeCloseTo XYZ2, 6
      expect(labCs.XYZ labCs.Lab XYZ2).toAllBeCloseTo XYZ2, 17


  describe "fromXYZderivL()", ->

    it "seems to linear approximate the function at some random point", ->

      f = (Y) -> (labCs.Lab C.XYZ null, Y, null).L
      f_ = (Y) -> labCs.LabderivL Y
      Y = 0.3 # examine around some point Y
      t1 = (x) -> (f Y) + (f_ Y) * (x - Y) # taylor"s theorem
      (expect t1 Y).toBe f Y
      (expect t1 Y + 0.001).toBeCloseTo (f Y + 0.001), 3
      (expect t1 Y - 0.001).toBeCloseTo (f Y - 0.001), 3
