"use strict"

angular
    .module('ciphering.services.materials', [])

    .factory 'materials', ->
        materials = [{
            "materialId": "54",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/silver_glossy.jpg",
            "title": "Polished Silver",
            "estimatedPrice": 35
          }, {
            "materialId": "81",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-premium-silver-20130925.jpg",
            "title": "Premium Silver",
            "estimatedPrice": 45
          }, {
            "materialId": "87",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-polished-bronze-20140702.png",
            "title": "Polished Bronze",
            "estimatedPrice": 20
          }, {
            "materialId": "91",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-14k-gold-20140702.png",
            "title": "14K Gold",
            "estimatedPrice": 195
          }, {
            "materialId": "96",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-rose-gold-20140702.png",
            "title": "14k Rose Gold",
            "estimatedPrice": 195
          }, {
            "materialId": "97",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-white-gold-20140702.png",
            "title": "14k White Gold",
            "estimatedPrice": 195
          }, {
            "materialId": "98",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-18k-gold-20140702.png",
            "title": "18k Gold",
            "estimatedPrice": 290
          }, {
            "materialId": "99",
            "swatch": "https://static1.sw-cdn.net/rrstatic/img/materials/swatch-platinum-20140702.png",
            "title": "Platinum",
            "estimatedPrice": 530
          }]
        
        getData: (cb) ->
          cb(materials)
