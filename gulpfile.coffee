gulp = require('gulp')
$ = require('gulp-load-plugins')(camelize: true)

pkg = JSON.parse(require('fs').readFileSync('package.json', 'utf8'))

errorHandler = (msg) ->
    $.util.beep()
    $.util.log msg

paths = {}

paths.dev =
    src:
        html: 'html/**/*.html'
        sass: 'sass/**/*.scss'
        coffee: 'coffee/**/*.coffee'
        images: ['images/**/*.png', 'images/**/*.jpg', 'images/**/*.gif', 'images/**/*.webp']
        fonts: 'fonts/**/*'
        components: 'bower_components/**/*'
    dest:
        html: 'app'
        css: 'app/css'
        js: 'app/js'
        images: 'app/images'
        fonts: 'app/fonts'
        components: 'app/lib'

paths.dist =
    src:
        html: paths.dev.dest.html + '/**/*.html'
        css: paths.dev.dest.css + '/**/*.css'
        cssComponents: paths.dev.dest.components + '/**/*.css'
        js: paths.dev.dest.js + '/**/*.js'
        jsComponents: paths.dev.dest.components + '/**/*.js'
        images: paths.dev.dest.images + '/**/*'
        fonts: paths.dev.dest.fonts + '/**/*'
        components: paths.dev.dest.components + '/**/*'
        conf: ['conf/*', 'conf/.nginx']
    dest:
        html: 'dist'
        css: 'dist/css'
        js: 'dist/js'
        images: 'dist/images'
        fonts: 'dist/fonts'


gulp.task 'html', ->
    gulp.src(paths.dev.src.html)
        .pipe($.changed(paths.dev.dest.html))
        .pipe(gulp.dest(paths.dev.dest.html))


gulp.task 'styles', ->
    gulp.src(paths.dev.src.sass)
        .pipe($.rubySass(compass: true, comments: false, unixNewlines: true))
        .on('error', errorHandler)
        .pipe($.autoprefixer())
        .pipe(gulp.dest(paths.dev.dest.css))


gulp.task 'scripts', ->
    gulp.src(paths.dev.src.coffee)
        .pipe($.coffee())
        .on('error', errorHandler)
        .pipe($.changed(paths.dev.dest.js))
        .pipe(gulp.dest(paths.dev.dest.js))


gulp.task 'images', ->
    gulp.src(paths.dev.src.images)
        .pipe($.imagemin())
        .on('error', errorHandler)
        .pipe(gulp.dest(paths.dev.dest.images))


gulp.task 'fonts', ->
    gulp.src(paths.dev.src.fonts)
        .pipe(gulp.dest(paths.dev.dest.fonts))


gulp.task 'bower', ->
    $.bowerFiles()
        .pipe(gulp.dest(paths.dev.dest.components))


gulp.task 'clean', ->
    gulp.src('dist/**/*', read: false)
        .pipe($.rimraf())
        .on('error', errorHandler)


gulp.task 'server', ->
    connect = require('connect')
    app = connect()
        .use(require('connect-livereload')())
        .use(require('connect-file-exists-or-rewrite')(paths.dev.dest.html))
        .use(connect.logger('tiny'))
        .use(connect.static(paths.dev.dest.html))

    server = require('http').createServer(app)

    if process.platform == 'darwin'
        server.listen(require('local-tld-lib').getPort(pkg.name))
        $.util.log('Dev web server running on: ' + $.util.colors.magenta("http://#{pkg.name}.dev/"))
    else
        port = 5000
        server.listen(port)
        $.util.log('Dev web server running on: ' + $.util.colors.magenta("http://localhost:#{port}/"))


gulp.task 'distserver', ['dist'], ->
    connect = require('connect')
    app = connect()
        .use(connect.static(paths.dist.dest.html))

    port = require('local-tld-lib').getPort("#{pkg.name}-dist")
    require('http').createServer(app).listen(port)
    $.util.log('Dist web server running on: ' + $.util.colors.magenta("http://#{pkg.name}-dist.dev/"))
    require('open')("http://#{pkg.name}-dist.dev/")


gulp.task 'default', ['html', 'styles', 'scripts', 'images', 'fonts', 'bower', 'server'], ->
    gulp.watch paths.dev.src.html, ['html']
    gulp.watch paths.dev.src.sass, ['styles']
    gulp.watch paths.dev.src.coffee, ['scripts']
    gulp.watch paths.dev.src.images, ['images']
    gulp.watch paths.dev.src.imagesSVG, ['imagesSVG']
    gulp.watch paths.dev.src.fonts, ['fonts']
    gulp.watch paths.dev.src.components, ['bower']

    lr = $.livereload()
    gulp.watch('app/**/*').on 'change', (file) ->
        lr.changed(file.path)


gulp.task 'dist', ['clean', 'html', 'styles', 'scripts', 'images', 'fonts', 'bower'], ->
    timestamp = (new Date()).getTime()
    gulp.src(paths.dist.src.html)
        .pipe($.useref())
        .pipe($.replace(/app\.min\.css"/, "app.min.css?#{timestamp}\""))
        .pipe($.replace(/app\.min\.js"/, "app.min.js?#{timestamp}\""))
        .pipe($.htmlmin(collapseWhitespace: true))
        .pipe(gulp.dest(paths.dist.dest.html))

    gulp.src([paths.dist.src.cssComponents, paths.dist.src.css])
        .pipe($.concat('app.min.css'))
        .pipe($.cssmin())
        .pipe(gulp.dest(paths.dist.dest.css))

    gulp.src([paths.dist.src.jsComponents, paths.dist.src.js])
        .pipe($.concat('app.min.js'))
        .pipe($.ngmin())
        .pipe($.stripDebug())
        .pipe($.uglify(mangle: false))
        .pipe(gulp.dest(paths.dist.dest.js))

    gulp.src(paths.dist.src.images)
        .pipe(gulp.dest(paths.dist.dest.images))

    gulp.src(paths.dist.src.fonts)
        .pipe(gulp.dest(paths.dist.dest.fonts))


gulp.task 'open', ['default'], ->
    require('open')("http://#{pkg.name}.dev/")


gulp.task 'deploy', ['dist'], ->
    s3options =
        key: process.env.AWS_ACCESS_KEY_ID
        secret: process.env.AWS_SECRET_ACCESS_KEY
        bucket: "#{pkg.name}.antistatic.io"
    setTimeout ->
        gulp.src('dist/**/*')
           .pipe($.s3(s3options))
    , 2000
