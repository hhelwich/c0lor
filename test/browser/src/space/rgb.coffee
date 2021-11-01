C = require "../indexToTest"


describe "Rgb Colorspace module", ->

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

    jasmine.addMatchers require "../matcher"


  describe "toXYZ()", ->

    it "maps to XYZ correctly", ->

      (expect rgbCs1.XYZ rgb2).toAllBeCloseTo XYZ2, 3
      (expect rgbCs1.XYZ rgb3).toAllBeCloseTo XYZ3, 3

      (expect rgbCs2.XYZ rgb2).toAllBeCloseTo XYZ2_s, 3
      (expect rgbCs2.XYZ rgb3).toAllBeCloseTo XYZ3_s, 4

      (expect rgbCs1.XYZ rgbCs1.rgb XYZ2).toAllBeCloseTo XYZ2, 15
      (expect rgbCs1.XYZ rgbCs1.rgb XYZ3).toAllBeCloseTo XYZ3, 16

      (expect rgbCs2.XYZ rgbCs2.rgb XYZ2_s).toAllBeCloseTo XYZ2_s, 15
      (expect rgbCs2.XYZ rgbCs2.rgb XYZ3_s).toAllBeCloseTo XYZ3_s, 15


  describe "fromXYZ()", ->

    it "maps to XYZ correctly", ->

      (expect rgbCs1.rgb XYZ2).toAllBeCloseTo rgb2, 4
      (expect rgbCs1.rgb XYZ3).toAllBeCloseTo rgb3, 4

      (expect rgbCs2.rgb XYZ2_s).toAllBeCloseTo rgb2, 3
      (expect rgbCs2.rgb XYZ3_s).toAllBeCloseTo rgb3, 4

      (expect rgbCs1.rgb rgbCs1.XYZ rgb2).toEqual rgb2
      (expect rgbCs1.rgb rgbCs1.XYZ rgb3).toEqual rgb3

      (expect rgbCs2.rgb rgbCs2.XYZ rgb2).toAllBeCloseTo rgb2, 15
      (expect rgbCs2.rgb rgbCs2.XYZ rgb3).toAllBeCloseTo rgb3, 15


  describe "color space constructor", ->

    it "create a new (identity) color space", ->

      cs = C.space.rgb (C.xyY 1, 0), (C.xyY 0, 1), (C.xyY 0, 0), (C.XYZ 1, 1, 1), 1
      (expect cs.XYZ C.rgb 0, 0, 0).toEqual C.XYZ 0, 0, 0
      (expect cs.XYZ C.rgb 1, 0, 0).toEqual C.XYZ 1, 0, 0
      (expect cs.XYZ C.rgb 0, 1, 0).toEqual C.XYZ 0, 1, 0
      (expect cs.XYZ C.rgb 0, 0, 1).toEqual C.XYZ 0, 0, 1
      (expect cs.XYZ C.rgb 1, 1, 1).toEqual C.XYZ 1, 1, 1
      (expect cs.XYZ C.rgb 0.1, 0.2, 0.5).toEqual C.XYZ 0.1, 0.2, 0.5
      (expect cs.rgb C.XYZ 0.1, 0.2, 0.5).toEqual C.rgb 0.1, 0.2, 0.5


  describe "Predefined color spaces", ->

    it "have the expected range in Lab colorspace", ->

      min = C.Lab 0, 0, 0
      max = C.Lab 100, 0, 0

      # rgb test colors
      rgbTest = [
        C.rgb 0, 0, 0
        C.rgb 1, 0, 0
        C.rgb 0, 1, 0
        C.rgb 0, 0, 1
        C.rgb 1, 0, 1
        C.rgb 0, 1, 1
        C.rgb 1, 1, 0
        C.rgb 1, 1, 1
      ]

      for own rgbSpaceName, rgbSpace of C.space.rgb
        if rgbSpaceName == "prototype" # on ios 4.3 / 10.6 the prototype property gets iterable. why?
          continue
        for rgbCol in rgbTest
          xyzCol = rgbSpace.XYZ rgbCol
          for whiteName, white of C.white
            labColor = (C.space.lab white).Lab xyzCol
            min.L = Math.min labColor.L, min.L
            min.a = Math.min labColor.a, min.a
            min.b = Math.min labColor.b, min.b
            max.L = Math.max labColor.L, max.L
            max.a = Math.max labColor.a, max.a
            max.b = Math.max labColor.b, max.b

      (expect min).toEqual C.Lab 0, -223.4241602806217, -237.05355418094155
      (expect max).toEqual C.Lab 100, 191.62605068015958, 158.7312579450673
