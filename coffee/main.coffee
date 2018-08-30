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

elem = (t,o) ->
    e = document.createElement t
    if o.text?
        e.innerText = o.text
    if o.click?
        e.addEventListener 'click', o.click
    menu.appendChild opt e, o
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
    upd = 1
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
    
    if drg == 'rot' 
        rq = rotq vec e.movementX, e.movementY
        for d in world.dots
            d.rot rq
            upd = 1
            
        rsum.x += e.movementX/10
        rsum.y += e.movementY/10
                        
    else if drg
    
        switch e.buttons
            when 1
                drg.send vec e.clientX, e.clientY
                upd = 1
            when 2
                drg.v = s2u vec e.clientX, e.clientY, drg.v.z
                upd = 1
        
    mouse = vec e.clientX, e.clientY
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

delTmpl = ->
    tmpl?.remove()
    tmpl = null

down = (e) ->
    delTmpl()
    iq = new Quat
    if drg = e.target.dot
        if drg.c.classList.contains 'linked'
            if drg.own != 'bot'
                return
    drg = 'rot'

# 000   000  00000000   
# 000   000  000   000  
# 000   000  00000000   
# 000   000  000        
#  0000000   000        

up = (e) -> 
    if drg == 'rot'
        iq = rotq rsum
    else
        iq = new Quat
        if tmpl?
            drg.link tmpl.dot
            
    delTmpl()
        
    drg = null
    upd = 1
    
win.addEventListener 'resize',    size
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
    cr = add 'circle', cx:screen.center.x, cy:screen.center.y, r:screen.radius, stroke:"#333", 'stroke-width':1
    cr.v = vec()
    
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
    
    upd = 1   
    
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
    
    ctr cr
    cr.setAttribute 'r', screen.radius
    
    dta = (now-lst)/16
    
    tsum += dta
    if tsum > 60
        tsum = 0
        for ow in ['bot', 'usr']
            dots = world.dots.filter (d) -> d.own == ow
            
            if dots.length == 0
                if ow == 'bot'
                    log 'ONLINE!'
                else
                    log 'OFFLINE!'
                reset()
                win.requestAnimationFrame anim
                return
            
            units = dots.reduce ((a,b)->a+b.targetUnits), 0
            cnt[ow].innerHTML = "&#9679; #{dots.length} &#9650; #{units}"
            for d in dots
                d.addUnit()
    
    bot.anim dta
    
    rsum.mul 0.8
    # slp dbg, [u2s(vec()), u2s(rsum.times 1/100)]
    
    iq.slerp new Quat(), 0.01 * dta
        
    if not iq.zero() or upd
        
        for d in world.dots
            d.rot iq
            d.upd()
            
        for l in world.lines
            l.upd()
            
        for x in (world.lines.concat world.dots).sort (a,b) -> a.zdepth()-b.zdepth()
            x.raise()
            
        upd = 0
    
    dbg.parentNode.appendChild dbg
    tmpl?.parentNode?.appendChild tmpl
    
    win.requestAnimationFrame anim
    lst=now
        
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
    
cnt['bot'] = elem 'div', class:'button bot'
cnt['usr'] = elem 'div', class:'button usr'
