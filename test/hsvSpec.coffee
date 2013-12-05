chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"

require '../src/hsv'
_ = require '../src/rgb'


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



  describe 'hsv constructor', ->

    it 'stores given args', ->
      (expect hsvBrown.h).to.equal 24/360
      (expect hsvBrown.s).to.equal .75
      (expect hsvBrown.v).to.equal .36


  describe 'hsv.rgb()', ->

    it 'maps correctly to rgb', ->

      (expect hsvBlack.rgb()).to.deep.equal rgbBlack
      (expect hsvRed.rgb()).to.deep.equal rgbRed
      (expect hsvYellow.rgb()).to.deep.equal rgbYellow
      (expect hsvBrown.rgb()).to.deep.equal rgbBrown
      (expect hsvWhite.rgb()).to.deep.equal rgbWhite
      (expect hsvGreen.rgb()).to.deep.equal rgbGreen
      (expect hsvDarkGreen.rgb()).to.deep.equal rgbDarkGreen
      (expect hsvCyan.rgb()).to.deep.equal rgbCyan
      (expect hsvBlue.rgb()).to.deep.equal rgbBlue
      (expect hsvMagenta.rgb()).to.deep.equal rgbMagenta


  describe 'rgb.hsv()', ->

    it 'maps correctly to hsv', ->

      (expect rgbBlack.hsv()).to.deep.equal hsvBlack
      (expect rgbRed.hsv()).to.deep.equal hsvRed
      (expect rgbYellow.hsv()).to.deep.equal hsvYellow
      (expect rgbBrown.hsv()).to.approx hsvBrown, 0.000000000000001
      (expect rgbWhite.hsv()).to.deep.equal hsvWhite
      (expect rgbGreen.hsv()).to.deep.equal hsvGreen
      (expect rgbDarkGreen.hsv()).to.deep.equal hsvDarkGreen
      (expect rgbCyan.hsv()).to.deep.equal hsvCyan
      (expect rgbBlue.hsv()).to.deep.equal hsvBlue
      (expect rgbMagenta.hsv()).to.deep.equal hsvMagenta


  describe 'hsv.set()', ->

    it 'sets the given values', ->

      hsv = _.hsv 0.1, 0.2, 0.3
      hsv2 = hsv.set 0.4, 0.5, 0.6
      (expect hsv2).to.equal hsv # return obj for chaining
      (expect hsv).to.deep.equal _.hsv 0.4, 0.5, 0.6 # values changed
