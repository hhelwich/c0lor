C = require "./indexToTest"


describe "xyY Colorspace module", ->

  XYZ = null
  xyY = null

  beforeEach ->

    XYZ = C.XYZ 0.1, 0.2, 0.3
    # same color in xyY color space
    xyY = C.xyY 1/6,  1/3, 0.2

    jasmine.addMatchers require "./matcher"


  describe "xyY constructors", ->

    it "creates a new expected xyY object", ->

      (expect xyY.x).toBe 1/6
      (expect xyY.y).toBe 1/3
      (expect xyY.Y).toBe 0.2


  describe "XYZ <-> xyY", ->

    it "xyY maps correctly to XYZ", ->

      (expect xyY.XYZ()).toAllBeCloseTo XYZ, 15

    it "can map xyY to XYZ in place", ->

      x = C.XYZ 0.4,  0.4, 0.4
      y = xyY.XYZ x
      (expect y).toAllBeCloseTo XYZ, 15
      (expect y).toBe x


  describe "xyY.isDefined()", ->

    it "is true if all components are defined", ->

      (expect C.xyY().isDefined()).toBe false
      (expect (C.xyY 0.1).isDefined()).toBe false
      (expect (C.xyY 0.1, 0.2, 0.3).isDefined()).toBe true


  describe "xyY.toString()", ->

    it "creates informative output", ->

      (expect "#{C.xyY 0.2, 0.3, 0.4}").toBe "x=0.2, y=0.3, Y=0.4"
