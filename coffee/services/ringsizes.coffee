"use strict"

angular
    .module('ciphering.services.ringsizes', [])

    .factory 'ringsizes', ($resource, backendBaseURL) ->
        $resource "#{backendBaseURL}/ringsizes/", null,
            getData:
                method: 'GET'
                isArray: true
