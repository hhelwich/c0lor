# A gulp task which copies an adapts the package.json file of this package to the npm publish directory.

# Imports
gulp = require "gulp"
fs = require "fs"

config = require "./config"

# Register task
gulp.task "packageJson", (cb) ->

  # Read package.json file to object
  fs.readFile "./package.json", encoding: "utf8", (err, data) ->

    pkg = JSON.parse data

    # Adapt package object content
    pkg.devDependencies = {}
    delete pkg.private
    delete pkg.scripts

    # Create package directory if not existing (otherwise writeFile fails)
    fs.exists config.dir.package, (exists) ->
      if not exists
        fs.mkdirSync config.dir.package

      # Write package file for npm publish
      fs.writeFile "#{config.dir.package}/package.json", (JSON.stringify pkg, null, 2), (err) ->
        cb err
