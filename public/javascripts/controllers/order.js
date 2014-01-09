(function() {
  "use strict";
  angular.module('ciphering.controllers.order', []).controller('OrderController', [
    '$scope', '$stateParams', '$filter', 'ngStorage', 'ringsizes', 'materials', 'pixeldigits', function($scope, $stateParams, $filter, ngStorage, ringsizes, materials, pixeldigits) {
      $scope.digits = ngStorage.get('digits') || '12.34';
      $scope.pixelgrid = [[1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1], [1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1], [1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1], [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1], [1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1]];
      ringsizes.getData(function(data) {
        $scope.ringsizeChoices = data;
        return $scope.ringsize = $filter('filter')(data, function(r) {
          return r.diameter === parseFloat(ngStorage.get('ringsize'));
        })[0] || data[0];
      });
      materials.getData(function(data) {
        $scope.materialChoices = data;
        return $scope.material = $filter('filter')(data, function(m) {
          return m.materialId === ngStorage.get('material');
        })[0] || data[0];
      });
      $scope.$watch('digits', function(newValue, oldValue) {
        var digit, filler, i, j, n, ok, row, _i, _j, _k, _l, _ref, _ref1, _ref2, _ref3, _results;
        ok = (function() {
          switch (newValue.length) {
            case 0:
              return true;
            case 1:
            case 2:
              return newValue.match(/^\d+$/);
            case 3:
              return newValue.match(/^\d{2}\.$/);
            case 4:
            case 5:
              return newValue.match(/^\d{2}\.\d+$/);
            case 6:
              return false;
          }
        })();
        if (!ok) {
          $scope.digits = oldValue;
        }
        if ($scope.digits.length === 2 && oldValue.length !== 3) {
          $scope.digits = $scope.digits + '.';
        }
        for (i = _i = 0, _ref = $scope.pixelgrid.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          $scope.pixelgrid[i] = [];
        }
        if ($scope.digits.length) {
          for (i = _j = 0, _ref1 = $scope.digits.length - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
            digit = $scope.digits[i];
            for (j = _k = 0, _ref2 = pixeldigits[digit].length - 1; 0 <= _ref2 ? _k <= _ref2 : _k >= _ref2; j = 0 <= _ref2 ? ++_k : --_k) {
              row = pixeldigits[digit][j];
              $scope.pixelgrid[j] = $scope.pixelgrid[j].concat(row);
              if (i < 4) {
                $scope.pixelgrid[j].push(0);
              }
            }
          }
        }
        _results = [];
        for (i = _l = 0, _ref3 = $scope.pixelgrid.length - 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; i = 0 <= _ref3 ? ++_l : --_l) {
          if ($scope.pixelgrid[i].length < 17) {
            filler = (function() {
              var _m, _ref4, _results1;
              _results1 = [];
              for (n = _m = 1, _ref4 = 17 - $scope.pixelgrid[i].length; 1 <= _ref4 ? _m <= _ref4 : _m >= _ref4; n = 1 <= _ref4 ? ++_m : --_m) {
                _results1.push(0);
              }
              return _results1;
            })();
            _results.push($scope.pixelgrid[i] = $scope.pixelgrid[i].concat(filler));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      $scope.$watchCollection('[digits,ringsize,material]', function(newValues, oldValues) {
        if (newValues[0]) {
          ngStorage.set('digits', newValues[0]);
        }
        if (newValues[1]) {
          ngStorage.set('ringsize', newValues[1].diameter);
        }
        if (newValues[2]) {
          return ngStorage.set('material', newValues[2].materialId);
        }
      });
      $scope.$watchCollection('[ringsize,pixelgrid,material,digits]', function(newValues, oldValues) {
        return $scope.parameters = {
          ringRadius: newValues[0] ? newValues[0].circumference / (Math.PI * 2) : void 0,
          pattern: newValues[1] ? newValues[1] : void 0,
          material: newValues[2] ? parseInt(newValues[2].materialId, 10) : void 0,
          digits: newValues[3] ? newValues[3] : void 0
        };
      });
      return $scope.create = function() {
        return location.href = 'http://ciphering-backend.pbsit.es/products/create/?param=' + encodeURIComponent(JSON.stringify($scope.parameters));
      };
    }
  ]);

}).call(this);
