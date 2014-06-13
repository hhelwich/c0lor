module.exports =

  # like toBeCloseTo of jasmine but works on objects and verifies all number properties
  toAllBeCloseTo: (util, customEqualityTesters) ->
    compare: (actual, expected, precision) ->
      if precision != 0
        precision = precision || 2
      precision = (Math.pow 10, -precision) / 2
      for own key, value of actual
        if typeof value == "number"
          valueExpected = expected[key]
          if typeof valueExpected != "number"
            return pass: false
          delta = Math.abs value - valueExpected
          if delta >= precision
            return pass: false
      pass: true