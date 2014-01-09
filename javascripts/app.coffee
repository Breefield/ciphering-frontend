"use strict"

angular
    .module('ciphering', [
        'ui.router',
        'ciphering.controllers',
        'ciphering.services'
    ])

    .config(['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->
        $urlRouterProvider.otherwise('/')
        $locationProvider.html5Mode(true)

        $stateProvider.state 'home',
            url: '/'
            views:
                main:
                    templateUrl: 'partials/home.html'
                    controller: 'HomeController'
    ])


angular
    .module('ciphering.controllers', [
        'ciphering.controllers.main',
        'ciphering.controllers.home',
    ])


angular
    .module('ciphering.services', [
        'ciphering.services.time',
    ])
