"use strict"

angular
    .module('ciphering.controllers.home', [])

    .controller 'HomeController', ($scope, ngDialog) ->
        $scope.images = [
            {large: '/images/gallery/Ciphering.jpg',    thumb: '/images/gallery/thumbs/Ciphering.jpg',    video: false}
            {large: '/images/gallery/InHand_1.jpg',     thumb: '/images/gallery/thumbs/InHand_1.jpg',     video: false}
            {large: '/images/gallery/exampleVideo.mp4', thumb: '/images/gallery/thumbs/exampleVideo.jpg', video: true}
            {large: '/images/gallery/InHand_2.jpg',     thumb: '/images/gallery/thumbs/InHand_2.jpg',     video: false}
            {large: '/images/gallery/OnGlass_1.jpg',    thumb: '/images/gallery/thumbs/OnGlass_1.jpg',    video: false}
            {large: '/images/gallery/OnGlass_2.jpg',    thumb: '/images/gallery/thumbs/OnGlass_2.jpg',    video: false}
            {large: '/images/gallery/onFinger.jpg',     thumb: '/images/gallery/thumbs/onFinger.jpg',     video: false}
        ]
        $scope.selectedImage = $scope.images[0]

        $scope.openLightbox = (image) ->
            $scope.selectedImage = image
            ngDialog.open(
                template: 'partials/lightbox.html'
                className: 'ngdialog-theme-plain'
                scope: $scope
            )

        $scope.prevImage = ->
            i = $scope.images.indexOf($scope.selectedImage) - 1
            i = $scope.images.length-1 if i == -1
            $scope.selectedImage = $scope.images[i]

        $scope.nextImage = ->
            i = $scope.images.indexOf($scope.selectedImage) + 1
            i = 0 if i >= $scope.images.length
            $scope.selectedImage = $scope.images[i]
