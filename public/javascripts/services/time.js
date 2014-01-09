(function() {
  "use strict";
  angular.module('ciphering.services.time', []).factory('time', function() {
    return {
      current: function() {
        return new Date();
      }
    };
  });

}).call(this);
