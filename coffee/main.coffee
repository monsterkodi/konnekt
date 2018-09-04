###
00     00   0000000   000  000   000    
000   000  000   000  000  0000  000    
000000000  000000000  000  000 0 000    
000 0 000  000   000  000  000  0000    
000   000  000   000  000  000   000    
###
        
#  0000000  000  0000000  00000000  
# 000       000     000   000       
# 0000000   000    000    0000000   
#      000  000   000     000       
# 0000000   000  0000000  00000000  

fontSize = (name, e) ->
    if e
        s = switch name
            when 'msg'  then screen.radius/6
            when 'hint' then screen.radius/20
            when 'menu' then Math.max 12, screen.radius/30
        e.style.fontSize = "#{parseInt s}px"

size = -> 
    
    br = svg.getBoundingClientRect()
    
    screen.size   = vec br.width,   br.height
    screen.center = vec br.width/2, br.height/2
    screen.radius = 0.4 * Math.min screen.size.x, screen.size.y

    world.update = 1
    if world.circle
        world.circle.setAttribute 'cx', screen.center.x
        world.circle.setAttribute 'cy', screen.center.y
        world.circle.setAttribute 'r',  screen.radius
    
    fontSize 'hint', screen.hint1 
    fontSize 'hint', screen.hint2 
    fontSize 'msg',  screen.msg
    fontSize 'menu', menu.left
    
    grph?.plot()
    
size()

# 00     00   0000000   000   000  00000000  
# 000   000  000   000  000   000  000       
# 000000000  000   000   000 000   0000000   
# 000 0 000  000   000     000     000       
# 000   000   0000000       0      00000000  

win.addEventListener 'mousemove', (e) ->
    
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
                mouse.drag.send s2u mouse.pos
                world.update = 1
            when 2
                mouse.drag.v = s2u mouse.pos
                world.update = 1
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

delTmpl = (o) ->
    
    world.tmpline[o]?.del()
    delete world.tmpline[o]

win.addEventListener 'mousedown', (e) ->
    
    delTmpl 'usr'
    mouse.drag?.c?.classList.remove 'src'
    
    world.inertRot = new Quat
    
    hint()
    if world.level.name == 'menu'
        msg()
    else if world.winner and e.buttons == 1 and not e.target.classList.contains 'button'
        loadNext()
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

win.addEventListener 'mouseup', (e) ->
    
    if mouse.drag == 'rot'
        
        world.inertRot = rotq world.rotSum
        
    else if mouse.drag
        
        world.inertRot = new Quat
        
        if world.tmpline.usr and world.tmpline.usr.e.c
            mouse.drag.link world.tmpline.usr.e
            
        mouse.drag.c.classList.remove 'src'
            
    delTmpl 'usr'
        
    mouse.drag = null
    world.update = 1
    
# 000   000   0000000   000   000  00000000  00000000     
# 000   000  000   000  000   000  000       000   000    
# 000000000  000   000   000 000   0000000   0000000      
# 000   000  000   000     000     000       000   000    
# 000   000   0000000       0      00000000  000   000    

svg.addEventListener 'mouseover', (e) ->
    
    mouse.touch = e.target.dot
    
    return if mouse.drag
    
    if d = e.target.dot
                
        if not world.pause and d.c.classList.contains('linked') and d.own == 'usr' or world.level.name == 'menu'
            
            if d != mouse.hover
                setHover d
                d.c.classList.add 'src'
                
                if world.level.name == 'menu'
                    msg()
                    hint()
                    popup d.v, d.level
            
        else if mouse.hover
            setHover()
            
setHover = (a,r=1) ->
    
    if r then mouse.hover?.c.classList.remove 'src'
    mouse.hover = a
    
svg.addEventListener 'mouseout', (e) ->
    
    mouse.touch = null
        
    if d = e.target.dot
        if d == mouse.hover
            setHover null, d != mouse.drag
            if world.level.name == 'menu'
                popup()
  
# 000   000  00000000  000   000  
# 000  000   000        000 000   
# 0000000    0000000     00000    
# 000  000   000          000     
# 000   000  00000000     000     

win.addEventListener 'keydown', (e) ->
    
    switch e.keyCode
        when 32, 27 then pause() # space, esc
        # else log 'keydown', e
                                    
# 00000000    0000000   000   000   0000000  00000000  
# 000   000  000   000  000   000  000       000       
# 00000000   000000000  000   000  0000000   0000000   
# 000        000   000  000   000       000  000       
# 000        000   000   0000000   0000000   00000000  

pause = (m='PAUSED', cls='', status='pause') ->
    
    return if world.level?.name == 'menu'
    
    world.pause = not world.pause
    
    showMenu world.winner and 'next' or world.pause and 'pause' or 'game'
    
    msg (world.pause and m or ''), cls
            
    if world.pause
        snd.tch = {}
        for i in [0...snd.osc.length]
            snd.freq i
        
visibility = -> if document.hidden and not world.pause then pause()

#  0000000   000   000  000  00     00  
# 000   000  0000  000  000  000   000  
# 000000000  000 0 000  000  000000000  
# 000   000  000  0000  000  000 0 000  
# 000   000  000   000  000  000   000  

anim = (now) ->
    
    nextTick = -> win.requestAnimationFrame anim; now
    
    snd.tick()
        
    world.delta = (now-world.time)/16
    world.time  = now
    
    return nextTick() if not world.level
    
    if not world.pause and world.level.name != 'menu'
    
        world.ticks += 1
        
        if world.ticks % 60 == 0
            
            for ow in ['usr', 'bot']
                
                dots  = world.dots.filter (d) -> d.own == ow
                world.units[ow] = dots.reduce ((a,b) -> a+b.targetUnits), 0
                dots  = dots.filter (d) -> d.units >= d.minUnits
                
                menu[ow].innerHTML = "&#9679; #{dots.length}"
                    
                if dots.length == 0
                    if ow == 'bot'
                        world.winner = 'usr'
                        pause 'ONLINE!', 'usr'
                        pref.set world.level.name, true
                    else
                        world.winner = 'bot'
                        pause 'OFFLINE!', 'bot'
                    screen.hint?.remove()
                    world.update = 1
                    return nextTick()

                for d in dots
                    d.addUnit world.addUnit
            
            grph?.sample()
            grph?.plot()
    
        bot?.anim world.delta
    
    world.rotSum.mul 0.8
    
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
    
    for spark in world.sparks.slice 0
        spark.upd()
    
    nextTick()

win.addEventListener 'resize', size
win.addEventListener 'contextmenu', (e) -> e.preventDefault()
    
document.addEventListener 'visibilitychange', visibility, false

pref.load()

win.requestAnimationFrame anim
