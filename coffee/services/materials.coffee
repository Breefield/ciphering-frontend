"use strict"

angular
    .module('ciphering.services.materials', [])

    .factory 'materials', ($resource, backendBaseURL) ->
        $resource "#{backendBaseURL}/materials/", null,
            getData:
                method: 'GET'
                isArray: true
