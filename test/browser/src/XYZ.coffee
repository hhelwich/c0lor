C = require "./indexToTest"


describe "XYZ Colorspace module", ->

  XYZ = null
  xyY = null

  beforeEach ->

    XYZ = C.XYZ 0.1, 0.2, 0.3
    # same color in xyY color space
    xyY = C.xyY 1/6,  1/3, 0.2

    jasmine.addMatchers require "./matcher"


  describe "XYZ constructors", ->

    it "creates a new expected XYZ object", ->

      (expect XYZ.X).toBe 0.1
      (expect XYZ.Y).toBe 0.2
      (expect XYZ.Z).toBe 0.3


  describe "XYZ <-> xyY", ->

    it "XYZ maps correctly to xyY", ->

      (expect XYZ.xyY()).toEqual xyY

    it "can map XYZ to xyY in place", ->

      x = C.xyY 0.1,  0.1, 0.1
      y = XYZ.xyY x
      (expect y).toEqual xyY
      (expect y).toBe x


  describe "XYZ.isDefined()", ->

    it "is true if all components are defined", ->

      (expect C.XYZ().isDefined()).toBe false
      (expect (C.XYZ 1).isDefined()).toBe false
      (expect (C.XYZ 0.1, 0.2, 0.3).isDefined()).toBe true


  describe "XYZ.toString()", ->

    it "creates informative output", ->

      (expect "#{XYZ}").toBe "X=0.1, Y=0.2, Z=0.3"
