

module.exports = (chai, utils) ->

  Assertion = chai.Assertion

  Assertion.addMethod "approx", (expected, delta = 0) ->
    if (typeof expected == 'number')
      @assert (Math.abs @_obj - expected) <= delta,
        "expected value #{@_obj} to be close to #{expected}",
        "expected value #{@_obj} not to be close to #{expected}"
    else
      for key, numb of expected
        @assert @_obj[key]?,
          "expected value for key #{key} to be defined",
          "expected value for key #{key} to be undefined"
        if typeof numb == "number"
          @assert (Math.abs @_obj[key] - numb) <= delta,
            "expected value #{@_obj[key]} for key #{key} to be close to #{numb}",
            "expected value #{@_obj[key]} for key #{key} not to be close to #{numb}"

    return


