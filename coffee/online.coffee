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
  
s2u = (v) -> vec((v.x/sw-0.5)/(rd/sw), (v.y/sh-0.5)/(rd/sh), v.z).norm()
u2s = (v) -> vec cx+v.x*rx, cy+v.y*ry

ctr = (s) ->
    s.setAttribute 'cx', cx+s.v.x*rd
    s.setAttribute 'cy', cy+s.v.y*rd

size = -> 
    br = svg.getBoundingClientRect()
    sw = br.width
    sh = br.height
    cx = sw/2
    cy = sh/2
    rd = 0.4 * Math.min sw, sh
    rx = rd
    ry = rd
    upd = 1
size()

# 00     00   0000000   000   000  00000000  
# 000   000  000   000  000   000  000       
# 000000000  000   000   000 000   0000000   
# 000 0 000  000   000     000     000       
# 000   000   0000000       0      00000000  

rotq = (v) ->
    qx = Quat.xyza 0, 1, 0, v.x /  rd
    qy = Quat.xyza 1, 0, 0, v.y / -rd
    qx.mul qy

move = (e) ->
    
    if drg == 'rot' 
        rq = rotq vec e.movementX, e.movementY
        for d in dt
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
        
    mx = e.clientX
    my = e.clientY
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

delTmpl = ->
    tmpl?.remove()
    tmpl = null

down = (e) ->
    # rsum = vec()
    delTmpl()
    iq = new Quat
    if drg = e.target.dot
        if drg.c.classList.contains 'linked'
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
    
# 000      000  000   000  00000000  
# 000      000  0000  000  000       
# 000      000  000 0 000  0000000   
# 000      000  000  0000  000       
# 0000000  000  000   000  00000000  

class Line
    
    constructor: (@s,@e) ->
        
        @c = add 'path', class:'line'
        @c.classList.add @s.own
       
    depth: -> (@s.depth()+@e.depth())/2 
    zdepth: -> Math.min(@s.depth(),@e.depth()) - 0.001
    raise: -> @c.parentNode.appendChild @c
    upd: ->
        
        @c.setAttribute 'd', arc @s.v, @e.v
        brightness @
        @c.style.strokeWidth = ((@depth() + 0.3)/1.5)*rd/50
        
# 00000000   00000000   0000000  00000000  000000000  
# 000   000  000       000       000          000     
# 0000000    0000000   0000000   0000000      000     
# 000   000  000            000  000          000     
# 000   000  00000000  0000000   00000000     000     

reset = ->
    
    svg.innerHTML = ''
    cr = add 'circle', cx:cx, cy:cy, r:rd, stroke:"#333", 'stroke-width':1
    cr.v = vec()
    
    dbg = add 'line', class:'dbg'
    
    dt = [new Dot]
    dt[0].setOwn 'usr'
    dt[0].startTimer 360
    dt[0].v = vec 0,0,1
    for i in [0...parseInt randr(10,50)]
        new Dot

    bdt = new Dot
    bdt.v = vec 0,0,-1
    bot = new Bot bdt
        
    lt = []
    
    upd = 1   
    
reset()
        
#  0000000   000   000  000  00     00  
# 000   000  0000  000  000  000   000  
# 000000000  000 0 000  000  000000000  
# 000   000  000  0000  000  000 0 000  
# 000   000  000   000  000  000   000  

tsum = 0
anim = (now) ->

    ctr cr
    cr.setAttribute 'r', rd
    
    dta = (now-lst)/16
    
    tsum += dta
    if tsum > 60
        tsum = 0
        for ow in ['bot', 'usr']
            dots = dt.filter (d) -> d.own == ow
            units = dots.reduce ((a,b)->a+b.targetUnits), 0
            cnt[ow].innerHTML = "&#9679; #{dots.length} &#9650; #{units}"
            for d in dots
                d.addUnit()
    
    bot.anim dta
    
    rsum.mul 0.8
    # slp dbg, [u2s(vec()), u2s(rsum.times 1/100)]
    
    iq.slerp new Quat(), 0.01 * dta
        
    if not iq.zero() or upd
        
        for d in dt
            d.rot iq
            d.upd()
            
        for l in lt
            l.upd()
            
        for x in (lt.concat dt).sort (a,b) -> a.zdepth()-b.zdepth()
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
