module.exports =
  compile:
    src: '**/*.coffee'
    cwd: '<%= dir.src %>'
    dest: '<%= dir.lib %>'
    expand: true
    ext: '.js'
