# Map of white points in *XYZ* color space.

# Imports
# -------

# *xyY* color constructor.
xyY = require "./xyY"


# Helpers
# -------

# Create *XYZ* color with luminance *1* from chromaticity.
xy = (x, y) -> do (xyY x, y, 1).XYZ


# Public API
# ----------

# Export Map of white points.
module.exports =
  A:   xy 0.44757, 0.40745
  B:   xy 0.34842, 0.35161
  C:   xy 0.31006, 0.31616
  D50: xy 0.34567, 0.35850
  D55: xy 0.33242, 0.34743
  D65: xy 0.31271, 0.32902
  D75: xy 0.29902, 0.31485
  E:   xy   1 / 3,   1 / 3
  F1:  xy 0.31310, 0.33727
  F2:  xy 0.37208, 0.37529
  F3:  xy 0.40910, 0.39430
  F4:  xy 0.44018, 0.40329
  F5:  xy 0.31379, 0.34531
  F6:  xy 0.37790, 0.38835
  F7:  xy 0.31292, 0.32933
  F8:  xy 0.34588, 0.35875
  F9:  xy 0.37417, 0.37281
  F10: xy 0.34609, 0.35986
  F11: xy 0.38052, 0.37713
  F12: xy 0.43695, 0.40441

