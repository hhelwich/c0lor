# A configuration object which aggregates some constant configuration properties and can also be used to exchange
# information between gulp tasks

# Imports
gulp = require "gulp"

# Configurations
buildDir = "./build"
config =
  dir:
    src: "./src"
    test: "./test"
    build: buildDir
    package: "#{buildDir}/package"
    testJS: "#{buildDir}/test"

# Gulp task that can be used to change the config object so tasks can exchange state
gulp.task "config", (key, value) ->
  config[key] = value

module.exports = config
