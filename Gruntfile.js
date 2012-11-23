module.exports = function(grunt) {

  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-mincss');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.initConfig({

    meta: grunt.file.readYAML('config/goingslowly.yml'),
    assets: 'lib/goingslowly/assets',
    copy: {
      widgets: {
        files: {
          'public/assets/widget/': ['<%= assets %>/js/widget/**/*']
        }
      }
    },

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
      'public/assets/site.js': 'public/assets/site.js'
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

  grunt.registerTask('develop', ['copy', 'coffee', 'concat', 'compass']);
  grunt.registerTask('production', ['default', 'mincss', 'uglify']);
  grunt.registerTask('default', 'develop');

};
