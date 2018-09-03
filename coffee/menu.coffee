###
00     00  00000000  000   000  000   000    
000   000  000       0000  000  000   000    
000000000  0000000   000 0 000  000   000    
000 0 000  000       000  0000  000   000    
000   000  00000000  000   000   0000000     
###

onVol = (chce) ->
    switch chce
        when '+' then snd.volUp()
        when '-' then snd.volDown()
        
menuVolume = (vol) ->
    menu.buttons.VOL?.innerHTML = "#{floor(vol * 100) / 100}"

menus = 
    menu: [
        OPTIONS:
            click: -> showMenu 'options'
    ]
    game: [
        PAUSE:
            click: -> pause()
    ]
    options: [
        OPTIONS:
            click: -> showMenu 'menu'
    ,
        FULLSCREEN:
            click: -> toggleFullscreen()
    ,
        VOLUME:
            class:  'choice'
            values: ['-', 'VOL', '+']
            cb:     onVol
    ,
        'RESET PROGRESS':
            click: -> pref.clear(); forceLevel 'menu'
    ]
    pause: [
        UNPAUSE:
            click: -> pause()
    ,
        MENU:
            click: -> loadLevel 'menu'
    ,
        RESET:
            click: -> forceLevel world.level.name
    ,
        FULLSCREEN:
            click: -> toggleFullscreen()
    ,
        VOLUME:
            class:  'choice'
            values: ['-', 'VOL', '+'] 
            cb:     onVol
    ]
    next: [
        NEXT:
            click: -> loadNext()
    ,
        MENU:
            click: -> loadLevel 'menu'
    ,
        RESET:
            click: -> loadLevel world.level.name
    ]

#  0000000  000   000   0000000   000   000  
# 000       000   000  000   000  000 0 000  
# 0000000   000000000  000   000  000000000  
#      000  000   000  000   000  000   000  
# 0000000   000   000   0000000   00     00  

showMenu = (m) ->
    
    for k,v of menu.buttons
        if k[0] not in 'ub' # 'usr', 'bot'
            v.remove()
            delete menu.buttons[k]
    
    mnu = menus[m]
    for item in mnu
        name = Object.keys(item)[0]
        info = item[name]
        info.class ?= 'button'
        info.text ?= name
                
        if info.class == 'choice'
            choice info
        else
            menu.buttons[name] = elem 'div', info, menu.left
    
# 00000000  000   000  000      000       0000000   0000000  00000000   00000000  00000000  000   000  
# 000       000   000  000      000      000       000       000   000  000       000       0000  000  
# 000000    000   000  000      000      0000000   000       0000000    0000000   0000000   000 0 000  
# 000       000   000  000      000           000  000       000   000  000       000       000  0000  
# 000        0000000   0000000  0000000  0000000    0000000  000   000  00000000  00000000  000   000  

isFullscreen = -> document.fullscreenElement or document.webkitFullscreenElement or document.mozFullScreenElement

toggleFullscreen = ->
    
    if isFullscreen()
        menu.buttons['FULLSCREEN'].innerHTML = 'FULLSCREEN'
        efs = document.exitFullscreen or document.webkitExitFullscreen or document.mozCancelFullScreen
        efs.call document
    else
        menu.buttons['FULLSCREEN'].innerHTML = 'WINDOWED'
        el = document.documentElement
        rfs = el.requestFullscreen or el.webkitRequestFullScreen or el.mozRequestFullScreen or el.msRequestFullscreen 
        rfs.call el

# 00000000  000      00000000  00     00  
# 000       000      000       000   000  
# 0000000   000      0000000   000000000  
# 000       000      000       000 0 000  
# 00000000  0000000  00000000  000   000  

elem = (t,o,p) ->
    # log "#{t} #{p}", o
    e = document.createElement t
    if o.text?
        e.innerText = o.text
    if o.click?
        e.addEventListener 'click', o.click
    p.appendChild opt e, o
    e
          
# 00     00   0000000   0000000   
# 000   000  000       000        
# 000000000  0000000   000  0000  
# 000 0 000       000  000   000  
# 000   000  0000000    0000000   

msg = (t,cls='') ->
    
    screen.msg?.remove()
    if t
        screen.msg = elem 'div', class:"msg #{cls}", text:t, main
        screen.msg.style.fontSize = "#{parseInt screen.radius/10}px"
        
# 000   000  000  000   000  000000000  
# 000   000  000  0000  000     000     
# 000000000  000  000 0 000     000     
# 000   000  000  000  0000     000     
# 000   000  000  000   000     000     

hint = (t1,t2) ->
    
    screen.hint1?.remove()
    screen.hint2?.remove()
    
    if t1
        screen.hint1 = elem 'div', class:"hint1", text:t1, main
        screen.hint1.style.fontSize = "#{parseInt screen.radius/20}px"
    if t2
        screen.hint2 = elem 'div', class:"hint2", text:t2, main
        screen.hint2.style.fontSize = "#{parseInt screen.radius/20}px"
        
# 00000000    0000000   00000000   000   000  00000000   
# 000   000  000   000  000   000  000   000  000   000  
# 00000000   000   000  00000000   000   000  00000000   
# 000        000   000  000        000   000  000        
# 000         0000000   000         0000000   000        

popup = (p,t) ->
    
    screen.popup?.remove()
    if t
        s = u2s p
        screen.popup = elem 'div', class:"popup", text:t, main
        screen.popup.style.left = "#{s.x}px"
        screen.popup.style.top  = "#{s.y - screen.radius/7}px"
        screen.popup.style.fontSize = "#{parseInt screen.radius/20}px"
        
#  0000000  000   000   0000000   000   0000000  00000000  
# 000       000   000  000   000  000  000       000       
# 000       000000000  000   000  000  000       0000000   
# 000       000   000  000   000  000  000       000       
#  0000000  000   000   0000000   000   0000000  00000000  

choice = (info) ->
    
    menu.buttons[info.text] = elem 'div', info, menu.left
    
    for c in info.values
        chose = (info,c) -> (e) -> 
            for value in info.values
                menu.buttons[value].classList.remove 'highlight'
            if c not in ['+', '-', 'VOL']
                e.target.classList.add 'highlight'
                                
            if c not in ['VOL']
                info.cb c
            e.stopPropagation()
            
        menu.buttons[c] = elem 'div', class:'button', text:c, click:chose(info, c), menu.left
        
        if c == 'VOL'
            menuVolume snd.vol

# 00000000    0000000   000   000   0000000  00000000  
# 000   000  000   000  000   000  000       000       
# 00000000   000000000  000   000  0000000   0000000   
# 000        000   000  000   000       000  000       
# 000        000   000   0000000   0000000   00000000  

menuPause = ->
    
    return if not menu.buttons['PAUSE']
    
    menu.buttons['PAUSE'].classList.toggle 'highlight', world.pause
    
    next = menu.buttons['PAUSE'].nextSibling
    while next
        next.style.display = world.pause and 'initial' or 'none'
        next = next.nextSibling
    
    if world.pause
        menu.buttons['PAUSE'].innerHTML = 'PLAY'
    else
        menu.buttons['PAUSE'].innerHTML = 'PAUSE'
        
menu.buttons['usr'] = elem 'div', class:'button usr', menu.right
menu.buttons['bot'] = elem 'div', class:'button bot', menu.right
   