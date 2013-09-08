_ = require 'color/rgb'
xyz = require 'color/xyz'
XYZ = xyz.XYZ
xyY = xyz.xyY
whites = require 'color/whites'
lab = require 'color/lab'

describe 'Rgb Colorspace module', ->

  XYZ2 = XYZ3 = XYZ2_s = XYZ3_s = null
  rgb1 = rgb2 = rgb3 = rgb4 = null
  RGB1 = RGB2 = RGB3 = RGB4 = null
  rgbCs1 = rgbCs2 = null

  beforeEach ->

    rgb1 = _.rgb 0, undefined, 0
    rgb2 = _.rgb 1, 1, 1
    rgb3 = _.rgb 0.5, 0.3, 0.2
    rgb4 = _.rgb 1.4, 1.00001, -0.1

    RGB1 = _.RGB 0, undefined, 0
    RGB2 = _.RGB 255, 255, 255
    RGB3 = _.RGB 128, 77, 51
    RGB4 = _.RGB undefined, 255, undefined

    rgbCs1 = _.space['Adobe-98']
    # Adobe-98 / http://www.brucelindbloom.com
    XYZ2 = XYZ 0.95047, 1       , 1.08883
    XYZ3 = XYZ 0.1441 , 0.111282, 0.039618

    rgbCs2 = _.space.sRGB
    # sRGB / http://www.brucelindbloom.com
    XYZ2_s = XYZ 0.95047 , 1       , 1.08883
    XYZ3_s = XYZ 0.120444, 0.100287, 0.044327

    @addMatchers
      toApprox: (require './matcher').toApprox


  describe 'rgb.RGB(), RGB.rgb()', ->

    it 'rgb.RGB() maps correctly to 3 bit rgb', ->

      expect(rgb1.RGB()).toEqual RGB1
      expect(rgb2.RGB()).toEqual RGB2
      expect(rgb3.RGB()).toEqual RGB3
      expect(rgb4.RGB()).toEqual RGB4

    it 'RGB.rgb() maps correctly from 3 bit rgb', ->

      expect(RGB1.rgb()).toEqual rgb1
      expect(RGB2.rgb()).toEqual rgb2
      expect(RGB3.rgb()).toApprox rgb3 , 0.01
      expect(RGB4.rgb()).toEqual _.rgb undefined, 1, undefined

    it 'RGB -> rgb -> RGB = Id', ->

      expect(RGB1.rgb().RGB()).toEqual RGB1
      expect(RGB2.rgb().RGB()).toEqual RGB2
      expect(RGB3.rgb().RGB()).toEqual RGB3
      expect(RGB4.rgb().RGB()).toEqual RGB4


  describe 'RGB.hex()', ->

    it 'creates hex string', ->

      expect(RGB1.hex()).not.toBeDefined()
      expect(RGB2.hex()).toBe 'FFFFFF'
      expect(RGB3.hex()).toBe '804D33'
      expect(RGB4.hex()).not.toBeDefined()

    it 'parses hex string', ->

      expect(RGB1.hex('FFFFFF')).toEqual RGB2
      expect(_.RGB().hex('804D33')).toEqual RGB3

  describe 'RGB.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(RGB1.isDefined()).toBe false
      expect(RGB2.isDefined()).toBe true
      expect(RGB3.isDefined()).toBe true
      expect(RGB4.isDefined()).toBe false

  describe 'rgb.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(rgb1.isDefined()).toBe false
      expect(rgb2.isDefined()).toBe true
      expect(rgb3.isDefined()).toBe true
      expect(rgb4.isDefined()).toBe true

  describe 'toXYZ()', ->

    it 'maps to XYZ correctly', ->

      expect(rgbCs1.toXYZ(rgb2)).toApprox XYZ2, 0.0001
      expect(rgbCs1.toXYZ(rgb3)).toApprox XYZ3, 0.0001

      expect(rgbCs2.toXYZ(rgb2)).toApprox XYZ2_s, 0.0001
      expect(rgbCs2.toXYZ(rgb3)).toApprox XYZ3_s, 0.0001

      expect(rgbCs1.toXYZ(rgbCs1.fromXYZ XYZ2)).toApprox XYZ2, 0.000000000000001
      expect(rgbCs1.toXYZ(rgbCs1.fromXYZ XYZ3)).toApprox XYZ3, 0.0000000000000001

      expect(rgbCs2.toXYZ(rgbCs2.fromXYZ XYZ2_s)).toApprox XYZ2_s, 0.000000000000001
      expect(rgbCs2.toXYZ(rgbCs2.fromXYZ XYZ3_s)).toApprox XYZ3_s, 0.0000000000000001


  describe 'fromXYZ()', ->

    it 'maps to XYZ correctly', ->

      expect(rgbCs1.fromXYZ(XYZ2)).toApprox rgb2, 0.0001
      expect(rgbCs1.fromXYZ(XYZ3)).toApprox rgb3, 0.0001

      expect(rgbCs2.fromXYZ(XYZ2_s)).toApprox rgb2, 0.0001
      expect(rgbCs2.fromXYZ(XYZ3_s)).toApprox rgb3, 0.0001

      expect(rgbCs1.fromXYZ(rgbCs1.toXYZ(rgb2))).toApprox rgb2, 0.000000000000001
      expect(rgbCs1.fromXYZ(rgbCs1.toXYZ(rgb3))).toApprox rgb3, 0.0000000000000001

      expect(rgbCs2.fromXYZ(rgbCs2.toXYZ(rgb2))).toApprox rgb2, 0.000000000000001
      expect(rgbCs2.fromXYZ(rgbCs2.toXYZ(rgb3))).toApprox rgb3, 0.000000000000001


  describe 'color space constructor', ->

    it 'create a new (identity) color space', ->

      cs = _ (xyY 1, 0), (xyY 0, 1), (xyY 0, 0), (xyY 1/3, 1/3), 1
      (expect cs.toXYZ _.rgb 0, 0, 0).toEqual XYZ 0, 0, 0
      (expect cs.toXYZ _.rgb 1, 0, 0).toEqual XYZ 1, 0, 0
      (expect cs.toXYZ _.rgb 0, 1, 0).toEqual XYZ 0, 1, 0
      (expect cs.toXYZ _.rgb 0, 0, 1).toApprox (XYZ 0, 0, 1), 0.000000000000001
      (expect cs.toXYZ _.rgb 1, 1, 1).toApprox (XYZ 1, 1, 1), 0.000000000000001
      (expect cs.toXYZ _.rgb 0.1, 0.2, 0.5).toApprox (XYZ 0.1, 0.2, 0.5), 0.000000000000001
      (expect cs.fromXYZ XYZ 0.1, 0.2, 0.5).toApprox (_.rgb 0.1, 0.2, 0.5), 0.000000000000001


  describe 'Predefined color spaces', ->

    it 'have the expected range in Lab colorspace', ->

      min = lab.Lab 0, 0, 0
      max = lab.Lab 100, 0, 0

      # rgb test colors
      rgbTest = [
        _.rgb 1, 0, 0
        _.rgb 0, 1, 0
        _.rgb 0, 0, 1
      ]

      for rgbSpaceName, rgbSpace of _.space
        for rgbCol in rgbTest
          xyzCol = rgbSpace.toXYZ rgbCol
          for whiteName, white of whites
            labColor = (lab white).fromXYZ xyzCol
            min.L = Math.min labColor.L, min.L
            min.a = Math.min labColor.a, min.a
            min.b = Math.min labColor.b, min.b
            max.L = Math.max labColor.L, max.L
            max.a = Math.max labColor.a, max.a
            max.b = Math.max labColor.b, max.b

      (expect min).toEqual lab.Lab 0, -223.4241602806217, -237.05355418094157
      (expect max).toEqual lab.Lab 100, 191.62605068015958, 146.1172562433079