workDir = "build"
srcDir = "src"
testSrcDir = "test"
distDir = "dist"
pkg = require "./package"


module.exports = (grunt) ->

  browsers = []
  browsers.push browser for browser in ({browserName: "iphone", version: "#{vers}"} for vers in ["5.1", "6.0", "6.1", 7])
  browsers.push browser for browser in ({browserName: "android", version: "#{vers}"} for vers in ["4.0"])
  browsers.push browser for browser in ({browserName: "safari", version: "#{vers}"} for vers in [5..7])
  browsers.push browser for browser in ({platform: "XP", browserName: "opera", version: "#{vers}"} for vers in [11..12])
  browsers.push browser for browser in ({platform: "XP", browserName: "googlechrome", version: "#{vers}"} for vers in [26..31])
  browsers.push browser for browser in ({platform: "linux", browserName: "firefox", version: "#{vers}"} for vers in [4..26] by 3)
  browsers.push browser for browser in ({browserName: "internet explorer", version: "#{vers}"} for vers in [6..11])

  grunt.initConfig

    pkg: pkg

    clean: ["#{workDir}"]

    watch:
      files: [
        "Gruntfile.*"
        "#{srcDir}/**/*.coffee"
        "#{testSrcDir}/**/*.coffee"
        "#{testSrcDir}/**/*.js"
        "#{testSrcDir}/**/*.html"
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


    copy:
      markup:
        src: "*.md"
        dest: "#{workDir}/#{srcDir}/"
      jasmine:
        src: ["test/**/*.html", "test/**/*.js", "test/**/*.css"]
        dest: "#{workDir}/"

    browserify:
      dist:
        files: do ->
          files = {}
          files["#{distDir}/#{pkg.name}.js"] = ["#{workDir}/#{srcDir}/index.js"]
          files
      tests:
        files: do ->
          files = {}
          files["#{workDir}/#{testSrcDir}/browser/#{pkg.name}Spec.js"] = ["#{workDir}/#{testSrcDir}/browser/src/**/*.js"]
          files

    uglify:
      dist:
        files:do ->
          files = {}
          files["#{distDir}/#{pkg.name}.min.js"] = ["#{distDir}/#{pkg.name}.js"]
          files

    usebanner:
      taskName:
        options:
          position: "top"
          banner: "// <%= pkg.name %> v<%= pkg.version %> | (c) 2013-<%= grunt.template.today('yyyy') %> <%= pkg.author %> | <%= pkg.license %> License\n'use strict';"
          linebreak: false
        files:
          src: [ "#{distDir}/#{pkg.name}.min.js", "#{distDir}/#{pkg.name}.js" ]


    connect:
      server:
        options:
          base: ""
          port: 9999
          #hostname: "*"


    'saucelabs-jasmine':
      all:
        options:
          urls: ["http://127.0.0.1:9999/build/test/browser/jasmine/SpecRunner.html"]
          tunnelTimeout: 5
          build: process.env.TRAVIS_JOB_ID
          concurrency: 3
          browsers: browsers
          testname: "browser black box tests"
          tags: ["master"]

    mdExtract:
      foo:
        src: ["README.md"]
        dest: "build/test/browser/src"

  # Loading dependencies
  for name of pkg.devDependencies
    if name != "grunt" and name != "grunt-cli" and (name.indexOf "grunt") == 0
      grunt.loadNpmTasks name

  grunt.registerTask "travis", ["clean", "coffee", "copy", "adaptPackageJson", "mdExtract", "browserify", "uglify", "usebanner", "connect", "saucelabs-jasmine"]
  grunt.registerTask "dev", ["clean", "coffee", "copy", "adaptPackageJson", "mdExtract", "browserify", "uglify", "usebanner", "connect", "watch"]
  grunt.registerTask "default", [ "dev"]

  grunt.loadTasks "tasks"

  grunt.registerTask "adaptPackageJson", ->
    fs = require "fs"
    tmpPkg = require "./package"

    tmpPkg.devDependencies = {}
    delete tmpPkg.private
    delete tmpPkg.scripts
    fs.writeFileSync "./build/src/package.json", JSON.stringify tmpPkg, null, 2
