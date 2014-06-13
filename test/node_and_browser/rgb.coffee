C = require "./indexToTest"


describe "Rgb module", ->

  XYZ2 = XYZ3 = XYZ2_s = XYZ3_s = null
  rgb1 = rgb2 = rgb3 = rgb4 = null
  RGB1 = RGB2 = RGB3 = RGB4 = null
  rgbCs1 = rgbCs2 = null

  beforeEach ->

    rgb1 = C.rgb 0, undefined, 0
    rgb2 = C.rgb 1, 1, 1
    rgb3 = C.rgb 0.5, 0.3, 0.2
    rgb4 = C.rgb 1.4, 1.00001, -0.1

    RGB1 = C.RGB 0, undefined, 0
    RGB2 = C.RGB 255, 255, 255
    RGB3 = C.RGB 128, 77, 51
    RGB4 = C.RGB undefined, 255, undefined

    rgbCs1 = C.space.rgb["Adobe-98"]
    # Adobe-98 / http://www.brucelindbloom.com
    XYZ2 = C.XYZ 0.95047, 1       , 1.08883
    XYZ3 = C.XYZ 0.1441 , 0.111282, 0.039618

    rgbCs2 = C.space.rgb.sRGB
    # sRGB / http://www.brucelindbloom.com
    XYZ2_s = C.XYZ 0.95047 , 1       , 1.08883
    XYZ3_s = C.XYZ 0.120444, 0.100287, 0.044327

    jasmine.addMatchers require "./matcher"


  describe "rgb.RGB(), RGB.rgb()", ->

    it "rgb.RGB() maps correctly to 3 bit rgb", ->

      (expect rgb1.RGB()).toEqual RGB1
      (expect rgb2.RGB()).toEqual RGB2
      (expect rgb3.RGB()).toEqual RGB3
      (expect rgb4.RGB()).toEqual RGB4


  describe "rgb.toString()", ->

    it "creates informative output", ->

      (expect "#{rgb3}").toBe "r=0.5, g=0.3, b=0.2"


  describe "rgb.isDefined()", ->

    it "is true if all components are defined", ->

      (expect rgb1.isDefined()).toBe false
      (expect rgb2.isDefined()).toBe true
      (expect rgb3.isDefined()).toBe true
      (expect rgb4.isDefined()).toBe true


  describe "rgb.isValid()", ->

    it "is true if all components are defined and between 0..1", ->

      # ok
      (expect (C.rgb 0, 0, 0).isValid()).toBe true
      (expect (C.rgb -0, -0, -0).isValid()).toBe true
      (expect (C.rgb 1, 1, 1).isValid()).toBe true
      (expect (C.rgb 0.1, 0.2, 0.3).isValid()).toBe true
      # not ok
      (expect (C.rgb 0, -0.001, 0).isValid()).toBe false
      (expect (C.rgb 0, 0, 1.0001).isValid()).toBe false
      (expect (C.rgb undefined, 0, 1).isValid()).toBe false
      (expect (C.rgb 0, null, 0).isValid()).toBe false
      (expect (C.rgb 0, Number.POSITIVE_INFINITY, 0).isValid()).toBe false
      (expect (C.rgb 0, Number.NaN, 0).isValid()).toBe false
      (expect (C.rgb 0, Number.NEGATIVE_INFINITY, 0).isValid()).toBe false


  describe "rgb.set()", ->

    it "sets the given values", ->

      rgb_ = C.rgb 0.1, 0.2, 0.3
      rgb2 = rgb_.set 0.4, 0.5, 0.6
      (expect rgb2).toBe rgb_ # return obj for chaining
      (expect rgb_).toEqual C.rgb 0.4, 0.5, 0.6 # values changed
