chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"

rgbS = require '../src/space/rgb'
rgb = require '../src/rgb'
RGB = require '../src/RGB'
XYZ = require '../src/XYZ'
xyY = require '../src/xyY'
whites = require '../src/white'
Lab = require '../src/Lab'
lab = require '../src/space/lab'

describe 'Rgb Colorspace module', ->

  XYZ2 = XYZ3 = XYZ2_s = XYZ3_s = null
  rgb1 = rgb2 = rgb3 = rgb4 = null
  RGB1 = RGB2 = RGB3 = RGB4 = null
  rgbCs1 = rgbCs2 = null

  beforeEach ->

    rgb1 = rgb 0, undefined, 0
    rgb2 = rgb 1, 1, 1
    rgb3 = rgb 0.5, 0.3, 0.2
    rgb4 = rgb 1.4, 1.00001, -0.1

    RGB1 = RGB 0, undefined, 0
    RGB2 = RGB 255, 255, 255
    RGB3 = RGB 128, 77, 51
    RGB4 = RGB undefined, 255, undefined

    rgbCs1 = rgbS['Adobe-98']
    # Adobe-98 / http://www.brucelindbloom.com
    XYZ2 = XYZ 0.95047, 1       , 1.08883
    XYZ3 = XYZ 0.1441 , 0.111282, 0.039618

    rgbCs2 = rgbS.sRGB
    # sRGB / http://www.brucelindbloom.com
    XYZ2_s = XYZ 0.95047 , 1       , 1.08883
    XYZ3_s = XYZ 0.120444, 0.100287, 0.044327


  describe 'rgb.RGB(), RGB.rgb()', ->

    it 'rgb.RGB() maps correctly to 3 bit rgb', ->

      expect(rgb1.RGB()).to.deep.equal RGB1
      expect(rgb2.RGB()).to.deep.equal RGB2
      expect(rgb3.RGB()).to.deep.equal RGB3
      expect(rgb4.RGB()).to.deep.equal RGB4




  describe 'rgb.toString()', ->

    it 'creates informative output', ->

      (expect "#{rgb3}").to.equal "r=0.5, g=0.3, b=0.2"





  describe 'rgb.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(rgb1.isDefined()).to.equal false
      expect(rgb2.isDefined()).to.equal true
      expect(rgb3.isDefined()).to.equal true
      expect(rgb4.isDefined()).to.equal true

  describe 'rgb.isValid()', ->

    it 'is true if all components are defined and between 0..1', ->

      # ok
      (expect (rgb 0, 0, 0).isValid()).to.equal true
      (expect (rgb -0, -0, -0).isValid()).to.equal true
      (expect (rgb 1, 1, 1).isValid()).to.equal true
      (expect (rgb 0.1, 0.2, 0.3).isValid()).to.equal true
      # not ok
      (expect (rgb 0, -0.001, 0).isValid()).to.equal false
      (expect (rgb 0, 0, 1.0001).isValid()).to.equal false
      (expect (rgb undefined, 0, 1).isValid()).to.equal false
      (expect (rgb 0, null, 0).isValid()).to.equal false
      (expect (rgb 0, Number.POSITIVE_INFINITY, 0).isValid()).to.equal false
      (expect (rgb 0, Number.NaN, 0).isValid()).to.equal false
      (expect (rgb 0, Number.NEGATIVE_INFINITY, 0).isValid()).to.equal false

  describe 'rgb.set()', ->

    it 'sets the given values', ->

      rgb_ = rgb 0.1, 0.2, 0.3
      rgb2 = rgb_.set 0.4, 0.5, 0.6
      (expect rgb2).to.equal rgb_ # return obj for chaining
      (expect rgb_).to.deep.equal rgb 0.4, 0.5, 0.6 # values changed

