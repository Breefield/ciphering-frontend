"use strict"

angular
    .module('ciphering', [
        'ui.router',
        'ngResource',
        'angular-storage',
        'ciphering.controllers',
        'ciphering.services'
    ])

    # .constant('backendBaseURL', 'http://localhost:5000')
    .constant('backendBaseURL', 'http://ciphering-backend.pbsit.es')

    .config(['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
        $urlRouterProvider.otherwise('/')
        # $locationProvider.html5Mode(true)

        console.log 'CONFIG'

        $stateProvider.state 'home',
            url: '/'
            templateUrl: 'partials/home.html'
            controller: 'HomeController'

        $stateProvider.state 'orderWaiting',
            url: '/order/:orderId'
            templateUrl: 'partials/order-waiting.html'
            controller: 'OrderWaitingController'
    ])


angular
    .module('ciphering.controllers', [
        'ciphering.controllers.main',
        'ciphering.controllers.home',
        'ciphering.controllers.order',
    ])


angular
    .module('ciphering.services', [
        'ciphering.services.materials',
        'ciphering.services.ringsizes',
        'ciphering.services.pixeldigits',
    ])
