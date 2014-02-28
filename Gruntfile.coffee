"use strict"
module.exports = (grunt) ->

  # Load all grunt tasks
  matchdep = require("matchdep")
  matchdep.filterDev("grunt-*").forEach grunt.loadNpmTasks

  # Configurable paths
  coreConfig =
    pkg: grunt.file.readJSON("package.json")
    app: "./less"
    dist: "./css"
    banner: do ->
      banner = "/*!\n"
      banner += " * (c) <%= core.pkg.author %>.\n *\n"
      banner += " * <%= core.pkg.name %> - v<%= core.pkg.version %> (<%= grunt.template.today('mm-dd-yyyy') %>)\n"
      # banner += " * <%= core.pkg.homepage %>\n"
      banner += " * <%= core.pkg.licenses.type %> - <%= core.pkg.licenses.url %>\n"
      banner += " */"
      banner

  # Project configurations
  grunt.initConfig
    core: coreConfig

    coffeelint:
      options:
        indentation: 2
        no_stand_alone_at:
          level: "error"
        no_empty_param_list:
          level: "error"
        max_line_length:
          level: "ignore"

      test:
        src: ["Gruntfile.coffee"]

    csslint:
      options:
        csslintrc: "<%= core.app %>/.csslintrc"

      test:
        src: ["<%= core.dist %>/cube.css"]

    watch:
      coffee:
        files: ["<%= coffeelint.test.src %>"]
        tasks: ["coffeelint"]

      less:
        files: ["<%= core.app %>/**/*.less"]
        tasks: ["less:server", "autoprefixer", "csslint"]

    less:
      server:
        options:
          strictMath: true
          sourceMap: true
          outputSourceFiles: true
          sourceMapURL: "cube.css.map"
          sourceMapFilename: "<%= core.dist %>/cube.css.map"

        src: ["<%= core.app %>/cube.less"]
        dest: "<%= core.dist %>/cube.css"

      dist:
        src: ["<%= less.server.src %>"]
        dest: "<%= less.server.dest %>"

    autoprefixer:
      dist:
        src: ["<%= less.server.dest %>"]
        dest: "<%= less.server.dest %>"

    csscomb:
      options:
        config: "<%= core.app %>/.csscomb.json"

      dist:
        src: ["<%= less.server.dest %>"]
        dest: "<%= less.server.dest %>"

    cssmin:
      dist:
        options:
          banner: "<%= core.banner %>"
          report: "gzip"

        files: [
          expand: true
          cwd: "<%= core.dist %>/"
          src: ["*.css", "!*.min.css"]
          dest: "<%= core.dist %>/"
        ]

    concurrent:
      options:
        logConcurrentOutput: true

      server:
        tasks: ["watch"]

      dist:
        tasks: ["cssmin"]

    clean: [".tmp", "<%= core.dist %>/*"]

  # Fire up a server on local machine for development
  grunt.registerTask "server", [
      "clean"
    , "less:server"
    , "autoprefixer"
    , "concurrent:server"
  ]

  # Test task
  grunt.registerTask "test", [
      "build"
    , "csslint"
  ]

  # Build site with `jekyll`
  grunt.registerTask "build", [
      "clean"
    , "coffeelint"
    , "less:dist"
    , "autoprefixer"
    , "csscomb"
    , "concurrent:dist"
  ]

  # Default task aka. build task
  grunt.registerTask "default", ["build"]
