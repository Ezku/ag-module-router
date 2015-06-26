module.exports = (grunt) ->
  grunt.registerTask 'build', [
    'compile'
    'browserify'
  ]
