
# 00000000  000      00000000  00     00  
# 000       000      000       000   000  
# 0000000   000      0000000   000000000  
# 000       000      000       000 0 000  
# 00000000  0000000  00000000  000   000  

elem = (t,o,p=menu.left) ->
    e = document.createElement t
    if o.text?
        e.innerText = o.text
    if o.click?
        e.addEventListener 'click', o.click
    p.appendChild opt e, o
    e
          
msg = (t,cls='') ->
    
    screen.msg?.remove()
    if t
        screen.msg = elem 'div', class:"msg #{cls}", text:t, main
        screen.msg.style.fontSize = "#{parseInt screen.radius/10}px"
        
hint = (t1,t2) ->
    
    screen.hint1?.remove()
    screen.hint2?.remove()
    
    if t1
        screen.hint1 = elem 'div', class:"hint1", text:t1, main
        screen.hint1.style.fontSize = "#{parseInt screen.radius/20}px"
        # screen.hint1.addEventListener 'click', -> screen.hint.remove()
    if t2
        screen.hint2 = elem 'div', class:"hint2", text:t2, main
        screen.hint2.style.fontSize = "#{parseInt screen.radius/20}px"
        # screen.hint2.addEventListener 'click', -> screen.hint.remove()
        
#  0000000  000   000   0000000   000   0000000  00000000  
# 000       000   000  000   000  000  000       000       
# 000       000000000  000   000  000  000       0000000   
# 000       000   000  000   000  000  000       000       
#  0000000  000   000   0000000   000   0000000  00000000  

choice = (info) ->
    elem 'div', class:'choice label', text:info.name
    for c in info.values
        chose = (info,c) -> (e) -> 
            for value in info.values
                menu.buttons[value].classList.remove 'highlight'
            if c not in ['+', '-', 'VOL']
                e.target.classList.add 'highlight'
            if c not in ['VOL']
                info.cb c
        menu.buttons[c] = elem 'div', class:'button inline', text:c, click: chose info, c
        
# 00     00  00000000  000   000  000   000    
# 000   000  000       0000  000  000   000    
# 000000000  0000000   000 0 000  000   000    
# 000 0 000  000       000  0000  000   000    
# 000   000  00000000  000   000   0000000     

menu.buttons['usr'] = elem 'div', class:'button usr', menu.right
menu.buttons['bot'] = elem 'div', class:'button bot', menu.right
menu.buttons['pause'] = elem 'div', class:'button', text:'PAUSE', click: -> pause()
elem 'div', class:'button', text:'MENU',  click: -> loadLevel 'menu'
elem 'div', class:'button', text:'RESET', click: -> loadLevel world.level.name
menu.buttons['fullscreen'] = elem 'div', class:'button', text:'FULLSCREEN', click: toggleFullscreen
menu.buttons['clear'] = elem 'div', class:'button', text:'CLEAR', click: -> pref.clear()
choice name:'VOLUME',   values:['-', 'VOL', '+'], cb: (c) -> 
    switch c
        when '+' then snd.volUp()
        when '-' then snd.volDown()
        