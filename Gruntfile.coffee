workDir = "build"
srcDir = "src"
testSrcDir = "test"


module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON "package.json"

    clean: ["#{workDir}/**/*.js"]

    watch:
      files: [
        "Gruntfile.*"
        "#{srcDir}/**/*.coffee"
        "#{testSrcDir}/**/*.coffee"
      ]
      tasks: ["default"]

    # Transcompile CoffeeScript to JavaScript files
    coffee:
      main:
        options:
          bare: true
        cwd: "#{srcDir}"
        expand: true
        src: ["**/*.coffee"]
        dest: "#{workDir}/#{srcDir}"
        ext: ".js"
      test:
        options:
          bare: true
        cwd: "#{testSrcDir}"
        expand: true
        src: ["**/*.coffee"]
        dest: "#{workDir}/#{testSrcDir}"
        ext: ".js"

    mochacov:
      unit:
        options:
          reporter: "spec"
      coverage:
        options:
          reporter: "mocha-term-cov-reporter"
          coverage: true
      coveralls:
        options:
          coveralls:
            serviceName: "travis-ci"
            repoToken: "2rcTn8BiW6r7XLKDZIyWUs0Ai58AQE1Lo"
      options:
        files: "#{workDir}/**/*.js"

    copy:
      markup:
        src: "*.md"
        dest: "#{workDir}/#{srcDir}/"

    browserify:
      dist:
        files: do ->
          files = {}
          files["#{workDir}/all.js"] = ["#{workDir}/#{srcDir}/**/*.js"]
          files

    uglify:
      dist:
        files:
          "c0lor.min.js": ["#{workDir}/all.js"]


  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-mocha-cov"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-uglify"


  grunt.registerTask "default", ["clean", "coffee", "mochacov:unit", "mochacov:coverage", "copy", "browserify", "uglify"]

  grunt.registerTask "travis", ["clean", "coffee", "mochacov", "copy", "browserify", "uglify"]

