"use strict"
module.exports = (grunt) ->

  # Load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # Configurable paths
  coreConfig =
    pkg: grunt.file.readJSON("package.json")
    app: "./less"
    dist: "./css"
    banner: do ->
      banner = "/*!\n"
      banner += " * (c) <%= core.pkg.author %>.\n *\n"
      banner += " * <%= core.pkg.name %> - v<%= core.pkg.version %> (<%= grunt.template.today('mm-dd-yyyy') %>)\n"
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

    lesslint:
      options:
        csslint:
          csslintrc: "<%= core.app %>/.csslintrc"

      test:
        src: ["<%= core.dist %>/cube.css"]

    watch:
      coffee:
        files: ["<%= coffeelint.test.src %>"]
        tasks: ["coffeelint"]

      less:
        files: ["<%= core.app %>/**/*.less"]
        tasks: ["lesslint", "less:serve", "postcss:serve"]

    less:
      options:
        strictMath: true

      serve:
        options:
          sourceMap: true
          sourceMapFileInline: true
          outputSourceFiles: true

        src: ["<%= core.app %>/cube.less"]
        dest: "<%= core.dist %>/cube.css"

      dist:
        src: ["<%= less.serve.src %>"]
        dest: "<%= less.serve.dest %>"

    postcss:
      serve:
        src: "<%= less.serve.dest %>"
        options:
          map:
            inline: true
          processors: [
            require("autoprefixer")(browsers: "last 1 versions")
          ]

      dist:
        src: "<%= postcss.serve.src %>"
        options:
          processors: [
            require("autoprefixer")(browsers: "last 2 versions")
          ]

    csscomb:
      options:
        config: "<%= core.app %>/.csscomb.json"

      dist:
        src: ["<%= less.serve.dest %>"]
        dest: "<%= less.serve.dest %>"

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

      serve:
        tasks: ["watch"]

      dist:
        tasks: ["cssmin"]

    clean: [".tmp", "<%= core.dist %>/*"]

    conventionalChangelog:
      options:
        changelogOpts:
          preset: "angular"

      dist:
        src: "CHANGELOG.md"

    bump:
      options:
        files: ["package.json"]
        updateConfigs: ["config.pkg"]
        commitMessage: "chore: release v%VERSION%"
        commitFiles: ["-a"]
        tagMessage: "chore: create tag %VERSION%"
        push: false

  # Fire up a server on local machine for development
  grunt.registerTask "serve", [
      "clean"
    , "less:serve"
    , "postcss:serve"
    , "concurrent:serve"
  ]

  # Test task
  grunt.registerTask "test", [
      "build"
    , "lesslint"
  ]

  # Build site with `jekyll`
  grunt.registerTask "build", [
      "clean"
    , "coffeelint"
    , "less:dist"
    , "postcss:dist"
    , "csscomb"
    , "concurrent:dist"
  ]

  # Release new version
  grunt.registerTask "release", "Build, bump and commit", (type) ->
    grunt.task.run [
      "bump-only:#{type or 'patch'}"
      "conventionalChangelog"
      "bump-commit"
    ]

  # Default task aka. build task
  grunt.registerTask "default", ["build"]
