_ = require 'color/gamut'
lab = require 'color/lab'
rgb = require 'color/rgb'
xyz = require 'color/xyz'
white = require 'color/whites'

describe 'Gamut Mapping module', ->

  labCs = rgbCs = gamut = null

  beforeEach ->

    labCs = lab white.D65
    rgbCs = rgb.space['Adobe-98']
    gamut = _ rgbCs, labCs

    @addMatchers
      toApprox: (require './matcher').toApprox


  describe 'LChMaxC() function', ->

    it 'maps correctly to XYZ', ->

      L = 50
      for h in [-90..180] by 90
        console.log "winkel: #{h}"
        h *= Math.PI / 180
        lch1 = lab.LCh L, null, h
        rgb1 = gamut.LChMaxC lch1


        console.log "rgb solution: #{rgb1.RGB().hex()}"

        #in place
        # L, h unchanged
        (expect lch1.L).toBe L
        (expect lch1.h).toBe h
        # rgb valid
        (expect rgb1.isValid()).toBe true
        #valid and mx rgb
        lch1_ = (labCs.fromXYZ rgbCs.toXYZ rgb1).LCh()

        (expect 0 <= lch1_.C).toBe true

        (expect lab.LCh lch1_.L, null, lch1_.h).toApprox lch1, 0.0000000000001

        # check chroma is maximal
        lchOut = lab.LCh lch1_.L, lch1_.C+0.0001, lch1_.h
        rgbOut = rgbCs.fromXYZ labCs.toXYZ lchOut.Lab()
        (expect rgbOut.isValid()).toBe false


