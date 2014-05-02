'use strict';

define(['underscore'], function (_) {

  var environment,
      defaults,
      development,
      production;

  defaults = {
    port: 3000,
    session: {
      secret: 'P=~g8+Cf{Lz&HO,P',
      maxAge: 1800000
    },
    mongo : {
      user : '',
      pass : '',
      host : 'localhost',
      port : 27017,
      db   : 'we2book',
      url  : 'mongodb://localhost:27017/we2book'
    }
  };

  development = _.defaults({}, defaults);

  production = _.defaults({}, defaults);


  if ('production' === process.env.NODE_ENV) {
    environment = production;
  } else {
    environment = development;
  }

  return environment;

});
