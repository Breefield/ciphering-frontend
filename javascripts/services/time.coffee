"use strict"

angular
    .module('ciphering.services.time', [])

    .factory('time', ->
        current: -> new Date()
    )
