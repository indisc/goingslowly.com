module.exports = function(grunt) {

  var pkg = grunt.file.readJSON('package.json');
  require('matchdep').filterDev(pkg,'grunt-contrib*').forEach(function(dep) {
    grunt.loadNpmTasks(dep);
  });

  grunt.initConfig({

    meta: grunt.file.readYAML('config/goingslowly.yml'),
    assets: 'lib/goingslowly/assets',

    coffee: {
      gs: {
        files: {
          'tmp/gs.js': ['<%= assets %>/js/gs/*.coffee']
        },
        options: {
          bare: true
        }
      },
      page: {
        files: {
          'public/assets/page/*.js': ['<%= assets %>/js/page/*.coffee']
        }
      }
    },

    concat: {
      'public/assets/site.js': ['<%= assets %>/js/lib/jquery.js',
                                '<%= assets %>/js/lib/*.js',
                                'tmp/gs.js']
    },

    compass: {
      compile: {
        options: {
          raw: ['images_dir = "img/"',
                'css_dir = "public/assets"',
                'sass_dir = "<%= assets %>/css"',
                'asset_host { |asset| "<%= meta.url.cdn %>" }'].join('\n')
        }
      }
    },

    uglify: {
      'public/assets/site.js': 'public/assets/site.js',
      'public/assets/ie.js': '<%= assets %>/js/ie.js'
    },

    mincss: {
      'public/assets/site.css': 'public/assets/site.css',
      'public/assets/ie.css': 'public/assets/ie.css'
    },

    watch: {
      src: {
        files: ['<%= assets %>/**/*'],
        tasks: ['build']
      }
    }
  });

  grunt.registerTask('develop', ['coffee', 'concat', 'compass']);
  grunt.registerTask('production', ['default', 'mincss', 'uglify']);
  grunt.registerTask('default', 'develop');

};
