C = require "./indexToTest"


describe "Lab Color", ->

  Lab1 = Lab2 = LCh1 = LCh2 = null

  beforeEach ->

    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = C.Lab 51.8372, -57.4865, -25.7804
    Lab2 = C.Lab 1.8066, -7.3832, -2.5470

    # reference values generated here: http://www.brucelindbloom.com/
    toRad = (a) ->
      (if a > 180 then a - 360 else a) * Math.PI / 180
    LCh1 = C.LCh 51.8372, 63.0026, toRad 204.1543
    LCh2 = C.LCh 1.8066, 7.8102, toRad 199.0330

    jasmine.addMatchers require "./matcher"


  describe "Lab.LCh() function", ->

    it "maps correctly to LCh", ->

      (expect Lab1.LCh()).toAllBeCloseTo LCh1, 4
      (expect Lab2.LCh()).toAllBeCloseTo LCh2, 4


  describe "Lab.toString()", ->

    it "creates informative output", ->

      (expect "#{Lab1}").toBe "L=51.8372, a=-57.4865, b=-25.7804"
