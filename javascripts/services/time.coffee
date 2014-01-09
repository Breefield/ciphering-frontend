"use strict"

angular
    .module('boilerplate.services.time', [])

    .factory('time', ->
        current: -> new Date()
    )
