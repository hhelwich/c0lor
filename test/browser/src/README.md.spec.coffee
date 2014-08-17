C = require "./indexToTest"

snippets = require "./README.md"

describe "README.md", ->

  beforeEach ->
    jasmine.addMatchers require "./matcher"


  describe "snippet 3", ->

    it "creates expected colors", ->
      # run snippet
      _ = snippets[3] C: C
      # verify
      (expect _.cyan_rgb).toEqual
        r: 0
        g: 1
        b: 1
      (expect _.red_RGB).toEqual
        R: 255
        G: 0
        B: 0
      (expect _.yellow_RGB).toEqual
        R: 255
        G: 255
        B: 0

      (expect _.magenta_hsv).toEqual
        h: 0.8
        s: 1
        v: 1

      (expect _.green_XYZ).toEqual
        X: 0.4
        Y: 0.7
        Z: 0.2
      (expect _.orange_xyY).toEqual
        x: 0.5
        y: 0.4
        Y: 0.3

      (expect _.purple_Lab).toEqual
        L: 31
        a: 24
        b: -22
      (expect _.blue_LCh).toEqual
        L: 30
        C: 56
        h: -1


  describe "snippet 4", ->

    it "converts colors correctly", ->

      # run snippets 3, 4
      _ = snippets[4] snippets[3] C: C

      # verify
      (expect _.cyan_RGB).toEqual
        R: 0
        G: 255
        B: 255
      (expect _.red_hexStr).toBe "FF0000"
      (expect _.yellow_rgb).toEqual
        r: 1
        g: 1
        b: 0

      (expect _.magenta_rgb).toEqual
        r: 0.8000000000000007
        g: 0
        b: 1
      (expect _.yellow_hsv).toEqual
        h: 0.16666666666666666
        s: 1
        v: 1

      (expect _.green_xyY).toEqual
        x: 0.3076923076923077
        y: 0.5384615384615384
        Y: 0.7
      (expect _.orange_XYZ).toEqual
        X: 0.37499999999999994
        Y: 0.3
        Z: 0.07499999999999997

      (expect _.purple_LCh).toEqual
        L: 31
        C: 32.55764119219941
        h: -0.7419472680059175
      (expect _.blue_Lab).toAllBeCloseTo
        L: 30
        a: 30.256929128615827
        b: -47.1223751492422
      , 13


  describe "snippet 5", ->

    it "converts color correctly", ->

      rgbColor = C.rgb()
      # run snippet
      _ = snippets[5]
        rgbColor: rgbColor
        hsvColor: C.hsv 0.8, 1, 1

      # verify
      (expect _.rgbColor).toBe rgbColor # in place?
      (expect _.rgbColor).toEqual
        r: 0.8000000000000007
        g: 0
        b: 1
