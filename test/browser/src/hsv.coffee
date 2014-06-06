C = require "./indexToTest"


describe "Hsv module", ->

  hsvBlack = hsvRed = hsvYellow = hsvBrown = hsvWhite = hsvGreen = hsvDarkGreen = hsvCyan = hsvBlue = hsvMagenta = null
  rgbBlack = rgbRed = rgbYellow = rgbBrown = rgbWhite = rgbGreen = rgbDarkGreen = rgbCyan = rgbBlue = rgbMagenta = null

  beforeEach ->

    hsvBlack = C.hsv 0, 0, 0 # any value for h & s
    hsvRed = C.hsv 0, 1, 1
    hsvYellow = C.hsv 60/360, 1, 1
    hsvBrown = C.hsv 24/360, .75, .36
    hsvWhite = C.hsv 0, 0, 1 # any value for h
    hsvGreen = C.hsv 120/360, 1, 1
    hsvDarkGreen = C.hsv 120/360, 1, 0.5
    hsvCyan = C.hsv 180/360, 1, 1
    hsvBlue = C.hsv 240/360, 1, 1
    hsvMagenta = C.hsv 300/360, 1, 1

    rgbBlack = C.rgb 0, 0, 0
    rgbRed = C.rgb 1, 0, 0
    rgbYellow = C.rgb 1, 1, 0
    rgbBrown = C.rgb .36, .198, .09
    rgbWhite = C.rgb 1, 1, 1
    rgbGreen = C.rgb 0, 1, 0
    rgbDarkGreen = C.rgb 0, .5, 0
    rgbCyan = C.rgb 0, 1, 1
    rgbBlue = C.rgb 0, 0, 1
    rgbMagenta = C.rgb 1, 0, 1

    jasmine.addMatchers require "./matcher"


  describe "hsv constructor", ->

    it "stores given args", ->
      (expect hsvBrown.h).toBe 24/360
      (expect hsvBrown.s).toBe .75
      (expect hsvBrown.v).toBe .36


  describe "hsv.rgb()", ->

    it "maps correctly to rgb", ->

      (expect hsvBlack.rgb()).toEqual rgbBlack
      (expect hsvRed.rgb()).toEqual rgbRed
      (expect hsvYellow.rgb()).toEqual rgbYellow
      (expect hsvBrown.rgb()).toEqual rgbBrown
      (expect hsvWhite.rgb()).toEqual rgbWhite
      (expect hsvGreen.rgb()).toEqual rgbGreen
      (expect hsvDarkGreen.rgb()).toEqual rgbDarkGreen
      (expect hsvCyan.rgb()).toEqual rgbCyan
      (expect hsvBlue.rgb()).toEqual rgbBlue
      (expect hsvMagenta.rgb()).toEqual rgbMagenta


  describe "rgb.hsv()", ->

    it "maps correctly to hsv", ->

      (expect rgbBlack.hsv()).toEqual hsvBlack
      (expect rgbRed.hsv()).toEqual hsvRed
      (expect rgbYellow.hsv()).toEqual hsvYellow
      (expect rgbBrown.hsv()).toAllBeCloseTo hsvBrown, 15
      (expect rgbWhite.hsv()).toEqual hsvWhite
      (expect rgbGreen.hsv()).toEqual hsvGreen
      (expect rgbDarkGreen.hsv()).toEqual hsvDarkGreen
      (expect rgbCyan.hsv()).toEqual hsvCyan
      (expect rgbBlue.hsv()).toEqual hsvBlue
      (expect rgbMagenta.hsv()).toEqual hsvMagenta


  describe "hsv.set()", ->

    it "sets the given values", ->

      hsv1 = C.hsv 0.1, 0.2, 0.3
      hsv2 = hsv1.set 0.4, 0.5, 0.6
      (expect hsv2).toBe hsv1 # return obj for chaining
      (expect hsv1).toEqual C.hsv 0.4, 0.5, 0.6 # values changed
