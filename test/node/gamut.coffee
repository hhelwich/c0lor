C = require "./../node_and_browser/indexToTest"


if C.BROWSER
  return

C_gamut = require.call null, "../../src/gamut"

describe "Gamut Mapping module", ->

  labCs = rgbCs = gamut = null

  beforeEach ->

    labCs = C.space.lab C.white.D50
    rgbCs = C.space.rgb["Adobe-98"]
    gamut = C_gamut rgbCs, labCs

    jasmine.addMatchers require "./../node_and_browser/matcher"


  describe "LChMaxC() function", ->

    it "maximizes chroma in rgb / lab space combination", ->

      # minimal luminance
      lch1 = C.LCh 0, null, 1
      rgb1 = gamut.LChMaxC lch1
      (expect lch1).toEqual C.LCh 0, 0, 1
      (expect rgb1).toEqual C.rgb 0, 0, 0

      # impossible luminance for current color space combination
      lch1 = C.LCh 100, null, 1
      rgb1 = gamut.LChMaxC lch1
      (expect lch1).toEqual C.LCh 100, null, 1
      (expect rgb1).toEqual null

      # check some valid combinations
      for L in [10..90] by 40
        for h in [0..360] by 30
          h *= Math.PI / 180
          lch1 = C.LCh L, null, h
          rgb1 = gamut.LChMaxC lch1

          # L, h unchanged; C set to valid value
          (expect lch1.L).toBe L
          (expect lch1.h).toBe h
          (expect lch1.C).not.toBe null
          (expect 0 <= lch1.C).toBe true
          # returned rgb is valid
          (expect rgb1.isValid()).toBe true
          # rgb color equals set LCh color
          lab1 = labCs.Lab rgbCs.XYZ rgb1
          (expect lab1).toAllBeCloseTo lch1.Lab(), 12

          # check chroma is maximal
          lch1_ = lab1.LCh()
          lch1_.C += 0.0001
          rgbOut = rgbCs.rgb labCs.XYZ lch1_.Lab()
          (expect rgbOut.isValid()).toBe false
