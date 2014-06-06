// c0lor v0.1.0 | (c) 2013-2014 Hendrik Helwich | MIT License
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var O, cos, lchPrototype, sin;

O = require("ut1l/create/object");

cos = Math.cos;

sin = Math.sin;

lchPrototype = {
  Lab: function(T) {
    if (T == null) {
      T = require("./Lab")();
    }
    T.L = this.L;
    T.a = this.C * cos(this.h);
    T.b = this.C * sin(this.h);
    return T;
  },
  toString: function() {
    return "L=" + this.L + ", C=" + this.C + ", h=" + this.h;
  }
};

module.exports = O((function(L, C, h) {
  this.L = L;
  this.C = C;
  this.h = h;
}), lchPrototype);

},{"./Lab":2,"ut1l/create/object":14}],2:[function(require,module,exports){
var O, atan2, labPrototype, sqrt;

O = require("ut1l/create/object");

sqrt = Math.sqrt;

atan2 = Math.atan2;

labPrototype = {
  LCh: function(T) {
    if (T == null) {
      T = require("./LCh")();
    }
    T.L = this.L;
    T.C = sqrt(this.a * this.a + this.b * this.b);
    T.h = atan2(this.b, this.a);
    return T;
  },
  toString: function() {
    return "L=" + this.L + ", a=" + this.a + ", b=" + this.b;
  }
};

module.exports = O((function(L, a, b) {
  this.L = L;
  this.a = a;
  this.b = b;
}), labPrototype);

},{"./LCh":1,"ut1l/create/object":14}],3:[function(require,module,exports){
var O, cutByte, from2Hex, fromByte, rgb24Prototype, to2Hex;

O = require("ut1l/create/object");

cutByte = function(b) {
  if ((0 <= b && b <= 255)) {
    return b;
  } else {
    return void 0;
  }
};

fromByte = function(b) {
  if (b === void 0) {
    return b;
  } else {
    return b / 255;
  }
};

to2Hex = function(b) {
  var hex;
  hex = (b.toString(16)).toUpperCase();
  if (hex.length === 1) {
    return "0" + hex;
  } else {
    return hex;
  }
};

from2Hex = function(str) {
  return parseInt(str, 16);
};

rgb24Prototype = {
  rgb: function(T) {
    if (T == null) {
      T = require("./rgb")();
    }
    T.r = fromByte(this.R);
    T.g = fromByte(this.G);
    T.b = fromByte(this.B);
    return T;
  },
  hex: function(str) {
    if (str != null) {
      this.R = from2Hex(str.substring(0, 2));
      this.G = from2Hex(str.substring(2, 4));
      this.B = from2Hex(str.substring(4, 6));
      return this;
    } else {
      if (this.isDefined()) {
        return (to2Hex(this.R)) + (to2Hex(this.G)) + (to2Hex(this.B));
      } else {
        return void 0;
      }
    }
  },
  isDefined: function() {
    return (this.R != null) && (this.G != null) && (this.B != null);
  },
  toString: function() {
    return "R=" + this.R + ", G=" + this.G + ", B=" + this.B;
  }
};

module.exports = O((function(R, G, B) {
  this.R = R;
  this.G = G;
  this.B = B;
}), rgb24Prototype);

},{"./rgb":7,"ut1l/create/object":14}],4:[function(require,module,exports){
var O, xyzPrototype;

O = require("ut1l/create/object");

xyzPrototype = {
  xyY: function(T) {
    if (T == null) {
      T = require("./xyY")();
    }
    T.x = this.X / (this.X + this.Y + this.Z);
    T.y = this.Y / (this.X + this.Y + this.Z);
    T.Y = this.Y;
    return T;
  },
  isDefined: function() {
    return (this.X != null) && (this.Y != null) && (this.Z != null);
  },
  toString: function() {
    return "X=" + this.X + ", Y=" + this.Y + ", Z=" + this.Z;
  }
};

module.exports = O((function(X, Y, Z) {
  this.X = X;
  this.Y = Y;
  this.Z = Z;
}), xyzPrototype);

},{"./xyY":11,"ut1l/create/object":14}],5:[function(require,module,exports){
var O, createHsv, floor, hsv, hsvPrototype;

O = require("ut1l/create/object");

floor = Math.floor;

hsvPrototype = {
  rgb: function(T) {
    var f, h, p, q, t;
    if (T == null) {
      T = require("./rgb")();
    }
    if (this.s === 0) {
      return T.set(this.v, this.v, this.v);
    } else {
      h = (this.h - floor(this.h)) * 6;
      f = h - floor(h);
      p = this.v * (1 - this.s);
      q = this.v * (1 - this.s * f);
      t = this.v * (1 - this.s * (1 - f));
      switch (floor(h)) {
        case 0:
          return T.set(this.v, t, p);
        case 1:
          return T.set(q, this.v, p);
        case 2:
          return T.set(p, this.v, t);
        case 3:
          return T.set(p, q, this.v);
        case 4:
          return T.set(t, p, this.v);
        case 5:
          return T.set(this.v, p, q);
      }
    }
  },
  set: function(h, s, v) {
    this.h = h;
    this.s = s;
    this.v = v;
    return this;
  },
  toString: function() {
    return "h=" + this.h + ", s=" + this.s + ", v=" + this.v;
  }
};

hsv = createHsv = O((function(h, s, v) {
  this.h = h;
  this.s = s;
  this.v = v;
}), hsvPrototype);

(require("./rgb")).extendRgb(function(rgb) {
  return rgb.hsv = function(T) {
    var d, max, min;
    if (T == null) {
      T = createHsv();
    }
    max = Math.max(this.r, this.g, this.b);
    min = Math.min(this.r, this.g, this.b);
    T.v = max;
    d = max - min;
    T.s = max !== 0 ? d / max : 0;
    if (T.s === 0) {
      T.h = 0;
    } else {
      switch (max) {
        case this.r:
          T.h = this.g < this.b ? 6 : 0;
          T.h += (this.g - this.b) / d;
          break;
        case this.g:
          T.h = 2 + (this.b - this.r) / d;
          break;
        default:
          T.h = 4 + (this.r - this.g) / d;
      }
      T.h /= 6;
    }
    return T;
  };
});

module.exports = hsv;

},{"./rgb":7,"ut1l/create/object":14}],6:[function(require,module,exports){
var index;

module.exports = index = {
  rgb: require("./rgb"),
  RGB: require("./RGB"),
  hsv: require("./hsv"),
  Lab: require("./Lab"),
  LCh: require("./LCh"),
  XYZ: require("./XYZ"),
  xyY: require("./xyY"),
  white: require("./white"),
  space: {
    rgb: require("./space/rgb"),
    lab: require("./space/lab")
  }
};

if (typeof window !== "undefined" && window !== null) {
  window.c0lor = index;
}

},{"./LCh":1,"./Lab":2,"./RGB":3,"./XYZ":4,"./hsv":5,"./rgb":7,"./space/lab":8,"./space/rgb":9,"./white":10,"./xyY":11}],7:[function(require,module,exports){
var O, cutByte, rgbPrototype, round, toByte, validRgbEl;

O = require("ut1l/create/object");

round = Math.round;

cutByte = function(b) {
  if ((0 <= b && b <= 255)) {
    return b;
  } else {
    return void 0;
  }
};

toByte = function(d) {
  return cutByte(round(d * 255));
};

validRgbEl = function(x) {
  return (isFinite(x)) && (0 <= x && x <= 1);
};

rgbPrototype = {
  RGB: function(T) {
    if (T == null) {
      T = require("./RGB")();
    }
    T.R = toByte(this.r);
    T.G = toByte(this.g);
    T.B = toByte(this.b);
    return T;
  },
  set: function(r, g, b) {
    this.r = r;
    this.g = g;
    this.b = b;
    return this;
  },
  isDefined: function() {
    return (this.r != null) && (this.g != null) && (this.b != null);
  },
  isValid: function() {
    return this.isDefined() && (validRgbEl(this.r)) && (validRgbEl(this.g)) && (validRgbEl(this.b));
  },
  toString: function() {
    return "r=" + this.r + ", g=" + this.g + ", b=" + this.b;
  }
};

module.exports = O({
  extendRgb: function(f) {
    return f(rgbPrototype);
  }
}, (function(r, g, b) {
  this.r = r;
  this.g = g;
  this.b = b;
}), rgbPrototype);

},{"./RGB":3,"ut1l/create/object":14}],8:[function(require,module,exports){
var Lab, N, O, e, e3, f, fDeriv, fInv, foo, labCsPrototype, pow, xyz;

O = require("ut1l/create/object");

xyz = require("../XYZ");

Lab = require("../Lab");

pow = Math.pow;

N = 4 / 29;

e3 = 216 / 24389;

foo = 841 / 108;

e = 6 / 29;

f = function(w) {
  if (w > e3) {
    return pow(w, 1 / 3);
  } else {
    return foo * w + N;
  }
};

fInv = function(w) {
  if (w > e) {
    return pow(w, 3);
  } else {
    return (w - N) / foo;
  }
};

fDeriv = function(w) {
  if (w > e3) {
    return 1 / (3 * (pow(w, 2 / 3)));
  } else {
    return foo;
  }
};

labCsPrototype = {
  Lab: function(XYZ, T) {
    var l;
    if (T == null) {
      T = Lab();
    }
    l = f(XYZ.Y / this.white.Y);
    T.L = 116 * l - 16;
    T.a = 500 * ((f(XYZ.X / this.white.X)) - l);
    T.b = 200 * (l - (f(XYZ.Z / this.white.Z)));
    return T;
  },
  XYZ: function(Lab, T) {
    var fy;
    if (T == null) {
      T = xyz();
    }
    fy = (Lab.L + 16) / 116;
    T.X = (fInv(fy + Lab.a / 500)) * this.white.X;
    T.Y = (fInv(fy)) * this.white.Y;
    T.Z = (fInv(fy - Lab.b / 200)) * this.white.Z;
    return T;
  },
  LabderivL: function(Y) {
    return 116 * (fDeriv(Y / this.white.Y)) / this.white.Y;
  }
};

module.exports = O((function(white) {
  this.white = white;
}), labCsPrototype);

},{"../Lab":2,"../XYZ":4,"ut1l/create/object":14}],9:[function(require,module,exports){
var M, O, XYZ, createSpace, gammaSRgb, gammaSRgbInv, lazyInitRgbBase, lu, pow, rgbSpaceConstructor, rgbSpacePrototype, white, xyY;

O = require("ut1l/create/object");

M = require("m4th/matrix");

lu = require("m4th/lu");

white = require("../white");

xyY = require("../xyY");

XYZ = require("../XYZ");

pow = Math.pow;

gammaSRgb = function(x) {
  if (x <= 0.04045) {
    return x / 12.92;
  } else {
    return pow((x + 0.055) / 1.055, 2.4);
  }
};

gammaSRgbInv = function(x) {
  if (x <= 0.0031308) {
    return x * 12.92;
  } else {
    return 1.055 * (pow(x, 1 / 2.4)) - 0.055;
  }
};

lazyInitRgbBase = function() {
  var bxyz, bxyzLU, w;
  bxyz = M([this.red.x, this.green.x, this.blue.x, this.red.y, this.green.y, this.blue.y, 1 - this.red.x - this.red.y, 1 - this.green.x - this.green.y, 1 - this.blue.x - this.blue.y]);
  bxyzLU = lu(bxyz);
  w = M(3, [this.white.X, this.white.Y, this.white.Z]);
  bxyzLU.solve(w, w);
  bxyz = bxyz.mult(M.diag(w.array));
  this.base = bxyz.array;
  this.baseInv = (lu(bxyz)).getInverse().array;
  delete this.XYZ;
  delete this.rgb;
};

rgbSpaceConstructor = function(red, green, blue, white, gamma, gammaInv) {
  this.red = red;
  this.green = green;
  this.blue = blue;
  this.white = white;
  if (typeof gamma === "function") {
    this.gamma = gamma;
    this.gammaInv = gammaInv;
  } else {
    this.g = gamma;
    this.gInv = 1 / gamma;
  }
  this.rgb = function() {
    lazyInitRgbBase.call(this);
    return this.rgb.apply(this, arguments);
  };
  this.XYZ = function() {
    lazyInitRgbBase.call(this);
    return this.XYZ.apply(this, arguments);
  };
};

rgbSpacePrototype = {
  gamma: function(x) {
    return pow(x, this.g);
  },
  gammaInv: function(x) {
    return pow(x, this.gInv);
  },
  rgb: function(XYZ, T) {
    var a;
    if (T == null) {
      T = require("../rgb")();
    }
    a = this.baseInv;
    T.r = this.gammaInv(a[0] * XYZ.X + a[1] * XYZ.Y + a[2] * XYZ.Z);
    T.g = this.gammaInv(a[3] * XYZ.X + a[4] * XYZ.Y + a[5] * XYZ.Z);
    T.b = this.gammaInv(a[6] * XYZ.X + a[7] * XYZ.Y + a[8] * XYZ.Z);
    return T;
  },
  XYZ: function(Rgb, T) {
    var a, gb, gg, gr;
    if (T == null) {
      T = XYZ();
    }
    a = this.base;
    gr = this.gamma(Rgb.r);
    gg = this.gamma(Rgb.g);
    gb = this.gamma(Rgb.b);
    T.X = a[0] * gr + a[1] * gg + a[2] * gb;
    T.Y = a[3] * gr + a[4] * gg + a[5] * gb;
    T.Z = a[6] * gr + a[7] * gg + a[8] * gb;
    return T;
  }
};

createSpace = O(rgbSpaceConstructor, rgbSpacePrototype);

createSpace["Adobe-98"] = createSpace(xyY(0.6400, 0.3300), xyY(0.2100, 0.7100), xyY(0.1500, 0.0600), white.D65, 2.2);

createSpace["Adobe-RGB"] = createSpace(xyY(0.6250, 0.3400), xyY(0.2800, 0.5950), xyY(0.1550, 0.0700), white.D65, 1.8);

createSpace["CIE-RGB"] = createSpace(xyY(0.7350, 0.2650), xyY(0.2740, 0.7170), xyY(0.1670, 0.0090), white.E, 1);

createSpace["ColorMatch"] = createSpace(xyY(0.6300, 0.3400), xyY(0.2950, 0.6050), xyY(0.1500, 0.0750), white.D50, 1.8);

createSpace["EBU-Monitor"] = createSpace(xyY(0.6314, 0.3391), xyY(0.2809, 0.5971), xyY(0.1487, 0.0645), white.D50, 1.9);

createSpace["ECI-RGB"] = createSpace(xyY(0.6700, 0.3300), xyY(0.2100, 0.7100), xyY(0.1400, 0.0800), white.D50, 1.8);

createSpace["HDTV"] = createSpace(xyY(0.6400, 0.3300), xyY(0.2900, 0.6000), xyY(0.1500, 0.0600), white.D65, 2.2);

createSpace["Kodak-DC"] = createSpace(xyY(0.6492, 0.3314), xyY(0.3219, 0.5997), xyY(0.1548, 0.0646), white.D50, 2.22);

createSpace["NTSC-53"] = createSpace(xyY(0.6700, 0.3300), xyY(0.2100, 0.7100), xyY(0.1400, 0.0800), white.C, 2.2);

createSpace["PAL-SECAM"] = createSpace(xyY(0.6400, 0.3300), xyY(0.2900, 0.6000), xyY(0.1500, 0.0600), white.D65, 2.2);

createSpace["sRGB"] = createSpace(xyY(0.6400, 0.3300), xyY(0.3000, 0.6000), xyY(0.1500, 0.0600), white.D65, gammaSRgb, gammaSRgbInv);

createSpace["WideGamut"] = createSpace(xyY(0.7347, 0.2653), xyY(0.1152, 0.8264), xyY(0.1566, 0.0177), white.D50, 2.2);

module.exports = createSpace;

},{"../XYZ":4,"../rgb":7,"../white":10,"../xyY":11,"m4th/lu":12,"m4th/matrix":13,"ut1l/create/object":14}],10:[function(require,module,exports){
var xy, xyY;

xyY = require("./xyY");

xy = function(x, y) {
  return (xyY(x, y, 1)).XYZ();
};

module.exports = {
  A: xy(0.44757, 0.40745),
  B: xy(0.34842, 0.35161),
  C: xy(0.31006, 0.31616),
  D50: xy(0.34567, 0.35850),
  D55: xy(0.33242, 0.34743),
  D65: xy(0.31271, 0.32902),
  D75: xy(0.29902, 0.31485),
  E: xy(1 / 3, 1 / 3),
  F1: xy(0.31310, 0.33727),
  F2: xy(0.37208, 0.37529),
  F3: xy(0.40910, 0.39430),
  F4: xy(0.44018, 0.40329),
  F5: xy(0.31379, 0.34531),
  F6: xy(0.37790, 0.38835),
  F7: xy(0.31292, 0.32933),
  F8: xy(0.34588, 0.35875),
  F9: xy(0.37417, 0.37281),
  F10: xy(0.34609, 0.35986),
  F11: xy(0.38052, 0.37713),
  F12: xy(0.43695, 0.40441)
};

},{"./xyY":11}],11:[function(require,module,exports){
var O, xyyPrototype;

O = require("ut1l/create/object");

xyyPrototype = {
  XYZ: function(T) {
    if (T == null) {
      T = require("./XYZ")();
    }
    T.X = this.x * this.Y / this.y;
    T.Y = this.Y;
    T.Z = (1 - this.x - this.y) * this.Y / this.y;
    return T;
  },
  isDefined: function() {
    return (this.x != null) && (this.y != null) && (this.Y != null);
  },
  toString: function() {
    return "x=" + this.x + ", y=" + this.y + ", Y=" + this.Y;
  }
};

module.exports = O((function(x, y, Y) {
  this.x = x;
  this.y = y;
  this.Y = Y;
}), xyyPrototype);

},{"./XYZ":4,"ut1l/create/object":14}],12:[function(require,module,exports){
var M, T, creator, fail, luDecompConstructor, luDecompPrototype;

M = require("./matrix");

creator = require("ut1l/create/object");

T = require("ut1l/create/throwable");

fail = T("MatrixException");


/*
  A very basic LU decomposition implementation without pivoting. Decomposition is done in place. Given buffer must
  be square and regular. The values of L below the diagonal are stored. The ones on the diagonal and the zeros
  above the diagonal are not stored. The values of U on and above the diagonal are stored. The zero values below
  the diagonal are not stored.
 */

luDecompConstructor = function(A, T) {
  var i, j, k, _i, _j, _k, _l, _m, _ref, _ref1, _ref2, _ref3;
  if (T == null) {
    T = A.clone();
  }
  for (i = _i = 0, _ref = T.columns; _i < _ref; i = _i += 1) {
    for (j = _j = i, _ref1 = T.columns; _j < _ref1; j = _j += 1) {
      for (k = _k = 0; _k < i; k = _k += 1) {
        T.set(i, j, (T.get(i, j)) - (T.get(i, k)) * (T.get(k, j)));
      }
    }
    for (j = _l = _ref2 = i + 1, _ref3 = T.columns; _l < _ref3; j = _l += 1) {
      for (k = _m = 0; _m < i; k = _m += 1) {
        T.set(j, i, (T.get(j, i)) - (T.get(j, k)) * (T.get(k, i)));
      }
      T.set(j, i, (T.get(j, i)) / (T.get(i, i)));
    }
  }
  this.lu = T;
};

luDecompPrototype = {

  /* Calculate X = A^-1 * B in place or not in place */
  solve: function(B, T) {
    var A, i, j, k, _i, _j, _k, _l, _m, _n, _o, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
    if (T == null) {
      T = B.clone();
    }
    A = this.lu;
    if (B.rows !== A.columns || !B.isSize(T)) {
      fail("unmatching matrix dimension");
    }
    for (k = _i = 0, _ref = A.columns; _i < _ref; k = _i += 1) {
      for (i = _j = _ref1 = k + 1, _ref2 = A.columns; _j < _ref2; i = _j += 1) {
        for (j = _k = 0, _ref3 = T.columns; _k < _ref3; j = _k += 1) {
          T.set(i, j, (T.get(i, j)) - (T.get(k, j)) * (A.get(i, k)));
        }
      }
    }
    for (k = _l = _ref4 = A.columns - 1; _l >= 0; k = _l += -1) {
      for (j = _m = 0, _ref5 = T.columns; _m < _ref5; j = _m += 1) {
        T.set(k, j, (T.get(k, j)) / (A.get(k, k)));
      }
      for (i = _n = 0; _n < k; i = _n += 1) {
        for (j = _o = 0, _ref6 = T.columns; _o < _ref6; j = _o += 1) {
          T.set(i, j, (T.get(i, j)) - (T.get(k, j)) * (A.get(i, k)));
        }
      }
    }
    return T;
  },
  getInverse: function() {
    var I;
    I = M.I(this.lu.columns);
    return this.solve(I, I);
  }
};

module.exports = creator(luDecompConstructor, luDecompPrototype);

},{"./matrix":13,"ut1l/create/object":14,"ut1l/create/throwable":15}],13:[function(require,module,exports){
var T, add, ceil, createMatrix, creator, each, eachDiagonal, eachInRow, fail, failUnmatchingDimensions, floor, id, isNumber, makeReduce, matrixConstructor, matrixProto, matrixStatic, min, minus, sqrt;

creator = require("ut1l/create/object");

T = require("ut1l/create/throwable");

fail = T("MatrixException");

failUnmatchingDimensions = function() {
  return fail("invalid dimension");
};

floor = Math.floor, ceil = Math.ceil, sqrt = Math.sqrt, min = Math.min;

id = function(x) {
  return x;
};

add = function(a, b) {
  return a + b;
};

minus = function(a, b) {
  return a - b;
};

isNumber = function(n) {
  return typeof n === "number";
};

matrixConstructor = function(arrayOrRows, arrayOrColumns, arrayOpt) {
  var array, cols, rows;
  if (!isNumber(arrayOrRows)) {
    array = arrayOrRows;
  } else {
    rows = arrayOrRows;
    if (!isNumber(arrayOrColumns)) {
      array = arrayOrColumns;
    } else {
      cols = arrayOrColumns;
      array = arrayOpt;
    }
  }
  if (rows == null) {
    rows = ceil(sqrt(array.length));
  }
  if (cols == null) {
    cols = rows === 0 ? 0 : array != null ? ceil(array.length / rows) : rows;
  }
  if (array == null) {
    array = [];
  }
  this.columns = cols;
  this.rows = rows;
  this.array = array;
};

matrixStatic = {
  I: function(rows, columns) {
    var i, _i, _ref;
    if (columns == null) {
      columns = rows;
    }
    T = createMatrix(rows, columns);
    T.fill(0, T);
    for (i = _i = 0, _ref = min(rows, columns); _i < _ref; i = _i += 1) {
      T.set(i, i, 1);
    }
    return T;
  },
  diag: function(x, T) {
    if (T == null) {
      T = createMatrix(x.length, x.length);
    } else if (!T.isSize(x.length)) {
      failUnmatchingDimensions();
    }
    T.each(function(val, r, c) {
      return T.set(r, c, r === c ? x[r] : 0);
    });
    return T;
  }
};

eachInRow = function(row, handler) {
  var j, _i, _ref;
  for (j = _i = 0, _ref = this.columns; _i < _ref; j = _i += 1) {
    handler.call(this, this.get(row, j), row, j);
  }
  return this;
};

each = function(handler) {
  var i, _i, _ref;
  for (i = _i = 0, _ref = this.rows; _i < _ref; i = _i += 1) {
    eachInRow.call(this, i, handler);
  }
  return this;
};

eachDiagonal = function(handler) {
  var ij, _i, _ref;
  for (ij = _i = 0, _ref = min(this.rows, this.columns); _i < _ref; ij = _i += 1) {
    handler.call(this, this.get(ij, ij), ij, ij);
  }
  return this;
};

makeReduce = function(eachFunc) {
  return function(callback, initialValue) {
    var value;
    value = initialValue;
    eachFunc.call(this, function(val, i, j) {
      if (value != null) {
        value = callback.call(this, value, val, i, j);
      } else {
        value = val;
      }
    });
    return value;
  };
};

matrixProto = {
  get: function(row, col) {
    if (col == null) {
      col = 0;
    }
    return this.array[row * this.columns + col];
  },
  set: function(row, col, val) {
    this.array[row * this.columns + col] = val;
    return this;
  },
  isSize: function(rowsOrM, columns) {
    if (isNumber(rowsOrM)) {
      if (columns == null) {
        columns = rowsOrM;
      }
      return this.rows === rowsOrM && this.columns === columns;
    } else {
      return this.isSize(rowsOrM.rows, rowsOrM.columns);
    }
  },
  isSquare: function() {
    return this.rows === this.columns;
  },
  each: each,
  eachDiagonal: eachDiagonal,
  reduce: makeReduce(each),
  reduceDiagonal: makeReduce(eachDiagonal),
  reduceRows: function(callback, initialValue) {
    var i, j, rdcRows, val, value, _i, _j, _ref, _ref1;
    rdcRows = [];
    for (i = _i = 0, _ref = this.rows; _i < _ref; i = _i += 1) {
      value = initialValue;
      for (j = _j = 0, _ref1 = this.columns; _j < _ref1; j = _j += 1) {
        val = this.get(i, j);
        if (value != null) {
          value = callback.call(this, value, val, i, j);
        } else {
          value = val;
        }
      }
      rdcRows.push(value);
    }
    return rdcRows;
  },
  map: function() {
    var args, elements, func, l, n;
    args = arguments;
    n = args.length - 1;
    if (args[n] === void 0) {
      n -= 1;
    }
    if (typeof args[n] !== "function") {
      T = args[n--];
      if (!this.isSize(T)) {
        failUnmatchingDimensions();
      }
    } else {
      T = createMatrix(this.rows, this.columns);
    }
    func = args[n];
    l = T.rows * T.columns;
    elements = [];
    T.each((function(_this) {
      return function(val, i, j) {
        var k, _i;
        elements[0] = _this.get(i, j);
        for (k = _i = 0; _i < n; k = _i += 1) {
          elements[k + 1] = args[k].get(i, j);
        }
        elements[++k] = i;
        elements[++k] = j;
        return T.set(i, j, func.apply(_this, elements));
      };
    })(this));
    return T;
  },
  clone: function(T) {
    return this.map(id, T);
  },
  fill: function(s, T) {
    return this.map((function() {
      return s;
    }), T);
  },
  times: function(s, T) {
    return this.map((function(x) {
      return s * x;
    }), T);
  },
  add: function(B, T) {
    return this.map(B, add, T);
  },
  minus: function(B, T) {
    return this.map(B, minus, T);
  },
  transp: function(T) {
    var B, i, j, _i, _j, _ref, _ref1, _ref2;
    if (T == null) {
      T = createMatrix(this.columns, this.rows);
    }
    if (T === this) {
      B = this.clone();
      _ref = [this.columns, this.rows], this.rows = _ref[0], this.columns = _ref[1];
      return B.transp(this);
    } else {
      if (this.rows !== T.columns || this.columns !== T.rows) {
        failUnmatchingDimensions();
      }
      for (i = _i = 0, _ref1 = this.columns; _i < _ref1; i = _i += 1) {
        for (j = _j = 0, _ref2 = this.rows; _j < _ref2; j = _j += 1) {
          T.set(i, j, this.get(j, i));
        }
      }
      return T;
    }
  },
  mult: function(B, T) {
    var i, j, k, _i, _j, _k, _ref, _ref1, _ref2;
    if (T == null) {
      T = createMatrix(this.rows, B.columns);
    }
    if (this.columns !== B.rows || T.rows !== this.rows || T.columns !== B.columns) {
      failUnmatchingDimensions();
    }
    T.fill(0, T);
    for (i = _i = 0, _ref = this.rows; _i < _ref; i = _i += 1) {
      for (j = _j = 0, _ref1 = B.columns; _j < _ref1; j = _j += 1) {
        for (k = _k = 0, _ref2 = this.columns; _k < _ref2; k = _k += 1) {
          T.array[i * T.columns + j] += (this.get(i, k)) * (B.get(k, j));
        }
      }
    }
    return T;
  },
  toString: (function() {
    var concatEntries;
    concatEntries = function(x, y) {
      return x + " " + y;
    };
    return function() {
      return (this.reduceRows(concatEntries)).join("\n");
    };
  })()
};

module.exports = createMatrix = creator(matrixStatic, matrixConstructor, matrixProto);

},{"ut1l/create/object":14,"ut1l/create/throwable":15}],14:[function(require,module,exports){
var createBuilder;

createBuilder = function(extend, constructor, prototype) {
  var F, f, key, value;
  if (typeof extend === "function") {
    prototype = constructor;
    constructor = extend;
    extend = null;
  } else if ((constructor == null) && (prototype == null)) {
    prototype = extend;
    extend = null;
  }
  F = constructor != null ? function(args) {
    var ret;
    ret = constructor.apply(this, args);
    if (ret !== void 0) {
      return ret;
    } else {
      return this;
    }
  } : function() {};
  if (prototype == null) {
    prototype = {};
  }
  F.prototype = prototype;
  f = function() {
    return new F(arguments);
  };
  f.prototype = prototype;
  for (key in extend) {
    value = extend[key];
    f[key] = value;
  }
  return f;
};

module.exports = createBuilder;

},{}],15:[function(require,module,exports){
var O, createCreateThrowable, createTopThrowable, throwableConstr, throwableProto;

O = require("./object");

throwableProto = {
  name: "Error",
  toString: function() {
    if (this.message != null) {
      return "" + this.name + ": " + this.message;
    } else {
      return this.name;
    }
  }
};

createTopThrowable = O(throwableProto);

throwableConstr = function(message) {
  var e;
  this.message = message;
  e = Error.call(this, message);
  this.stack = e.stack;
};

createCreateThrowable = function(name, parent) {
  var proto;
  if (parent == null) {
    parent = createTopThrowable;
  }
  proto = parent();
  if (name != null) {
    proto.name = name;
  }
  return O(throwableConstr, proto);
};

createCreateThrowable.c4tch = function() {
  var action, arg, args, idx, onError, throwables, _i, _len;
  args = arguments;
  throwables = [];
  for (idx = _i = 0, _len = args.length; _i < _len; idx = ++_i) {
    arg = args[idx];
    if (arg.prototype instanceof createTopThrowable) {
      throwables.push(arg);
    } else {
      break;
    }
  }
  if (throwables.length === 0) {
    throwables.push(createTopThrowable);
  }
  action = args[idx];
  onError = args[idx + 1];
  return function() {
    var e, t, _j, _len1;
    try {
      return action.apply(this, arguments);
    } catch (_error) {
      e = _error;
      for (_j = 0, _len1 = throwables.length; _j < _len1; _j++) {
        t = throwables[_j];
        if (e instanceof t) {
          return (onError != null ? onError.call(this, e) : void 0);
        }
      }
      throw e;
    }
  };
};

module.exports = createCreateThrowable;

},{"./object":14}]},{},[6])