
initDataList = ($scope, $routeParams, CrudService) ->
  $scope.target = $routeParams.target
  CrudService.list $scope.target + '/list'
  return

removeHandler = ($scope, CrudService) ->

  $scope.remove = (id, dataTableCallback) ->
    if confirm('确定要删除该行数据？')
      removeUrl = $scope.target + '/remove/' + id
      CrudService.remove removeUrl, dataTableCallback
    return

  return

addAndBatchRemoveBtnHandler = ($scope, $routeParams, $location, CrudService) ->

  $scope.addBtnClick = ->
    $location.path $routeParams.target + '/add'
    return

  $scope.batchRemoveBtnClick = ->
    ids = $scope.getSelected()
    if ids
      url = $routeParams.target + '/multi-remove/' + ids
      CrudService.batchRemove url
    else
      alert '请至少选择一行数据'
    return

  return


initDetailPage = ($scope, $routeParams, CrudService) ->
  if $routeParams and $routeParams.id
    getUrl = $routeParams.target + '/' + $routeParams.id
    CrudService.get getUrl
    $scope.update = true
    $scope.$on 'entity.got', (event, data) ->
      $scope.entity = data
      return
  else
    $scope.entity = {}
    $scope.update = false
  return


saveHandler = ($scope, $routeParams, CrudService) ->

  $scope.saveData = ->
    target = $routeParams.target
    saveUrl = target + '/add'
    if $scope.update
      saveUrl = target + '/update'
    CrudService.save saveUrl, $scope.entity
    return

  return


backToListAfterSaved = ($scope, $routeParams, $location, CrudService) ->
  $scope.$on 'data.saveSuccess', (event) ->
    $location.path $routeParams.target + '/list'
    return
  return


### BaseControllers ###


this.adminApp.controller 'ListCtrl', [
  '$scope'
  '$routeParams'
  '$location'
  'CrudService'
  ($scope, $routeParams, $location, CrudService) ->
    initDataList $scope, $routeParams, CrudService
    removeHandler $scope, CrudService
    addAndBatchRemoveBtnHandler $scope, $routeParams, $location, CrudService
    return
]


this.adminApp.controller 'DetailCtrl', [
  '$scope'
  '$routeParams'
  '$location'
  'CrudService'
  ($scope, $routeParams, $location, CrudService) ->
    initDetailPage $scope, $routeParams, CrudService
    saveHandler $scope, $routeParams, CrudService
    backToListAfterSaved $scope, $routeParams, $location, CrudService
    return
]
