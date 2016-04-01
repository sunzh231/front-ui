'use strict'
# Declare app level module which depends on views, and components
exports = this

exports.adminApp = angular.module('adminApp', [ 'ngRoute', 'ngResource' ])

exports.adminApp.config [
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider.when('/:target/list',
      controller: 'UserCtrl'
      templateUrl: (params) ->
        'assets/views/' + params.target + '/list.html'
    ).when('/:target/add',
      controller: 'DetailCtrl'
      templateUrl: (params) ->
        'assets/views/' + params.target + '/detail.html'
    ).when('/:target/edit/:id',
      controller: 'DetailCtrl'
      templateUrl: (params) ->
        'assets/views/' + params.target + '/detail.html'
    ).otherwise
      redirectTo: '/dashboard'
      controller: 'MainCtrl'
      templateUrl: (params) ->
        'assets/views/main.html'
    return
]
