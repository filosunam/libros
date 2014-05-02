'use strict';

var requirejs = require('requirejs');

requirejs.config({
  nodeRequire: require,
  baseUrl: __dirname + '/app'
});

requirejs([
  'conf',
  'express',
  'execSync',
  'fs',
  'crypto'
], function (
  conf,
  express,
  sh,
  fs,
  crypto
) {

  var app         = module.exports = express(),
      session     = require("express-session"),
      MongoStore  = require('connect-mongo')({ session: session });


  // Variables
  app.set('port', process.env.PORT || conf.port);

  // Middlewares
  app.use(require('body-parser')());
  app.use(require('cookie-parser')());
  app.use(require('method-override')());
  app.use(require('connect-multiparty')());

  // Compile less files
  app.use(require('less-middleware')(__dirname + '/public'));

  // Set view engine for main file
  app.set('layout', 'layout');
  app.set('view engine', 'hjs');
  app.engine('hjs', require('mmm').__express);
  app.set('views', __dirname + '/public');

  // Static files
  app.use(express.static(__dirname + '/public'));

  // Create directories needed
  if (!fs.existsSync("./public/uploads")) {
    fs.mkdirSync('./public/uploads');
    fs.mkdirSync('./public/uploads/xml');
    fs.mkdirSync('./public/uploads/epub');
    fs.mkdirSync('./public/uploads/docx');
  }

  // Development
  if ('development' === app.get('env')) {
    // Sessions
    app.use(session({
      secret: conf.session.secret,
      cookie: { maxAge: conf.session.maxAge }
    }));

    // Logger
    app.use(require('morgan')('dev'));
    app.use(require('errorhandler')());

    // Disable cache
    app.disable('view cache');

    // Disable etag
    app.disable('etag');
  }

  // Production
  if ('production' === app.get('env')) {
    // Sessions
    app.use(session({
      secret: conf.session.secret,
      cookie: { maxAge: conf.session.maxAge },
      store: new MongoStore({ url: conf.mongo.url })
    }));

    // Logger
    app.use(require('morgan')());

    // Enable cache
    app.enable('view cache');

    // Csrf token
    app.use(require('csurf')());
    app.use(function (req, res, next) {
      var csrf = req.csrfToken();
      res.setHeader('X-CSRF-Token', csrf);
      res.locals.csrf = csrf;
      next();
    });
  }

  // route: /
  app.route('/').get(function(req, res, next) {
    res.render('index');
  });

  // route: /upload
  app.route('/upload').post(function(req, res, next) {
    
    // Get file info
    var file = req.files.file;
    
    if (!file.path.match(/(?:docx)$/)) {
      res.send(500);
    }

    // Simulate MongoID
    var filename = crypto.createHash('md5').update(Math.random().toString()).digest('hex').substring(0, 24);

    // Save docx file
    fs.writeFile('./public/uploads/docx/' + filename + '.docx', fs.readFileSync(file.path));

    // Execute "docxtotei"
    var docxtotei = sh.exec('./Stylesheets/bin/docxtotei --profile=../../xsl ' + file.path + ' ./public/uploads/xml/' + filename + '.xml');
    
    if (!docxtotei.stderr) {
    
      // Execute "teitoepub3"
      var teitoepub = sh.exec('./Stylesheets/bin/teitoepub3 --profile=../../xsl ./public/uploads/xml/' + filename + '.xml ./public/uploads/epub/' + filename + '.epub');
      
      if (!teitoepub.stderr) {

        res.download('./public/uploads/epub/' + filename + '.epub');

        // TODO: Save document (MongoDB)
        // ...

      }
    
    }

  });

  // Listen
  app.listen(app.get('port'), function () {
    console.log('Listen server on port', app.get('port'));
  })

});
