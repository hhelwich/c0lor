# A gulp task which copies an adapts the package.json file of this package to the npm publish directory.

# Imports
gulp = require "gulp"
fs = require "fs"

config = require "./config"

# Register task
gulp.task "packageJson", ->

  # Read package.json file to object
  tmpPkg = fs.readFileSync "./package.json", encoding: "utf8"
  tmpPkg = JSON.parse tmpPkg

  # Adapt package object content
  tmpPkg.devDependencies = {}
  delete tmpPkg.private
  delete tmpPkg.scripts

  # Create package directory if not existing (otherwise writeFile fails)
  if not fs.existsSync config.dir.package
    fs.mkdirSync config.dir.package

  # Write package file for npm publish
  fs.writeFileSync "#{config.dir.package}/package.json", JSON.stringify tmpPkg, null, 2
