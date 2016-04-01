'use strict'

this.adminApp.controller 'MainCtrl', [ ->
    $('#dragtarget').on 'dragstart', (event) ->
        console.log event
        event.dataTransfer.setData 'text', 'Hello World!'
        return
    return
]