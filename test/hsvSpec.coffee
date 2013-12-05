require 'color/hsv'
_ = require 'color/rgb'


describe 'Hsv Colorspace module', ->

  hsvBlack = hsvRed = hsvYellow = hsvBrown = hsvWhite = hsvGreen = hsvDarkGreen = hsvCyan = hsvBlue = hsvMagenta = null
  rgbBlack = rgbRed = rgbYellow = rgbBrown = rgbWhite = rgbGreen = rgbDarkGreen = rgbCyan = rgbBlue = rgbMagenta = null

  beforeEach ->

    hsvBlack = _.hsv 0, 0, 0 # any value for h & s
    hsvRed = _.hsv 0, 1, 1
    hsvYellow = _.hsv 60/360, 1, 1
    hsvBrown = _.hsv 24/360, .75, .36
    hsvWhite = _.hsv 0, 0, 1 # any value for h
    hsvGreen = _.hsv 120/360, 1, 1
    hsvDarkGreen = _.hsv 120/360, 1, 0.5
    hsvCyan = _.hsv 180/360, 1, 1
    hsvBlue = _.hsv 240/360, 1, 1
    hsvMagenta = _.hsv 300/360, 1, 1

    rgbBlack = _.rgb 0, 0, 0
    rgbRed = _.rgb 1, 0, 0
    rgbYellow = _.rgb 1, 1, 0
    rgbBrown = _.rgb .36, .198, .09
    rgbWhite = _.rgb 1, 1, 1
    rgbGreen = _.rgb 0, 1, 0
    rgbDarkGreen = _.rgb 0, .5, 0
    rgbCyan = _.rgb 0, 1, 1
    rgbBlue = _.rgb 0, 0, 1
    rgbMagenta = _.rgb 1, 0, 1

    @addMatchers
      toApprox: (require './matcher').toApprox


  describe 'hsv constructor', ->

    it 'stores given args', ->
      (expect hsvBrown.h).toBe 24/360
      (expect hsvBrown.s).toBe .75
      (expect hsvBrown.v).toBe .36


  describe 'hsv.rgb()', ->

    it 'maps correctly to rgb', ->

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


  describe 'rgb.hsv()', ->

    it 'maps correctly to hsv', ->

      (expect rgbBlack.hsv()).toEqual hsvBlack
      (expect rgbRed.hsv()).toEqual hsvRed
      (expect rgbYellow.hsv()).toEqual hsvYellow
      (expect rgbBrown.hsv()).toApprox hsvBrown, 0.000000000000001
      (expect rgbWhite.hsv()).toEqual hsvWhite
      (expect rgbGreen.hsv()).toEqual hsvGreen
      (expect rgbDarkGreen.hsv()).toEqual hsvDarkGreen
      (expect rgbCyan.hsv()).toEqual hsvCyan
      (expect rgbBlue.hsv()).toEqual hsvBlue
      (expect rgbMagenta.hsv()).toEqual hsvMagenta


  describe 'hsv.set()', ->

    it 'sets the given values', ->

      hsv = _.hsv 0.1, 0.2, 0.3
      hsv2 = hsv.set 0.4, 0.5, 0.6
      (expect hsv2).toBe hsv # return obj for chaining
      (expect hsv).toEqual _.hsv 0.4, 0.5, 0.6 # values changed
