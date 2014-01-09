"use strict"

angular
    .module('ciphering.controllers.order', [])

    .controller('OrderController', ['$scope', '$stateParams', '$filter', 'ngStorage', 'ringsizes', 'materials', 'pixeldigits', ($scope, $stateParams, $filter, ngStorage, ringsizes, materials, pixeldigits) ->
        $scope.digits = ngStorage.get('digits') or '12.34'
        $scope.pixelgrid = [
            [1,1,1,0,1,1,1,0,0,0,1,1,1,0,1,1,1],
            [1,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0,1],
            [1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1],
            [1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,1],
            [1,1,1,0,1,1,1,0,1,0,1,1,1,0,0,0,1]
        ]

        ringsizes.getData (data) ->
            $scope.ringsizeChoices = data
            $scope.ringsize = $filter('filter')(data, (r) -> r.diameter == parseFloat(ngStorage.get('ringsize')))[0] or data[0]

        materials.getData (data) ->
            $scope.materialChoices = data
            $scope.material = $filter('filter')(data, (m) -> m.materialId == ngStorage.get('material'))[0] or data[0]

        $scope.$watch 'digits', (newValue, oldValue) ->
            ok = switch newValue.length
                when 0 then true
                when 1,2 then newValue.match /^\d+$/
                when 3 then newValue.match /^\d{2}\.$/
                when 4,5 then newValue.match /^\d{2}\.\d+$/
                when 6 then false
            if not ok
                $scope.digits = oldValue
            if $scope.digits.length == 2 and oldValue.length != 3
                $scope.digits = $scope.digits + '.'

            # reset the pixelgrid
            for i in [0..$scope.pixelgrid.length-1]
                $scope.pixelgrid[i] = []

            # append the digits row by row
            if $scope.digits.length
                for i in [0..$scope.digits.length-1]
                    digit = $scope.digits[i]
                    for j in [0..pixeldigits[digit].length-1]
                        row = pixeldigits[digit][j]
                        $scope.pixelgrid[j] = $scope.pixelgrid[j].concat(row)
                        if i < 4 # 1px spacing between digits except for the last digit
                            $scope.pixelgrid[j].push(0)

            # fill up the rows with zeros
            for i in [0..$scope.pixelgrid.length-1]
                if $scope.pixelgrid[i].length < 17
                    filler = (0 for n in [1..17-$scope.pixelgrid[i].length])
                    $scope.pixelgrid[i] = $scope.pixelgrid[i].concat(filler)


        $scope.$watchCollection '[digits,ringsize,material]', (newValues, oldValues) ->
            ngStorage.set 'digits', newValues[0] if newValues[0]
            ngStorage.set 'ringsize', newValues[1].diameter if newValues[1]
            ngStorage.set 'material', newValues[2].materialId if newValues[2]

        $scope.$watchCollection '[ringsize,pixelgrid,material,digits]', (newValues, oldValues) ->
            $scope.parameters =
                ringRadius: newValues[0].circumference/(Math.PI*2) if newValues[0]
                pattern: newValues[1] if newValues[1]
                material: parseInt(newValues[2].materialId,10) if newValues[2]
                digits: newValues[3] if newValues[3]

        $scope.create = ->
             location.href = 'http://ciphering-backend.pbsit.es/products/create/?param=' + encodeURIComponent(JSON.stringify($scope.parameters))
    ])
