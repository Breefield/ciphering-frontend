"use strict"

angular
    .module('ciphering.services.ringsizes', [])

    .factory('ringsizes', ['$resource', ($resource) ->
        $resource '/data/ringsizes.json', null,
            getData:
                method: 'GET'
                isArray: true
    ])
