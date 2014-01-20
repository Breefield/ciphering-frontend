"use strict"

angular
    .module('ciphering.controllers.order', [])

    .controller('OrderController', ['$scope', '$stateParams', '$filter', 'ngStorage', 'ringsizes', 'materials', 'pixeldigits', ($scope, $stateParams, $filter, ngStorage, ringsizes, materials, pixeldigits) ->
        $scope.digits = ngStorage.get('digits') or '12.34'
        $scope.initials1 = ngStorage.get('initials1') or 'AB'
        $scope.initials2 = ngStorage.get('initials2') or 'CD'
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

        initialsWatch = (key) ->
            (newValue, oldValue) ->
                return if !newValue?.length
                ok = newValue.match /^[a-zA-Z]{0,2}$/
                if not ok
                    $scope[key] = oldValue.trim()
                else
                    $scope[key] = newValue.toUpperCase().trim()

        $scope.$watch 'initials1', initialsWatch('initials1')
        $scope.$watch 'initials2', initialsWatch('initials2')

        $scope.$watchCollection '[digits,initials1,initials2,ringsize,material]', (newValues, oldValues) ->
            ngStorage.set 'digits', if newValues[0] then newValues[0] else ''
            ngStorage.set 'initials', if newValues[1] then newValues[1] else ''
            ngStorage.set 'initials', if newValues[2] then newValues[2] else ''
            ngStorage.set 'ringsize', newValues[3].diameter if newValues[3]
            ngStorage.set 'material', newValues[4].materialId if newValues[4]

        $scope.$watchCollection '[ringsize,pixelgrid,material,digits,initials1,initials2]', (newValues, oldValues) ->
            $scope.parameters =
                ringRadius: newValues[0].circumference/(Math.PI*2) if newValues[0]
                pattern: newValues[1] if newValues[1]
                material: parseInt(newValues[2].materialId,10) if newValues[2]
                digits: newValues[3] if newValues[3]
                initials1: newValues[4] if newValues[4]
                initials2: newValues[5] if newValues[5]

        $scope.create = ->
             location.href = 'http://ciphering-backend.pbsit.es/products/create/?param=' + encodeURIComponent(JSON.stringify($scope.parameters))
    ])
