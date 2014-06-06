#{info, warn, fail} = require "ut1l/log"
pow = Math.pow
rgbM = require "./rgb"
xyzM = require "./XYZ"

###
solveCubic = (a0, a, b, c) ->    # see: http://de.wikipedia.org/wiki/Cardanische_Formeln
  # normalize
  a /= a0
  b /= a0
  c /= a0
  # substitute x=z-a/3 => z^3 + p*z + q = 0
  p = b - a*a / 3
  q = 2*(pow a, 3)/27 - a*b/3 + c
  # calculate dicriminat
  D = (pow p, 3)/27 + q*q/4
  if D > 0
    D = Math.sqrt D
    ru = -q/2 + D
    rv = -q/2 - D

    if ru < 0
      ru = -(pow -ru, 1/3)
    else
      ru = pow ru, 1/3

    if rv < 0
      rv = -(pow -rv, 1/3)
    else
      rv = pow rv, 1/3

    X = ru + rv

    X -= a/3
  else if D < 0
    ppp = (pow p,3) / 27
    ppp = Math.abs ppp
    ppp = 2 * Math.pow ppp , 1/2
    argu = -q/ppp
    phi = Math.acos argu
    phi = phi/3
    # alert(phi);
    pp = Math.abs p/3
    pp = 2*pow pp, 1/2
    X = pp * Math.cos phi

    X -= a/3
  else
    fail "D = 0 is not implemented"



  #console.log "solution x = "+X
  #console.log "test: x^3 + a*x^2 + b*x + c = " + ((pow X, 3) + a*X*X + b*X + c)

  info "expect to be 0: " + (X*X*X + a*X*X + b*X + c)
  X


checkSolution = (C, a, b, fy, rgb, nbase, mr, mg, mb) ->
  if C >= 0
    X = pow fy + a * C, 3
    Z = pow fy + b * C, 3
    if not rgb.r?
      rgb.r = nbase[0] * X + nbase[2] * Z + mr
    else info "expected #{rgb.r} == "+ (nbase[0] * X + nbase[2] * Z + mr)
    if not rgb.g?
      rgb.g = nbase[3] * X + nbase[5] * Z + mg
    else info "expected #{rgb.g} == "+ (nbase[3] * X + nbase[5] * Z + mg)
    if not rgb.b?
      rgb.b = nbase[6] * X + nbase[8] * Z + mb
    else info "expected #{rgb.b} == "+ (nbase[6] * X + nbase[8] * Z + mb )
    if rgb.isValid()
      return true
  rgb.r = rgb.g = rgb.b = null
  return false

gammaInv = (rgb, rgbCs) ->
  rgb.r = rgbCs.gammaInv rgb.r
  rgb.g = rgbCs.gammaInv rgb.g
  rgb.b = rgbCs.gammaInv rgb.b
  rgb
###

class GamutMapping

  constructor: (@rgbCs, @labCs) ->
    ###
    rgbCs.init() # make sure rgb base is initialized
    # store rgb inverse base normalised with lab white point
    a = rgbCs.baseInv
    @nbase = [
      a[0] * @labCs.white.X, a[1] * @labCs.white.Y, a[2] * @labCs.white.Z
      a[3] * @labCs.white.X, a[4] * @labCs.white.Y, a[5] * @labCs.white.Z
      a[6] * @labCs.white.X, a[7] * @labCs.white.Y, a[8] * @labCs.white.Z
    ]
  ###


  LChMaxC: (LCh, rgb = rgbM()) ->
    # naive binary search implementation
    # TODO: manage correct direct calculation
    LCh.C = 0
    step = 110
    validC = null
    for n in [0..50] by 1
      lab = LCh.Lab lab
      xyz = @labCs.XYZ lab, xyz
      @rgbCs.rgb xyz, rgb
      if rgb.isValid()
        validC = LCh.C
        LCh.C += step
      else
        LCh.C -= step
      step /= 2
    LCh.C = validC
    if validC? # solution found
      @rgbCs.rgb (@labCs.XYZ (LCh.Lab lab), xyz), rgb
    else
      null



###

  LChMaxCExp: (LCh, rgb = rgbM.rgb()) ->


    xyz = xyzM.XYZ() # temporary variable

    # valid (r, 0, 0) with given luminance possible?
    r = (pow 16 + LCh.L, 3) / (@labCs.white.Y * 1560896 * @rgbCs.base[3]) # 1560896 = 116^3
    if 0 <= r <= 1 # valid rgb element ?
      r = @rgbCs.gammaInv r # linear rgb -> nonlinear rgb
      _rgb = rgbM.rgb r, 0, 0
      # map to LCh to get hue
      @rgbCs.toXYZ _rgb, xyz
      lab = @labCs.fromXYZ xyz, lab
      lch = lab.LCh lch


    # valid (0, g, 0) with given luminance possible?
    g = (pow 16 + LCh.L, 3) / (@labCs.white.Y * 1560896 * @rgbCs.base[4]) # 1560896 = 116^3
    if 0 <= g <= 1 # valid rgb element ?
      g = @rgbCs.gammaInv g # linear rgb -> nonlinear rgb
      _rgb = rgbM.rgb 0, g, 0
      # map to LCh to get hue
      @rgbCs.toXYZ _rgb, xyz
      lab = @labCs.fromXYZ xyz, lab
      lch = lab.LCh lch



    # valid (0, 0, b) with given luminance possible?
    b = (pow 16 + LCh.L, 3) / (@labCs.white.Y * 1560896 * @rgbCs.base[5]) # 1560896 = 116^3
    if 0 <= b <= 1 # valid rgb element ?
      b = @rgbCs.gammaInv b # linear rgb -> nonlinear rgb
      _rgb = rgbM.rgb 0, 0, b
      # map to LCh to get hue
      @rgbCs.toXYZ _rgb, xyz
      lab = @labCs.fromXYZ xyz, lab
      lch = lab.LCh lch
    else # valid (r, 0, 1) with given luminance possible?
      r = ((pow (16 + LCh.L) / 116, 3) * @labCs.white.Y - @rgbCs.base[5]) / @rgbCs.base[3]

    #lchTest = (@labCs.fromXYZ @rgbCs.toXYZ rgbTest).LCh()

    #lchTest = (@labCs.fromXYZ @rgbCs.toXYZ rgbTest.set 0, 1, 0).LCh()

    #lchTest = (@labCs.fromXYZ @rgbCs.toXYZ rgbTest.set 0, 0, 1).LCh()

    # L and h fixed. maximum C is wanted so that the LCh color is a valid in current rgb color space
    # calculate a,b for chroma 1. Now we need to find the factor for a and b (the chroma)
    a = Math.cos LCh.h
    b = Math.sin LCh.h
    # to XYZ (for now ignore linear case)
    a /= 500
    b /= -200
    # calculate some constant values
    fy = (LCh.L + 16) / 116
    Y = pow(fy, 3)
    mr =  @nbase[1] * Y # maximum red value for X / Z params
    mg =  @nbase[4] * Y # maximum green value for X / Z params
    mb =  @nbase[7] * Y # maximum blue value for X / Z params
    #X = pow(fy + a, 3)
    #Z = pow(fy + b, 3)
    # to linear rgb (maximum value 1)


    #mr = a0 * X + a2 * Z #red
    #mg = a3 * X + a5 * Z #green
    #mb = a6 * X + a8 * Z #blue


    bxr = @nbase[0]
    bzr = @nbase[2]
    bxg = @nbase[3]
    bzg = @nbase[5]
    bxb = @nbase[6]
    bzb = @nbase[8]

    a2 = a*a
    a3 = a2*a
    b2 = b*b
    b3 = b2*b
    fy_3 = 3*fy
    fy2_3 = fy_3*fy
    fy3 = pow fy, 3

    lr = solveCubic bxr*a3 + bzr*b3, fy_3*(bxr*a2 + bzr*b2), fy2_3*(bxr*a + bzr*b), fy3*(bxr+bzr)+mr-1

    rgb.r = 1
    rgb.g = rgb.b = null
    if (checkSolution lr, a, b, fy, rgb, @nbase, mr, mg, mb)
      return gammaInv rgb, @rgbCs

    lg = solveCubic bxg*a3 + bzg*b3, fy_3*(bxg*a2 + bzg*b2), fy2_3*(bxg*a + bzg*b), fy3*(bxg + bzg) + mg-1

    rgb.g = 1
    if (checkSolution lg, a, b, fy, rgb, @nbase, mr, mg, mb)
      return gammaInv rgb, @rgbCs



    lb = solveCubic bxb*a3 + bzb*b3, fy_3*(bxb*a2 + bzb*b2), fy2_3*(bxb*a + bzb*b), fy3*(bxb+bzb)+mb-1
    rgb.b = 1
    if (checkSolution lb, a, b, fy, rgb, @nbase, mr, mg, mb)
      return gammaInv rgb, @rgbCs


    lr0 = solveCubic bxr*a3 + bzr*b3, fy_3*(bxr*a2 + bzr*b), fy2_3*(bxr*a + bzr*b), fy3*(bxr+bzr)+mr

    rgb.r = 0
    if (checkSolution lr0, a, b, fy, rgb, @nbase, mr, mg, mb)
      return gammaInv rgb, @rgbCs

    lg0 = solveCubic bxg*a3 + bzg*b3, fy_3*(bxg*a2 + bzg*b), fy2_3*(bxg*a + bzg*b), fy3*(bxg+bzg)+mg

    rgb.g = 0
    if (checkSolution lg0, a, b, fy, rgb, @nbase, mr, mg, mb)
      return gammaInv rgb, @rgbCs


    lb0 = solveCubic bxb*a3 + bzb*b3, fy_3*(bxb*a2 + bzb*b2), fy2_3*(bxb*a + bzb*b), fy3*(bxb+bzb)+mb
    rgb.b = 0
    if (checkSolution lb0, a, b, fy, rgb, @nbase, mr, mg, mb)
      return gammaInv rgb, @rgbCs





###



module.exports = (rgbCs, labCs) ->
  new GamutMapping rgbCs, labCs
