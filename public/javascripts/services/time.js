(function() {
  "use strict";
  angular.module('boilerplate.services.time', []).factory('time', function() {
    return {
      current: function() {
        return new Date();
      }
    };
  });

}).call(this);
