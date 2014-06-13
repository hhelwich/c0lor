# Always returns the index object anyway if tested in browser or node. Also does call require so browserify does not
# follow this import.

index = if (inBrowser = c0lor?) then c0lor else require.call null, "../../src/index"

index.BROWSER = inBrowser

module.exports = index