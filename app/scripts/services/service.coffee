'use strict'

### Service ###

this.adminApp.service 'CrudService', [
  '$rootScope'
  '$http'
  ($rootScope, $http) ->
    service =
      list: (url) ->
        $rootScope.entities = []
        $http.post(url).success (data) ->
          if data
            $rootScope.$broadcast 'data.list', data
            $rootScope.entities = data
          return
        return
      get: (url) ->
        $http.get(url).success (data) ->
          if data and data.success
            $rootScope.$broadcast 'entity.got', data.data
          else
            alert data.data
          return
        return
      remove: (url, callback) ->
        $http.get(url).success (data) ->
          if data and data.success
            callback()
            alert '删除成功!'
          return
        return
      batchRemove: (url) ->
        $http.get(url).success (data) ->
          if data and data.success
            $rootScope.$broadcast 'data.batchRemove'
            alert '批量删除成功！'
          return
        return
      save: (url, entity) ->
        $http.post(url, entity).success (data) ->
          if data and data.success
            alert '数据添加成功！'
            entity = null
            $rootScope.$broadcast 'data.saveSuccess', data
          else
            alert if '数据添加出错,错误原因为：' + data and data.data then data.data else '未知'
          return
        return
      update: (url) ->
        $http.post(url).success (data) ->
          if data and data.success
            alert '数据编辑成功！'
            $rootScope.$broadcast 'data.saveSuccess'
          else
            alert if '数据编辑出错,错误原因为：' + data and data.data then data.data else '未知'
          return
        return
      removeFile: (filename) ->
        #删除文件
        $http.post('/fileupload/remove', filename).success (data) ->
          if data.success
            alert '文件删除成功！'
          else
            if data.msg
              alert data.msg
            else
              alert '服务器内部错误！请稍后重试'
          return
        return
    service
]

### 用户管理相关service ###

this.adminApp.service 'UserService', [
  '$rootScope'
  '$http'
  ($rootScope, $http) ->
    service =
      listParents: (type) ->
        $http.post('/user/parent/' + type).success (data) ->
          if data
            #$rootScope.$broadcast('parent.got', data);
            $rootScope.parents = data
          return
        return
      listHierarchy: ->
        $http.post('/user/hierarchy').success (data) ->
          $rootScope.$broadcast 'treeData.got', data
          return
        return
      checkExisted: (userId) ->
        $http.post('/user/' + userId).success (data) ->
          if data.success
            if data.data != null
              alert '该用户ID已存在，请改用其他名称'
            else
              alert '该用户ID可以使用！'
          else
            alert data.data
          return
        return
    service
]

### 权限认证相关操作 ###

this.adminApp.service 'CheckService', [
  '$rootScope'
  '$http'
  ($rootScope, $http) ->
    service = check: ->
      $http.post('/authenticate').success (data) ->
        if data
          $rootScope.$broadcast 'authenticated', data
        return
      return
    service
]
