(function() {
  "use strict";
  angular.module('ciphering.services.ringsizes', []).factory('ringsizes', [
    '$resource', function($resource) {
      return $resource('/data/ringsizes.json', null, {
        getData: {
          method: 'GET',
          isArray: true
        }
      });
    }
  ]);

}).call(this);
