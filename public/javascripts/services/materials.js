(function() {
  "use strict";
  angular.module('ciphering.services.materials', []).factory('materials', [
    '$resource', function($resource) {
      return $resource('/data/materials.json', null, {
        getData: {
          method: 'GET',
          isArray: true
        }
      });
    }
  ]);

}).call(this);
