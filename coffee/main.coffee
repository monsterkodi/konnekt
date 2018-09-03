###
00     00   0000000   000  000   000    
000   000  000   000  000  0000  000    
000000000  000000000  000  000 0 000    
000 0 000  000   000  000  000  0000    
000   000  000   000  000  000   000    
###
    
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
        
hint = (t) ->
    screen.hint?.remove()
    if t
        screen.hint = elem 'div', class:"hint", text:t, main
        screen.hint.style.fontSize = "#{parseInt screen.radius/20}px"
        screen.hint.addEventListener 'click', -> screen.hint.remove()
    
u2s = (v) -> vec screen.center.x+v.x*screen.radius, screen.center.y+v.y*screen.radius

m2u = (m) ->
    sp = m.minus(screen.center).times 1/screen.radius
    if sp.length() > 1
        sp.norm()
    else
        vec sp.x, sp.y, sqrt 1 - sp.x*sp.x - sp.y*sp.y

ctr = (s) ->
    p = u2s s.v
    s.setAttribute 'cx', p.x
    s.setAttribute 'cy', p.y

#  0000000  000  0000000  00000000  
# 000       000     000   000       
# 0000000   000    000    0000000   
#      000  000   000     000       
# 0000000   000  0000000  00000000  

size = -> 
    br = svg.getBoundingClientRect()
    screen.size   = vec br.width,   br.height
    screen.center = vec br.width/2, br.height/2
    screen.radius = 0.4 * Math.min screen.size.x, screen.size.y
    world.update  = 1
    screen.hint?.style.fontSize = "#{parseInt screen.radius/20}px"
    screen.msg?.style.fontSize = "#{parseInt screen.radius/10}px"
    menu.left.style.fontSize  = "#{max 12, parseInt screen.radius/30}px"
    menu.right.style.fontSize = "#{max 12, parseInt screen.radius/30}px"
    grph?.plot()
size()

# 00     00   0000000   000   000  00000000  
# 000   000  000   000  000   000  000       
# 000000000  000   000   000 000   0000000   
# 000 0 000  000   000     000     000       
# 000   000   0000000       0      00000000  

rotq = (v) ->
    qx = Quat.xyza 0, 1, 0, v.x /  screen.radius
    qy = Quat.xyza 1, 0, 0, v.y / -screen.radius
    qx.mul qy

move = (e) ->
    
    mouse.pos = vec e.clientX, e.clientY
    
    if mouse.drag == 'rot'
        
        world.userRot = rotq vec e.movementX, e.movementY
        for d in world.dots
            d.rot world.userRot
            world.update = 1
            
        world.rotSum.add vec e.movementX/10, e.movementY/10
                        
    else if mouse.drag
    
        switch e.buttons
            when 1
                mouse.drag.send m2u mouse.pos
                world.update = 1
            when 2
                mouse.drag.v = m2u mouse.pos
                log mouse.drag.v
                world.update = 1
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

delTmpl = ->
    
    world.tmpline.usr?.del()
    delete world.tmpline.usr

down = (e) ->
    
    delTmpl()
    mouse.drag?.c?.classList.remove 'src'
    
    world.inertRot = new Quat
    
    hint()
    if world.level.name == 'menu'
        msg()
    else if world.winner and e.buttons == 1 and not e.target.classList.contains 'button'
        log e
        if world.winner == 'usr'
            loadLevel world.level.next ? 'menu'
        else
            loadLevel world.level.name
        return
    
    if mouse.drag = e.target.dot
        
        if world.level.name == 'menu' 
            if e.buttons == 1
                loadLevel mouse.drag.level
            return
        
        if not world.pause
            if mouse.drag.c.classList.contains 'linked'
                if mouse.drag.own != 'bot'
                    return
        
    mouse.drag = 'rot'

# 000   000  00000000   
# 000   000  000   000  
# 000   000  00000000   
# 000   000  000        
#  0000000   000        

up = (e) ->
    
    if mouse.drag == 'rot'
        
        world.inertRot = rotq world.rotSum
        
    else if mouse.drag
        
        world.inertRot = new Quat
        
        if world.tmpline.usr? and world.tmpline.usr.e.c
            mouse.drag.link world.tmpline.usr.e
            
        mouse.drag.c.classList.remove 'src'
            
    delTmpl()
        
    mouse.drag = null
    world.update = 1
    
# 000   000   0000000   000   000  00000000  00000000     
# 000   000  000   000  000   000  000       000   000    
# 000000000  000   000   000 000   0000000   0000000      
# 000   000  000   000     000     000       000   000    
# 000   000   0000000       0      00000000  000   000    

enter = (e) ->
    
    mouse.touch = e.target.dot
    
    return if mouse.drag
    
    return if world.pause
    
    if d = e.target.dot
                
        if d.c.classList.contains('linked') and d.own == 'usr'
            
            if d != mouse.hover
                mouse.hover = d
                d.c.classList.add 'src'
            
        else if mouse.hover
            
            mouse.hover.c.classList.remove 'src'
            mouse.hover = null
    
leave = (e) ->
    
    mouse.touch = null
        
    if d = e.target.dot
        if d == mouse.hover
            if d != mouse.drag
                d.c.classList.remove 'src'
            mouse.hover = null
  
# 000   000  00000000  000   000  
# 000  000   000        000 000   
# 0000000    0000000     00000    
# 000  000   000          000     
# 000   000  00000000     000     

keydown = (e) ->
    
    switch e.keyCode
        when 32 then pause() # space
        # else 
            # log 'keydown', e
            
    # switch e.key
        # when '1' then snd.note 1
        # when '2' then snd.note 2
        # when '3' then snd.note 3
        # when '4' then snd.note 4
        # when '5' then snd.note 5
        # when '6' then snd.note 6
        # when '7' then snd.note 7
        # when '8' then snd.note 8
        # when '9' then snd.note 9
        # when '0' then snd.note 10
        # when 'q' then snd.note 11
        # when 'w' then snd.note 12
        # when 'e' then snd.note 13
        # when 'r' then snd.note 14
        # when 't' then snd.note 15
        # when 'y' then snd.note 16
        # when 'u' then snd.note 17
        # when 'i' then snd.note 18
        # when 'o' then snd.note 19
        # when 'p' then snd.note 20
        # when 'a' then snd.note 21
        # when 's' then snd.note 22
        # when 'd' then snd.note 23
        # when 'f' then snd.note 24
        # when 'g' then snd.note 25
        # when 'h' then snd.note 26
        # when 'j' then snd.note 27
        # when 'k' then snd.note 28
        # when 'l' then snd.note 29
        # when ';' then snd.note 30
            
win.addEventListener 'resize',    size
svg.addEventListener 'mouseover', enter
svg.addEventListener 'mouseout',  leave
win.addEventListener 'mousemove', move
win.addEventListener 'mousedown', down
win.addEventListener 'mouseup',   up
win.addEventListener 'keydown',   keydown
win.addEventListener 'contextmenu', (e) -> e.preventDefault()
        
slp = (l,p) ->
    for i in [1,2]
        for a in ['x','y']
            l.setAttribute "#{a}#{i}", p[i-1][a]

arc = (a,b) ->
    r = a.angle b
    n = parseInt r/0.087
    s = u2s a
    d = "M #{s.x} #{s.y}"
    
    q = Quat.axis a.cross(b).norm(), r/(n+1)
    v = a.cpy()
    for i in [0...n]
        v = q.rotate v
        s = u2s v
        d += " L #{s.x} #{s.y}"
    
    s = u2s b
    d += " L #{s.x} #{s.y}"
    d
    
brightness = (d) -> d.c.style.opacity = (d.depth() + 0.3)/1.3

# 00000000    0000000   000   000   0000000  00000000  
# 000   000  000   000  000   000  000       000       
# 00000000   000000000  000   000  0000000   0000000   
# 000        000   000  000   000       000  000       
# 000        000   000   0000000   0000000   00000000  

pause = (m='PAUSED', cls='', status='pause') ->
    
    world.pause = not world.pause
    menu.buttons['pause'].classList.toggle 'highlight', world.pause
    msg (world.pause and m or ''), cls
    
    next = menu.buttons['pause'].nextSibling
    while next
        next.style.display = world.pause and 'initial' or 'none'
        next = next.nextSibling
        
    if world.pause
        menu.buttons['pause'].innerHTML = 'PLAY'
    else
        menu.buttons['pause'].innerHTML = 'PAUSE'

# 000       0000000    0000000   0000000        000      00000000  000   000  00000000  000        
# 000      000   000  000   000  000   000      000      000       000   000  000       000        
# 000      000   000  000000000  000   000      000      0000000    000 000   0000000   000        
# 000      000   000  000   000  000   000      000      000          000     000       000        
# 0000000   0000000   000   000  0000000        0000000  00000000      0      00000000  0000000    

loadLevel = (level='random') ->
    
    svg.innerHTML = ''
    
    menu.buttons.bot.innerHTML = ''
    menu.buttons.usr.innerHTML = ''
    
    world.circle = add 'circle', class:'world', cx:screen.center.x, cy:screen.center.y, r:screen.radius
    world.circle.v = vec()
    
    dbg = add 'line', class:'dbg'
    
    world.ticks  = 0
    world.dots   = []        
    world.lines  = []
    world.update = 1
    world.winner = null
    
    bot = null
    
    hint()
    
    switch level
        when 'random' then randomLevel()
        else
            initLevel level
    
    if world.pause
        pause()
        
# 000  000   000  000  000000000        000      00000000  000   000  00000000  000    
# 000  0000  000  000     000           000      000       000   000  000       000    
# 000  000 0 000  000     000           000      0000000    000 000   0000000   000    
# 000  000  0000  000     000           000      000          000     000       000    
# 000  000   000  000     000           0000000  00000000      0      00000000  0000000

initLevel = (name) ->
    
    level = levels[name]
    level.name = name
        
    for d in level.dots
        dot = new Dot vec d.v[0], d.v[1], d.v[2]
        if d.o
            dot.setOwn d.o
            dot.setUnits d.u if d.u
        if d.l
            dot.level = d.l
            if pref.get d.l
                dot.setOwn 'usr'
        
    for l in level.lines ? []
        line = new Line world.dots[l[0]], world.dots[l[1]]
        world.lines.push line
            
    if level.bot
        if level.bot.i < 0
            i = world.dots.length + level.bot.i
        else
            i = level.bot.i
        bot = new Bot world.dots[i]
        if level.bot.speed
            bot.speed = level.bot.speed
        
    if level.msg
        if not world.pause
            pause()
            pause()
        msg level.msg
    if level.hint
        hint level.hint
        
    world.level   = level
    world.addUnit = level.addUnit
    
    if world.addUnit
        grph = new Grph
    
# 00000000    0000000   000   000  0000000     0000000   00     00  
# 000   000  000   000  0000  000  000   000  000   000  000   000  
# 0000000    000000000  000 0 000  000   000  000   000  000000000  
# 000   000  000   000  000  0000  000   000  000   000  000 0 000  
# 000   000  000   000  000   000  0000000     0000000   000   000  

randomLevel = ->
    
    grph = new Grph
    
    world.addUnit = 1
    world.level = 
        name: 'random'
    
    d = new Dot vec 0,0,1
    d.setOwn 'usr'
    
    nodes = world.nodes ? 2 * parseInt randr 8, 20
    for i in [1...nodes/2]
        v = vec randr(-1,1), randr(-1,1), randr(0,1)
        v.norm()
        
        while true
            ok = true 
            for ed in world.dots
                if v.angle(ed.v) < 0.2
                    v = vec randr(-1,1), randr(-1,1), randr(0,1) 
                    v.norm()
                    ok = false
                    break
            if ok 
                break
        
        new Dot v
        
    for i in [nodes/2-1..0]
        new Dot world.dots[i].v.times(-1).add vec 0.01
    
    b = world.dots[world.dots.length-1]
    b.setOwn 'bot'
    bot = new Bot()
    
    b.startTimer 360
    d.startTimer 360
            
#  0000000   000   000  000  00     00  
# 000   000  0000  000  000  000   000  
# 000000000  000 0 000  000  000000000  
# 000   000  000  0000  000  000 0 000  
# 000   000  000   000  000  000   000  

snd = new Snd 

anim = (now) ->
    
    snd.tick()
    
    ctr world.circle
    world.circle.setAttribute 'r', screen.radius
    
    world.delta = (now-world.time)/16
    
    if not world.pause and world.level.name != 'menu'
    
        world.ticks += 1
        
        if world.ticks % 60 == 0
            
            for ow in ['usr', 'bot']
                
                dots  = world.dots.filter (d) -> d.own == ow
                world.units[ow] = dots.reduce ((a,b) -> a+b.targetUnits), 0
                dots  = dots.filter (d) -> d.units >= d.minUnits
                
                menu.buttons[ow].innerHTML = "&#9679; #{dots.length}"
                    
                if dots.length == 0
                    if ow == 'bot'
                        pause 'ONLINE!\n\nYOU WON!', 'usr'
                        world.winner = 'usr'
                        pref.set world.level.name, true
                    else
                        pause 'OFFLINE!\n\nYOU LOST!', 'bot'
                        world.winner = 'bot'
                    win.requestAnimationFrame anim
                    screen.hint?.remove()
                    world.update = 1
                    return

                for d in dots
                    d.addUnit world.addUnit
            
            grph?.sample()
            grph?.plot()
    
        bot?.anim world.delta
    
    world.rotSum.mul 0.8
    # slp dbg, [u2s(vec()), u2s(rsum.times 1/100)]
    
    world.inertRot.slerp new Quat(), 0.01 * world.delta
        
    if not world.inertRot.zero() or world.update
        
        for d in world.dots
            d.rot world.inertRot
            d.upd()
            
        for l in world.lines
            l.upd()
            
        world.tmpline.usr?.upd()
        world.tmpline.bot?.upd()
            
        items = world.lines.concat world.dots
        items.push world.tmpline.usr if world.tmpline.usr?
        items.push world.tmpline.bot if world.tmpline.bot?
        for x in items.sort (a,b) -> a.zdepth()-b.zdepth()
            x.raise()
            
        world.update = 0
    
    dbg.parentNode.appendChild dbg
    
    for spark in world.sparks.slice 0
        spark.upd()
    
    win.requestAnimationFrame anim
    world.time=now
        
win.requestAnimationFrame anim

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
menu.buttons['fullscreen'] = elem 'div', class:'button', text:'FULLSCREEN', click: ->
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
menu.buttons['clear'] = elem 'div', class:'button', text:'CLEAR', click: -> pref.clear()
choice name:'VOLUME',   values:['-', 'VOL', '+'], cb: (c) -> 
    switch c
        when '+' then snd.volUp()
        when '-' then snd.volDown()

loadLevel 'menu'
