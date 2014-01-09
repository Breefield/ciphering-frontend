"use strict"

angular
    .module('ciphering.services.materials', [])

    .factory('materials', ['$resource', ($resource) ->
        $resource '/data/materials.json', null,
            getData:
                method: 'GET'
                isArray: true
    ])
