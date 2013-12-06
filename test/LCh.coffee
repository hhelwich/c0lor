chai = require "chai"
expect = chai.expect

chai.use require "./approxAssertion"

_ = require '../src/LCh'
Lab = require '../src/Lab'
xyz = require '../src/XYZ'
white = require '../src/white'

describe 'Lab Colorspace module', ->


  Lab1 = Lab2 = LCh1 = LCh2 = null

  beforeEach ->

    # same color in Lab color space with D50 reference white (http://www.brucelindbloom.com/)
    Lab1 = Lab 51.8372, -57.4865, -25.7804
    Lab2 = Lab 1.8066, -7.3832, -2.5470

    # reference values generated here: http://www.brucelindbloom.com/
    toRad = (a) ->
      (if a > 180 then a - 360 else a) * Math.PI / 180
    LCh1 = _ 51.8372, 63.0026, toRad 204.1543
    LCh2 = _ 1.8066, 7.8102, toRad 199.0330




  describe 'LCh.Lab() function', ->

    it 'maps correctly to Lab', ->

      (expect LCh1.Lab()).to.approx Lab1, 0.0001
      (expect LCh2.Lab()).to.approx Lab2, 0.0001


  describe 'LCh.toString()', ->

    it 'creates informative output', ->

      (expect "#{_ 51.8372, 63.0026, -2.7}").to.equal "L=51.8372, C=63.0026, h=-2.7"
