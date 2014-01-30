"use strict"


angular
    .module('ciphering.controllers.order', [])

    .controller('OrderController', ['$scope', '$stateParams', '$filter', 'ngStorage', 'ringsizes', 'materials', 'pixeldigits', 'backendBaseURL', ($scope, $stateParams, $filter, ngStorage, ringsizes, materials, pixeldigits, backendBaseURL) ->
        $scope.order = ngStorage.get('order') or
            digits: '12.07'
            initials1: 'AB'
            initials2: 'CD'

        $scope.$watchCollection 'order', (newValue, oldValue) ->
            ngStorage.set('order', newValue)

        $scope.pixelgrid = [
            [1,1,1,0,1,1,1,0,0,0,1,1,1,0,1,1,1],
            [1,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0,1],
            [1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1],
            [1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,0,1],
            [1,1,1,0,1,1,1,0,1,0,1,1,1,0,0,0,1]
        ]

        ringsizes.getData (data) ->
            $scope.ringsizeChoices = data
            $scope.order.ringsize = $filter('filter')(data, (r) -> r.diameter == parseFloat(ngStorage.get('ringsize')))[0] or data[0]

        materials.getData (data) ->
            $scope.materialChoices = data
            $scope.order.material = $filter('filter')(data, (m) -> m.materialId == ngStorage.get('material'))[0] or data[0]

        $scope.$watch 'order.digits', (newValue, oldValue) ->
            # reset the pixelgrid
            for i in [0..$scope.pixelgrid.length-1]
                $scope.pixelgrid[i] = []

            # append the digits row by row
            if $scope.order.digits?.length
                for i in [0..$scope.order.digits.length-1]
                    digit = $scope.order.digits[i]
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

        $scope.createOrder = (order) ->
            param =
                ringRadius: order.ringsize.circumference/(Math.PI*2)
                pattern: $scope.pixelgrid
                initials1: order.initials1
                initials2: order.initials2

            location.href = "#{backendBaseURL}/products/create/?param=#{encodeURIComponent(JSON.stringify(param))}&digits=#{order.digits}&ringsize=#{order.ringsize.diameter}&material=#{parseInt(order.material.materialId, 10)}&email=#{encodeURIComponent(order.email)}"
    ])

    .controller('OrderWaitingController', ['$scope', '$stateParams', '$state', '$interval', '$http', 'backendBaseURL', ($scope, $stateParams, $state, $interval, $http, backendBaseURL) ->
        if not $stateParams.orderId
            $state.transitionTo 'order'
            return

        $scope.status = status: 'waiting', description: 'Waiting for response from server …'
        $scope.polling = true
        $scope.lastChecked = null

        checkStatus = ->
            $http.get("#{backendBaseURL}/products/order-status/#{$stateParams.orderId}/").success (data) ->
                $scope.status = data
                $scope.lastChecked = new Date()
                if data.status in ['notified', 'failed', 'not-found']
                    $interval.cancel(i)
                    $scope.polling = false
                if data.shapeways_url
                    location.href = data.shapeways_url

        checkStatus()
        i = $interval checkStatus, 2000, 500
    ])
