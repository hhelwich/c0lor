# Register task which trans-compiles CoffeeScript files to JavaScript files

# Imports
gulp   = require "gulp"
util   = require "gulp-util"
coffee = require "gulp-coffee"

config = require "./config"

# Register task
gulp.task "coffee", ->

  gulp.src "#{config.dir.src}/**/*.coffee"
  .pipe (coffee bare: true).on "error", util.log
  .pipe gulp.dest config.dir.package

  gulp.src "#{config.dir.test}/**/*.coffee"
  .pipe (coffee bare: true).on "error", util.log
  .pipe gulp.dest "#{config.dir.build}/test"
