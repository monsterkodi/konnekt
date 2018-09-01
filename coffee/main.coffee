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
                world.update = 1
        
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

delTmpl = ->
    
    world.tmpline.usr?.c.remove()
    delete world.tmpline.usr

down = (e) ->
    
    delTmpl()
    
    world.inertRot = new Quat
    
    if mouse.drag = e.target.dot
        if not world.pause
            if mouse.drag.c.classList.contains 'linked'
                if mouse.drag.own != 'bot'
                    return
        
    mouse.drag?.c?.classList.remove 'src'
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
    
    return if mouse.drag
    
    return if world.pause
    
    if d = e.target.dot
        
        if mouse.hover
            mouse.hover.c.classList.remove 'src'
            mouse.hover = null
        
        if d.c.classList.contains('linked') and d.own == 'usr'
            mouse.hover = d
            d.c.classList.add 'src'
    
leave = (e) ->
    
    if d = e.target.dot
        if d == mouse.hover
            if d != mouse.drag
                d.c.classList.remove 'src'
            mouse.hover = null
    
win.addEventListener 'resize',    size
svg.addEventListener 'mouseover', enter
svg.addEventListener 'mouseout',  leave
win.addEventListener 'mousemove', move
win.addEventListener 'mousedown', down
win.addEventListener 'mouseup',   up
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
    
brightness = (d) -> d.c.style.opacity = (d.depth() + 0.4)/1.4
            
# 00000000   00000000   0000000  00000000  000000000  
# 000   000  000       000       000          000     
# 0000000    0000000   0000000   0000000      000     
# 000   000  000            000  000          000     
# 000   000  00000000  0000000   00000000     000     

pause = -> 
    world.pause = not world.pause
    menu.buttons['pause'].classList.toggle 'highlight', world.pause

reset = ->
    
    p = world.pause
    world.pause = true
    world.ticks = 0
    
    svg.innerHTML = ''
    
    grph = new Grph
    
    world.circle = add 'circle', cx:screen.center.x, cy:screen.center.y, r:screen.radius, stroke:"#333", 'stroke-width':1
    world.circle.v = vec()
    
    dbg = add 'line', class:'dbg'
    
    world.dots = []
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
    
    bot = new Bot world.dots[world.dots.length-1]
        
    world.lines  = []
    world.update = 1   
    world.pause  = p
    d.startTimer 360
    
reset()
        
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
    
    if not world.pause
    
        world.ticks += 1
        if world.ticks % 60 == 0
            
            for ow in ['bot', 'usr']
                
                dots  = world.dots.filter (d) -> d.own == ow
                world.units[ow] = dots.reduce ((a,b) -> a+b.targetUnits), 0
                dots  = dots.filter (d) -> d.units > d.minUnits
                
                if dots.length == 0
                    if ow == 'bot'
                        log 'ONLINE!'
                    else
                        log 'OFFLINE!'
                    reset()
                    win.requestAnimationFrame anim
                    return
                
                menu.buttons[ow].innerHTML = "&#9679; #{dots.length} &#9650; #{world.units[ow]}"
                for d in dots
                    d.addUnit()
            
            grph.sample()
            grph.plot()
    
        bot.anim world.delta
    
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
    
    win.requestAnimationFrame anim
    world.time=now
        
win.requestAnimationFrame anim

# 00     00  00000000  000   000  000   000    
# 000   000  000       0000  000  000   000    
# 000000000  0000000   000 0 000  000   000    
# 000 0 000  000       000  0000  000   000    
# 000   000  00000000  000   000   0000000     

menu.buttons['bot'] = elem 'div', class:'button bot', menu.right
menu.buttons['usr'] = elem 'div', class:'button usr', menu.right

menu.buttons['pause'] = elem 'div', class:'button', text:'PAUSE', click:pause
elem 'div', class:'button', text:'FULLSCREEN', click: ->
    el = document.documentElement
    rfs = el.requestFullscreen or el.webkitRequestFullScreen or el.mozRequestFullScreen or el.msRequestFullscreen 
    rfs.call el
    
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

elem 'div', class:'button', text:'RESET', click:reset
choice name:'NODES', values:['16', '24', '32', '40'], cb: (c) -> world.nodes = parseInt c
choice name:'VOL',   values:['-', 'VOL', '+'], cb: (c) -> 
    switch c
        when '+' then snd.volUp()
        when '-' then snd.volDown()
