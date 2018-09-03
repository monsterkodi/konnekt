###
00     00  000   0000000   0000000
000   000  000  000       000     
000000000  000  0000000   000     
000 0 000  000       000  000     
000   000  000  0000000    0000000
###

toggleFullscreen = ->
    
    fs = document.fullscreenElement or document.webkitFullscreenElement or document.mozFullScreenElement
    
    if fs
        menu.buttons['fullscreen'].innerHTML = 'FULLSCREEN'
        efs = document.exitFullscreen or document.webkitExitFullscreen or document.mozCancelFullScreen
        efs.call document
    else
        menu.buttons['fullscreen'].innerHTML = 'WINDOWED'
        el = document.documentElement
        rfs = el.requestFullscreen or el.webkitRequestFullScreen or el.mozRequestFullScreen or el.msRequestFullscreen 
        rfs.call el