chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"

_ = require '../src/Lab'
LCh = require '../src/LCh'
xyz = require '../src/XYZ'
white = require '../src/white'

describe 'Lab Color', ->


  Lab1 = Lab2 = LCh1 = LCh2 = null

  beforeEach ->

    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = _ 51.8372, -57.4865, -25.7804
    Lab2 = _ 1.8066, -7.3832, -2.5470

    # reference values generated here: http://www.brucelindbloom.com/
    toRad = (a) ->
      (if a > 180 then a - 360 else a) * Math.PI / 180
    LCh1 = LCh 51.8372, 63.0026, toRad 204.1543
    LCh2 = LCh 1.8066, 7.8102, toRad 199.0330


  describe 'Lab.LCh() function', ->

    it 'maps correctly to LCh', ->

      console.log 'dddddddd'+Lab1.LCh()

      (expect Lab1.LCh()).to.approx LCh1, 0.00001
      (expect Lab2.LCh()).to.approx LCh2, 0.0001




  describe 'Lab.toString()', ->

    it 'creates informative output', ->

      (expect "#{Lab1}").to.equal "L=51.8372, a=-57.4865, b=-25.7804"

