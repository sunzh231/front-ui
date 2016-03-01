/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    clean: {
        prebuild: ['assets/', 'preview/']
    },
    copy: {
        main: {
            files: [{
                expand: true,
                cwd: 'app/',
                src: ['**'],
                dest: 'preview/'
            }]
        }
    },
    bower: {
      install: {
        options: {
          targetDir: './assets/lib',
          layout: 'byComponent',
          install: true,
          verbose: false,
          cleanTargetDir: false,
          cleanBowerDir: false,
          bowerOptions: {}
        }
      }
    },
    sass: {
      dist: {
        options: {
          style: 'expanded'
        },
        files: {
          'assets/lib/bootstrap-sass/bootstrap.css': 'assets/lib/bootstrap-sass/_bootstrap.scss',
          'preview/styles/reset.css': 'app/styles/reset.scss',
          'preview/styles/common.css': 'app/styles/common.scss',
          'preview/styles/app.css': 'app/styles/app.scss'
        }
      }
    },
    cssmin: {
      build: {
        files: {
          'assets/dist/css/<%= pkg.name %>.min.css': [ 'preview/styles/**/*.css' ]
        }
      }
    },
    coffee: {
      build: {
        expand: true,
        cwd: 'app/',
        src: [ '**/*.coffee' ],
        dest: 'preview/',
        ext: '.js'
      }
    },
    concat: {
      options: {
        banner: '<%= banner %>',
        stripBanners: true
      },
      router: {
        src: ['preview/scripts/app.js'],
        dest: 'assets/dist/js/app.js'
      },
      controller: {
        src: ['preview/scripts/controllers/**/*.js'],
        dest: 'assets/dist/js/controllers.js'
      },
      directive: {
        src: ['preview/scripts/directives/**/*.js'],
        dest: 'assets/dist/js/directives.js'
      }
    },
    uglify: {
      options: {
        banner: '<%= banner %>'
      },
      router: {
        src: ['<%= concat.router.dest %>'],
        dest: 'assets/dist/js/app.min.js'
      },
      controller: {
        src: ['<%= concat.controller.dest %>'],
        dest: 'assets/dist/js/controllers.min.js'
      },
      directive: {
        src: ['<%= concat.directive.dest %>'],
        dest: 'assets/dist/js/directives.min.js'
      }
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        unused: true,
        boss: true,
        eqnull: true,
        browser: true,
        globals: {
          jQuery: true
        }
      },
      gruntfile: {
        src: 'Gruntfile.js'
      },
      lib_test: {
        src: ['assets/lib/**/*.js', 'test/**/*.js']
      }
    },
    qunit: {
      files: ['test/**/*.html']
    },
    watch: {
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      lib_test: {
        files: '<%= jshint.lib_test.src %>',
        tasks: ['jshint:lib_test', 'qunit']
      },
      css: {
        files: ['app/styles/**/*.scss'],
        tasks: ['buildcss']
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-qunit');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-bower-task');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-cssc');

  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Default task.
  //grunt.registerTask('default', ['jshint', 'qunit', 'concat', 'uglify']);
  grunt.registerTask('default', ['clean:prebuild', 'bower', 'sass', 'cssmin', 'coffee', 'concat', 'uglify']);
  grunt.registerTask('buildcss', ['clean:prebuild', 'sass', 'cssmin']);
  grunt.registerTask('buildjs', ['clean:prebuild', 'coffee', 'concat', 'uglify']);

};