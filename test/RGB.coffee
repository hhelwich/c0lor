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

describe 'RGB 24 bit color', ->

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


  describe 'RGB.rgb()', ->


    it 'RGB.rgb() maps correctly from 3 bit rgb', ->

      expect(RGB1.rgb()).to.deep.equal rgb1
      expect(RGB2.rgb()).to.deep.equal rgb2
      expect(RGB3.rgb()).to.approx rgb3 , 0.01
      expect(RGB4.rgb()).to.deep.equal rgb undefined, 1, undefined

    it 'RGB -> rgb -> RGB = Id', ->

      expect(RGB1.rgb().RGB()).to.deep.equal RGB1
      expect(RGB2.rgb().RGB()).to.deep.equal RGB2
      expect(RGB3.rgb().RGB()).to.deep.equal RGB3
      expect(RGB4.rgb().RGB()).to.deep.equal RGB4


  describe 'RGB.hex()', ->

    it 'creates hex string', ->

      expect(RGB1.hex()).not.to.be.defined
      expect(RGB2.hex()).to.equal 'FFFFFF'
      expect(RGB3.hex()).to.equal '804D33'
      expect(RGB4.hex()).not.to.be.defined

    it 'parses hex string', ->

      expect(RGB1.hex('FFFFFF')).to.deep.equal RGB2
      expect(RGB().hex('804D33')).to.deep.equal RGB3




  describe 'RGB.toString()', ->

    it 'creates informative output', ->

      (expect "#{RGB3}").to.equal "R=128, G=77, B=51"


  describe 'RGB.isDefined()', ->

    it 'is true if all components are defined', ->

      expect(RGB1.isDefined()).to.equal false
      expect(RGB2.isDefined()).to.equal true
      expect(RGB3.isDefined()).to.equal true
      expect(RGB4.isDefined()).to.equal false


