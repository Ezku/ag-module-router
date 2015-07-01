module.exports = (grunt) ->
  grunt.registerTask 'bowerify', ->
    pkg = grunt.file.readJSON 'package.json'

    grunt.file.write 'bower.json', JSON.stringify {
      name: pkg.name
      version: pkg.version
      description: pkg.description
      authors: [ pkg.author ]
      homepage: pkg.homepage
      license: pkg.license
    }, null, 2
