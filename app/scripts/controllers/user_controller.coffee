this.adminApp.controller 'UserCtrl', [
    '$scope'
    '$location'
    'ApiService'
    ($scope, $location, ApiService) ->
        ApiService.get(1)
]