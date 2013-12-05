_ = require 'color/gamut'
lab = require 'color/lab'
rgb = require 'color/rgb'
xyz = require 'color/xyz'
white = require 'color/white'

describe 'Gamut Mapping module', ->

  labCs = rgbCs = gamut = null

  beforeEach ->

    labCs = lab white.D50
    rgbCs = rgb.space['Adobe-98']
    gamut = _ rgbCs, labCs

    @addMatchers
      toApprox: (require './matcher').toApprox

  describe 'LChMaxC() function', ->

    it 'maximizes chroma in rgb / lab space combination', ->

      # minimal luminance
      lch1 = lab.LCh 0, null, 1
      rgb1 = gamut.LChMaxC lch1
      (expect lch1).toApprox (lab.LCh 0, 0, 1), 0.00000000000001
      (expect rgb1).toEqual rgb.rgb 0, 0, 0

      # impossible luminance for current color space combination
      lch1 = lab.LCh 100, null, 1
      rgb1 = gamut.LChMaxC lch1
      (expect lch1).toEqual lab.LCh 100, null, 1
      (expect rgb1).toEqual null

      # check some valid combinations
      for L in [10..90] by 40
        for h in [0..360] by 30
          h *= Math.PI / 180
          lch1 = lab.LCh L, null, h
          rgb1 = gamut.LChMaxC lch1

          # L, h unchanged; C set to valid value
          (expect lch1.L).toBe L
          (expect lch1.h).toBe h
          (expect lch1.C).not.toBe null
          (expect 0 <= lch1.C).toBe true
          # returned rgb is valid
          (expect rgb1.isValid()).toBe true
          # rgb color equals set LCh color
          lab1 = labCs.fromXYZ rgbCs.toXYZ rgb1
          (expect lab1).toApprox lch1.Lab(), 0.0000000000001

          # check chroma is maximal
          lch1_ = lab1.LCh()
          lch1_.C += 0.0001
          rgbOut = rgbCs.fromXYZ labCs.toXYZ lch1_.Lab()
          (expect rgbOut.isValid()).toBe false

      return
