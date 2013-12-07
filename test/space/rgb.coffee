chai = require "chai"
expect = chai.expect

chai.use require "../approxAssertion"

rgbS = require '../../src/space/rgb'
rgb = require '../../src/rgb'
RGB = require '../../src/RGB'
XYZ = require '../../src/XYZ'
xyY = require '../../src/xyY'
whites = require '../../src/white'
Lab = require '../../src/Lab'
lab = require '../../src/space/lab'

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


  describe 'toXYZ()', ->

    it 'maps to XYZ correctly', ->

      expect(rgbCs1.XYZ(rgb2)).to.approx XYZ2, 0.0001
      expect(rgbCs1.XYZ(rgb3)).to.approx XYZ3, 0.0001

      expect(rgbCs2.XYZ(rgb2)).to.approx XYZ2_s, 0.0001
      expect(rgbCs2.XYZ(rgb3)).to.approx XYZ3_s, 0.0001

      expect(rgbCs1.XYZ(rgbCs1.rgb XYZ2)).to.approx XYZ2, 0.000000000000001
      expect(rgbCs1.XYZ(rgbCs1.rgb XYZ3)).to.approx XYZ3, 0.0000000000000001

      expect(rgbCs2.XYZ(rgbCs2.rgb XYZ2_s)).to.approx XYZ2_s, 0.000000000000001
      expect(rgbCs2.XYZ(rgbCs2.rgb XYZ3_s)).to.approx XYZ3_s, 0.0000000000000001


  describe 'fromXYZ()', ->

    it 'maps to XYZ correctly', ->

      expect(rgbCs1.rgb(XYZ2)).to.approx rgb2, 0.0001
      expect(rgbCs1.rgb(XYZ3)).to.approx rgb3, 0.0001

      expect(rgbCs2.rgb(XYZ2_s)).to.approx rgb2, 0.0001
      expect(rgbCs2.rgb(XYZ3_s)).to.approx rgb3, 0.0001

      expect(rgbCs1.rgb(rgbCs1.XYZ(rgb2))).to.approx rgb2, 0.000000000000001
      expect(rgbCs1.rgb(rgbCs1.XYZ(rgb3))).to.approx rgb3, 0.0000000000000001

      expect(rgbCs2.rgb(rgbCs2.XYZ(rgb2))).to.approx rgb2, 0.000000000000001
      expect(rgbCs2.rgb(rgbCs2.XYZ(rgb3))).to.approx rgb3, 0.000000000000001


  describe 'color space constructor', ->

    it 'create a new (identity) color space', ->

      cs = rgbS (xyY 1, 0), (xyY 0, 1), (xyY 0, 0), (XYZ 1, 1, 1), 1
      (expect cs.XYZ rgb 0, 0, 0).to.deep.equal XYZ 0, 0, 0
      (expect cs.XYZ rgb 1, 0, 0).to.deep.equal XYZ 1, 0, 0
      (expect cs.XYZ rgb 0, 1, 0).to.deep.equal XYZ 0, 1, 0
      (expect cs.XYZ rgb 0, 0, 1).to.deep.equal XYZ 0, 0, 1
      (expect cs.XYZ rgb 1, 1, 1).to.deep.equal XYZ 1, 1, 1
      (expect cs.XYZ rgb 0.1, 0.2, 0.5).to.deep.equal XYZ 0.1, 0.2, 0.5
      (expect cs.rgb XYZ 0.1, 0.2, 0.5).to.deep.equal rgb 0.1, 0.2, 0.5


  describe 'Predefined color spaces', ->

    it 'have the expected range in Lab colorspace', ->

      min = Lab 0, 0, 0
      max = Lab 100, 0, 0

      # rgb test colors
      rgbTest = [
        rgb 0, 0, 0
        rgb 1, 0, 0
        rgb 0, 1, 0
        rgb 0, 0, 1
        rgb 1, 0, 1
        rgb 0, 1, 1
        rgb 1, 1, 0
        rgb 1, 1, 1
      ]

      for rgbSpaceName, rgbSpace of rgbS
        for rgbCol in rgbTest
          xyzCol = rgbSpace.XYZ rgbCol
          for whiteName, white of whites
            labColor = (lab white).Lab xyzCol
            min.L = Math.min labColor.L, min.L
            min.a = Math.min labColor.a, min.a
            min.b = Math.min labColor.b, min.b
            max.L = Math.max labColor.L, max.L
            max.a = Math.max labColor.a, max.a
            max.b = Math.max labColor.b, max.b

      (expect min).to.deep.equal Lab 0, -223.4241602806217, -237.05355418094157
      (expect max).to.deep.equal Lab 100, 191.62605068015958, 158.7312579450673
