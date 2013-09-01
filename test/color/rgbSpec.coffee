_ = require 'color/rgb'
XYZ = (require 'color/xyz').XYZ
white = require 'color/whites'

describe 'Rgb Colorspace module', ->

  XYZ2 = XYZ3 = null
  rgb1 = rgb2 = rgb3 = rgb4 = null
  RGB1 = RGB2 = RGB3 = RGB4 = null
  rgbCs1 = null

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

      expect(rgbCs1.toXYZ(rgbCs1.fromXYZ XYZ2)).toApprox XYZ2, 0.000000000000001
      expect(rgbCs1.toXYZ(rgbCs1.fromXYZ XYZ3)).toApprox XYZ3, 0.0000000000000001


  describe 'fromXYZ()', ->

    it 'maps to XYZ correctly', ->

      expect(rgbCs1.fromXYZ(XYZ2)).toApprox rgb2, 0.0001
      expect(rgbCs1.fromXYZ(XYZ3)).toApprox rgb3, 0.0001

      expect(rgbCs1.fromXYZ(rgbCs1.toXYZ(rgb2))).toApprox rgb2, 0.000000000000001
      expect(rgbCs1.fromXYZ(rgbCs1.toXYZ(rgb3))).toApprox rgb3, 0.0000000000000001

