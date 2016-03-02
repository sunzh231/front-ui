'use strict'
# Declare app level module which depends on views, and components
exports = this

exports.adminApp = angular.module('adminApp', [ 'ngRoute' ])

exports.adminApp.config [
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider.when('/datatables',
      controller: 'TableCtrl'
      templateUrl: (params) ->
        'app/views/tables/datatables.html'
    ).when('/timeline',
      controller: 'TableCtrl'
      templateUrl: (params) ->
        'app/views/UI/timeline.html'
    ).when('/calendar',
      controller: 'CalendarCtrl'
      templateUrl: (params) ->
        'app/views/calendar.html'
    ).when('/:target/list',
      controller: 'ListCtrl'
      templateUrl: (params) ->
        'admin/' + params.target + '/list.html'
    ).when('/:target/add',
      controller: 'DetailCtrl'
      templateUrl: (params) ->
        'admin/' + params.target + '/detail.html'
    ).when('/:target/edit/:id',
      controller: 'DetailCtrl'
      templateUrl: (params) ->
        'admin/' + params.target + '/detail.html'
    ).otherwise
      redirectTo: '/a/main'
      controller: 'MainCtrl'
      templateUrl: (params) ->
        'app/views/main.html'
    return
]
