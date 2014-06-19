# Always returns the index object anyway if tested in browser or node. Also does "call()" require so browserify does not
# follow this import.

inBrowser = c0lor?

index = if inBrowser then c0lor else require.call null, "../../src/index"

index.BROWSER = inBrowser

module.exports = index