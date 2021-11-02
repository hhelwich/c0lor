C = require "./indexToTest"


describe "RGB 24 bit color", ->

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


  describe "RGB.rgb()", ->

    it "RGB.rgb() maps correctly from 3 bit rgb", ->

      (expect RGB1.rgb()).toEqual rgb1
      (expect RGB2.rgb()).toEqual rgb2
      (expect RGB3.rgb()).toAllBeCloseTo rgb3, 2
      (expect RGB4.rgb()).toEqual C.rgb undefined, 1, undefined

    it "RGB -> rgb -> RGB = Id", ->

      (expect RGB1.rgb().RGB()).toEqual RGB1
      (expect RGB2.rgb().RGB()).toEqual RGB2
      (expect RGB3.rgb().RGB()).toEqual RGB3
      (expect RGB4.rgb().RGB()).toEqual RGB4


  describe "RGB.hex()", ->

    it "creates hex string", ->

      (expect RGB1.hex()).toBeUndefined()
      (expect RGB2.hex()).toBe "FFFFFF"
      (expect RGB3.hex()).toBe "804D33"
      (expect RGB4.hex()).toBeUndefined()

    it "parses hex string", ->

      (expect RGB1.hex "FFFFFF").toEqual RGB2
      (expect C.RGB().hex "804D33").toEqual RGB3


  describe "RGB.toString()", ->

    it "creates informative output", ->

      (expect "#{RGB3}").toBe "R=128, G=77, B=51"


  describe "RGB.isDefined()", ->

    it "is true if all components are defined", ->

      (expect RGB1.isDefined()).toBe false
      (expect RGB2.isDefined()).toBe true
      (expect RGB3.isDefined()).toBe true
      (expect RGB4.isDefined()).toBe false


  describe "RGB.isValid()", ->

    it "is true if all components are defined and in the desired range", ->

      (expect RGB1.isValid()).toBe false # not defined
      (expect RGB2.isValid()).toBe true
      (expect RGB3.isValid()).toBe true
      (expect RGB4.isValid()).toBe false # not defined
      # out of range
      (expect (C.RGB -1, 0, 0).isValid()).toBe false
      (expect (C.RGB 0, -1, 0).isValid()).toBe false
      (expect (C.RGB 0, 0, -1).isValid()).toBe false
      (expect (C.RGB 256, 0, 0).isValid()).toBe false
      # rational number
      (expect (C.RGB 0, 0.1, 0).isValid()).toBe false
