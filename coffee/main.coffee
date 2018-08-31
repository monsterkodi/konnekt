###
00     00   0000000   000  000   000    
000   000  000   000  000  0000  000    
000000000  000000000  000  000 0 000    
000 0 000  000   000  000  000  0000    
000   000  000   000  000  000   000    
###

opt = (e,o) ->
    if o?
        for k in Object.keys o
            e.setAttribute k, o[k]
    e
    
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
        
app = (p,t,o) ->
    e = document.createElementNS "http://www.w3.org/2000/svg", t
    p.appendChild opt e, o
    e
    
add = (t,o) -> app svg, t, o
  
s2u = (v) -> vec((v.x/screen.size.x-0.5)/(screen.radius/screen.size.x), (v.y/screen.size.y-0.5)/(screen.radius/screen.size.y), v.z).norm()
u2s = (v) -> vec screen.center.x+v.x*screen.radius, screen.center.y+v.y*screen.radius

ctr = (s) ->
    p = u2s s.v
    s.setAttribute 'cx', p.x
    s.setAttribute 'cy', p.y

size = -> 
    br = svg.getBoundingClientRect()
    screen.size   = vec br.width,   br.height
    screen.center = vec br.width/2, br.height/2
    screen.radius = 0.4 * Math.min screen.size.x, screen.size.y
    world.update  = 1
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
    
    if mouse.drag == 'rot' 
        world.userRot = rotq vec e.movementX, e.movementY
        for d in world.dots
            d.rot world.userRot
            world.update = 1
            
        world.rotSum.add vec e.movementX/10, e.movementY/10
                        
    else if mouse.drag
    
        switch e.buttons
            when 1
                mouse.drag.send vec e.clientX, e.clientY
                world.update = 1
            when 2
                mouse.drag.v = s2u vec e.clientX, e.clientY, mouse.drag.v.z
                world.update = 1
        
    mouse.pos = vec e.clientX, e.clientY
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

delTmpl = ->
    
    world.templine.usr?.remove()
    delete world.templine.usr

down = (e) ->
    
    delTmpl()
    world.inertRot = new Quat
    
    if mouse.drag = e.target.dot
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
        if world.templine.usr?
            mouse.drag.link world.templine.usr.dot
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
    
brightness = (d) -> d.c.style.opacity = (d.depth() + 0.3)/1.3
            
# 00000000   00000000   0000000  00000000  000000000  
# 000   000  000       000       000          000     
# 0000000    0000000   0000000   0000000      000     
# 000   000  000            000  000          000     
# 000   000  00000000  0000000   00000000     000     

reset = ->
    
    svg.innerHTML = ''
    world.circle = add 'circle', cx:screen.center.x, cy:screen.center.y, r:screen.radius, stroke:"#333", 'stroke-width':1
    world.circle.v = vec()
    
    dbg = add 'line', class:'dbg'
    
    world.dots = []
    d = new Dot
    d.setOwn 'usr'
    d.startTimer 360
    d.v = vec 0,0,1
    for i in [0...parseInt randr(10,50)]
        new Dot

    d = new Dot
    d.v = vec 0,0,-1
    bot = new Bot d
        
    world.lines = []
    world.update = 1   
    
reset()
        
#  0000000   000   000  000  00     00  
# 000   000  0000  000  000  000   000  
# 000000000  000 0 000  000  000000000  
# 000   000  000  0000  000  000 0 000  
# 000   000  000   000  000  000   000  

snd = new Snd 

tsum = 0
anim = (now) ->
    
    snd.tick()
    
    ctr world.circle
    world.circle.setAttribute 'r', screen.radius
    
    world.delta = (now-world.time)/16
    
    tsum += world.delta
    if tsum > 60
        tsum = 0
        for ow in ['bot', 'usr']
            
            dots = world.dots.filter (d) -> d.own == ow
            units = dots.reduce ((a,b)->a+b.targetUnits), 0
            dots = dots.filter (d) -> d.units > d.minUnits
            
            if dots.length == 0
                if ow == 'bot'
                    log 'ONLINE!'
                else
                    log 'OFFLINE!'
                reset()
                win.requestAnimationFrame anim
                return
            
            menu.buttons[ow].innerHTML = "&#9679; #{dots.length} &#9650; #{units}"
            for d in dots
                d.addUnit()
    
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
            
        for x in (world.lines.concat world.dots).sort (a,b) -> a.zdepth()-b.zdepth()
            x.raise()
            
        world.update = 0
    
    dbg.parentNode.appendChild dbg
    world.templine.usr?.parentNode?.appendChild world.templine.usr
    
    win.requestAnimationFrame anim
    world.time=now
        
win.requestAnimationFrame anim

# 00     00  00000000  000   000  000   000    
# 000   000  000       0000  000  000   000    
# 000000000  0000000   000 0 000  000   000    
# 000 0 000  000       000  0000  000   000    
# 000   000  00000000  000   000   0000000     

elem 'div', class:'button', text:'FULLSCREEN', click: ->
    el = document.documentElement
    rfs = el.requestFullscreen or el.webkitRequestFullScreen or el.mozRequestFullScreen or el.msRequestFullscreen 
    rfs.call el
    
elem 'div', class:'button', text:'RESET', click:reset
elem 'div', class:'button', text:'VOL +', click:snd.volUp
menu.buttons['vol'] = elem 'div', class:'button'
elem 'div', class:'button', text:'VOL -', click:snd.volDown

menu.buttons['bot'] = elem 'div', class:'button bot', menu.right
menu.buttons['usr'] = elem 'div', class:'button usr', menu.right

