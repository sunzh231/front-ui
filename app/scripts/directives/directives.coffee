'use strict'

### Directives ###

this.adminApp.directive 'pageTable', [
  '$location'
  ($location) ->
    {
      restrict: 'E, A, C'
      link: (scope, element, attrs, controller) ->
        # apply DataTable options, use defaults if none specified by admin
        options = 
          'iCookieDuration': 2419200
          'bJQueryUI': true
          'bPaginate': true
          'sPaginationType': 'full_numbers'
          'bLengthChange': true
          'bFilter': true
          'bInfo': false
          'bSort': true
          'bDestroy': true
          'oLanguage':
            'sLengthMenu': '每页显示 _MENU_ 条记录'
            'sZeroRecords': '对不起，没有符合条件的记录！'
            'sSearch': '查询'
            'oPaginate':
              'sPrevious': '上一页'
              'sNext': '下一页'
              'sFirst': '首页'
              'sLast': '末页'
        explicitColumns = []
        element.find('th').each (index, elem) ->
          if $(elem).attr('field')
            colInfo = 
              'mData': $(elem).attr('field')
              'bSortable': true
            explicitColumns.push colInfo
          else if $(elem).attr('checked')
            #如果指定了checked属性，渲染为复选框，复选框的值为id
            explicitColumns.push
              'mData': 'id'
              'bSortable': false
              'mRender': (data, type, full) ->
                '<input type="checkbox" class="chk" name=ids value=' + data + '>'
          return
        explicitColumns.push
          'mData': 'id'
          'bSortable': false
          'mRender': (data, type, full) ->
            '<a class="edit-btn" href="#' + scope.target + '/edit/' + data + '"><i class="icon-edit"></i></a>&nbsp;&nbsp;&nbsp;&nbsp;' + '<a class="remove-btn" href="javascript:void(0);" attr=' + data + '><i class="icon-trash"></i></a>'
        options['aoColumns'] = explicitColumns
        # apply the plugin
        #var dataTable = element.dataTable(options);
        dataTable = element.DataTable(options)
        $('.remove-btn').off 'click'
        $('.remove-btn').on 'click', ->
          id = $(this).attr('attr')
          trNode = @parentNode.parentNode
          scope.remove id, ->
            dataTable.fnDeleteRow trNode
            return
          return
        #获取选择的行的ID，以逗号分隔的字符串返回

        scope.getSelected = ->
          idArr = []
          $('input', dataTable.fnGetNodes()).each ->
            if @checked
              idArr.push @value
            return
          idArr.join ','

        scope.refresh = ->
          dataTable.fnClearTable()
          dataTable.fnAddData scope.$eval(attrs.aaData)
          return

        #删除选择的多行，用于多行删除成功后
        scope.$on 'data.batchRemove', ->
          $('input', dataTable.fnGetNodes()).each ->
            if @checked
              dataTable.fnDeleteRow @parentNode.parentNode
            return
          return
        $('select[name="dt_length"]').select2()
        scope.$watch attrs.aaData, (value) ->
          val = value or null
          if val
            if scope.dataPreHandler
              scope.dataPreHandler()
            dataTable.fnClearTable()
            dataTable.fnAddData scope.$eval(attrs.aaData)
          return
        return

    }
]


this.adminApp.directive 'select2', ->
{
    restrict: 'E, A, C'
    link: ->
      $('select').select2()
      return

}


this.adminApp.directive 'hasPermission', (permissions) ->
  { link: (scope, element, attrs) ->

    toggleVisibilityBasedOnPermission = ->
      hasPermission = permissions.hasPermission(value)
      if hasPermission and !notPermissionFlag or !hasPermission and notPermissionFlag
        element.show()
      else
        element.hide()
      return

    if !_.isString(attrs.hasPermission)
      throw 'hasPermission value must be a string'
    value = attrs.hasPermission.trim()
    notPermissionFlag = value[0] == '!'
    if notPermissionFlag
      value = value.slice(1).trim()
    toggleVisibilityBasedOnPermission()
    scope.$on 'permissionsChanged', toggleVisibilityBasedOnPermission
    return
 }

###
# 上传按钮
# 主要完成整合jquery file upload控件实现相应的操作
###

this.adminApp.directive 'fileuploadBtn', [
  '$location'
  'CrudService'
  '$parse'
  ($location, CrudService, $parse) ->
    {
      restrict: 'A'
      link: (scope, element, attrs) ->
        element.uniform()
        uploadBtn = $('<button/>').text('开始上传').attr('type', 'button').attr('class', 'btn btn-mini')
        removeBtn = $('<button/>').text('删除文件').attr('type', 'button').attr('class', 'btn btn-mini')
        #uniform控件将input[file]包装了一层
        uploadBtn.appendTo $(element).parent().parent()
        removeBtn.appendTo $(element).parent().parent()
        path = ''
        #删除按钮处理方法
        $(removeBtn).click ->
          CrudService.removeFile path
          return
        #构造上传url
        type = attrs.ftype
        url = '/fileupload/upload/'
        if type != null
          url += type
        else
          url += 'img'
        #初始化fileupload控件
        $(element).fileupload
          url: url
          dataType: 'json'
          previewMaxWidth: 100
          previewMaxHeight: 100
          previewCrop: true
          add: (e, data) ->
            uploadBtn.click ->
              uploadBtn.text '正在上传...'
              data.submit()
              return
            return
          change: (e, data) ->
            $('tr:has(td)').remove()

            ###  $.each(data.result, function (index, file) {
               console.log(file);

              });
            ###

            ### if($('#img-preview') == undefined){
               return ;
             }

             $('#img-preview').empty();
             data.context = $('<li class="span2"/>').appendTo('#img-preview');
            ###

            $.each data.files, (index, file) ->
              #if()
              $('#uploaded-files').show()
              $('#uploaded-files').append $('<tr/>').append($('<td/>').text(file.name)).append($('<td/>').text(file.size + 'kB')).append($('<td/>').text(file.type)).append($('<td/>').html('<a href=\'/fileupload/upload/img' + index + '\'>Click</a>'))
              #end $("#uploaded-files").append()
              return
            return
          done: (e, data) ->
            if data._response.result.success
              uploadBtn.text '已上传'
              if path != undefined and path.length > 0
                path += ','
              path += data._response.result.data
              setTimeout (->
                scope.$apply ->
                  $parse(attrs.fileuploadBtn).assign scope, path
                  return
                return
              ), 50

              ###path="";###

              return
            else
              uploadBtn.text '重新上传'
            return
          drop: (e, data) ->
            $.each data.files, (index, file) ->
              alert 'Dropped file: ' + file.name
              return
            return
          progressall: (e, data) ->
            progress = parseInt(data.loaded / data.total * 100, 10)
            $('#progress .bar').css 'width', progress + '%'
            return
          dropZone: $('#dropzone')
        return

    }
]


this.adminApp.directive 'ckeditor', ->
{
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->
      ckeditor = CKEDITOR.replace(element[0], {})
      if !ngModel
        return
      ckeditor.on 'instanceReady', ->
        ckeditor.setData ngModel.$viewValue
        return
      ckeditor.on 'pasteState', ->
        scope.$apply ->
          ngModel.$setViewValue ckeditor.getData()
          return
        return

      ngModel.$render = (value) ->
        ckeditor.setData ngModel.$viewValue
        return

      return

}


this.adminApp.directive 'menuLink', ->
{
    restrict: 'A'
    link: (scope, element) ->
      $(element).click ->
        #先删除父节点原有class为'active'的节点的class属性
        container = $(element).parent().parent()
        $(container).find('.active').each ->
          $(this).removeClass 'active'
          return
        #当前节点添加'active'class
        $(element).parent().addClass 'active'
        return
      return

}


this.adminApp.directive 'tabLink', ->
{
    restrict: 'A'
    link: (scope, element, attrs) ->
      $(element).click ->
        id = '#' + attrs.tabLink
        $(id).parent().find('.active').each ->
          $(this).removeClass 'active'
          return
        $(id).addClass 'active'
        return
      return

}
this.adminApp.directive 'bsPopup', ($parse) ->
{
    require: 'ngModel'
    restrict: 'A'
    link: (scope, elem, attrs, ctrl) ->
      scope.$watch (->
        $parse(ctrl.$modelValue) scope
      ), (newValue) ->
        if newValue == 0
          $(elem).modal 'hide'
          return
        if newValue == 1
          $(elem).modal 'show'
          return
        return
      return

}

