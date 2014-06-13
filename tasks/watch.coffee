# Define tasks to run if some files change

# Imports
gulp = require "gulp"
config = require "./config"

coffee = require "./coffee"

# Create watch task
gulp.task "watch", ->
  gulp.watch "#{config.dir.src}/**/*.coffee", ["coffee"]