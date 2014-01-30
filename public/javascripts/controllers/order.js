(function() {
  "use strict";
  angular.module('ciphering.controllers.order', []).controller('OrderController', [
    '$scope', '$stateParams', '$filter', 'ngStorage', 'ringsizes', 'materials', 'pixeldigits', 'backendBaseURL', function($scope, $stateParams, $filter, ngStorage, ringsizes, materials, pixeldigits, backendBaseURL) {
      $scope.order = ngStorage.get('order') || {
        digits: '12.07',
        initials1: 'AB',
        initials2: 'CD'
      };
      $scope.$watchCollection('order', function(newValue, oldValue) {
        return ngStorage.set('order', newValue);
      });
      $scope.pixelgrid = [[1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1], [1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1], [1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1], [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1], [1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1]];
      ringsizes.getData(function(data) {
        $scope.ringsizeChoices = data;
        return $scope.order.ringsize = $filter('filter')(data, function(r) {
          return r.diameter === parseFloat(ngStorage.get('ringsize'));
        })[0] || data[0];
      });
      materials.getData(function(data) {
        $scope.materialChoices = data;
        return $scope.order.material = $filter('filter')(data, function(m) {
          return m.materialId === ngStorage.get('material');
        })[0] || data[0];
      });
      $scope.$watch('order.digits', function(newValue, oldValue) {
        var digit, filler, i, j, n, row, _i, _j, _k, _l, _ref, _ref1, _ref2, _ref3, _ref4, _results;
        for (i = _i = 0, _ref = $scope.pixelgrid.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          $scope.pixelgrid[i] = [];
        }
        if ((_ref1 = $scope.order.digits) != null ? _ref1.length : void 0) {
          for (i = _j = 0, _ref2 = $scope.order.digits.length - 1; 0 <= _ref2 ? _j <= _ref2 : _j >= _ref2; i = 0 <= _ref2 ? ++_j : --_j) {
            digit = $scope.order.digits[i];
            for (j = _k = 0, _ref3 = pixeldigits[digit].length - 1; 0 <= _ref3 ? _k <= _ref3 : _k >= _ref3; j = 0 <= _ref3 ? ++_k : --_k) {
              row = pixeldigits[digit][j];
              $scope.pixelgrid[j] = $scope.pixelgrid[j].concat(row);
              if (i < 4) {
                $scope.pixelgrid[j].push(0);
              }
            }
          }
        }
        _results = [];
        for (i = _l = 0, _ref4 = $scope.pixelgrid.length - 1; 0 <= _ref4 ? _l <= _ref4 : _l >= _ref4; i = 0 <= _ref4 ? ++_l : --_l) {
          if ($scope.pixelgrid[i].length < 17) {
            filler = (function() {
              var _m, _ref5, _results1;
              _results1 = [];
              for (n = _m = 1, _ref5 = 17 - $scope.pixelgrid[i].length; 1 <= _ref5 ? _m <= _ref5 : _m >= _ref5; n = 1 <= _ref5 ? ++_m : --_m) {
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
      return $scope.createOrder = function(order) {
        var param;
        param = {
          ringRadius: order.ringsize.circumference / (Math.PI * 2),
          pattern: $scope.pixelgrid,
          initials1: order.initials1,
          initials2: order.initials2
        };
        return location.href = "" + backendBaseURL + "/products/create/?param=" + (encodeURIComponent(JSON.stringify(param))) + "&digits=" + order.digits + "&ringsize=" + order.ringsize.diameter + "&material=" + (parseInt(order.material.materialId, 10)) + "&email=" + (encodeURIComponent(order.email));
      };
    }
  ]).controller('OrderWaitingController', [
    '$scope', '$stateParams', '$state', '$interval', '$http', 'backendBaseURL', function($scope, $stateParams, $state, $interval, $http, backendBaseURL) {
      var checkStatus, i;
      if (!$stateParams.orderId) {
        $state.transitionTo('order');
        return;
      }
      $scope.status = {
        status: 'waiting',
        description: 'Waiting for response from server …'
      };
      $scope.polling = true;
      $scope.lastChecked = null;
      checkStatus = function() {
        return $http.get("" + backendBaseURL + "/products/order-status/" + $stateParams.orderId + "/").success(function(data) {
          var _ref;
          $scope.status = data;
          $scope.lastChecked = new Date();
          if ((_ref = data.status) === 'notified' || _ref === 'failed' || _ref === 'not-found') {
            $interval.cancel(i);
            $scope.polling = false;
          }
          if (data.shapeways_url) {
            return location.href = data.shapeways_url;
          }
        });
      };
      checkStatus();
      return i = $interval(checkStatus, 2000, 500);
    }
  ]);

}).call(this);
