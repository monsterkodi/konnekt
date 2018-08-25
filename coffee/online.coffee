log = console.log

svg = document.getElementById('main').children[0]

elem = (typ,opt) ->
    e = document.createElementNS "http://www.w3.org/2000/svg", typ
    return e if not opt
    for k in Object.keys opt
        e.setAttribute k, opt[k]
    e

w=window
rx=ry=0
cx=cy=0
sw=sh=0
mx=my=0
rd=0
lst=0
drg= null
iq = new Quat
rq = null
dt = []
dl = []
    
add = (t,o) -> 
    e = elem t,o
    svg.appendChild e
    e
    
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
size()

move = (event) ->
    if drg == 'rot' 
        qx = Quat.axis 0, 1, 0, event.movementX / rd
        qy = Quat.axis 1, 0, 0, event.movementY / -rd
        rq = qx.mul qy
        for d in dt
            d.rot rq
    else if drg
        drg.v.x = (event.clientX/sw-0.5)/(rd/sw)
        drg.v.y = (event.clientY/sh-0.5)/(rd/sh)
        drg.v.norm()
        drg.upd()
        
    mx = event.clientX
    my = event.clientY
    
down = (event) -> 
    iq = new Quat
    
    if dot = event.target.dot
        drg = dot
    else
        drg = 'rot'

up = (event) -> 
    iq  = rq
    drg = null
    
w.addEventListener 'resize',    size
w.addEventListener 'mousemove', move
w.addEventListener 'mousedown', down
w.addEventListener 'mouseup',   up
    
v = null
    
cr = add 'circle', cx:cx, cy:cy, r:rd, stroke:"#333", 'stroke-width': 1
cr.v = vec()
ms = add 'circle', stroke:'none', fill:'red', style:"pointer-events:none"

class Dot
    
    constructor: ->
        @l = []
        @n = []
        @i = dt.length
        @v = vec randr(-1,1), randr(-1,1), randr(-1,1)
        @v.norm()
        @c = add 'circle', class:'dot', id:@i, cx:cx+@v.x*rx, cy:cy+@v.y*rx, r:(@v.z+1.1)*rd/50, stroke:'none', fill:"#555", style:"stroke-width:2"
        @c.dot= @
        dt.push @
        
    line: (d) ->
        l = add 'line', class:'line', id:@i, x1:cx+@v.x*rx, y1:cy+@v.y*rx, x2:cx+d.v.x*rx, y2:cy+d.v.y*ry, stroke:"#222", style:"stroke-width:2"
        @l.push l
        @n.push d
        
    rot: (q) ->
        @v = q.rotate @v
        @upd()
        
    upd: ->
        
        @c.setAttribute 'cx', cx+@v.x*rd
        @c.setAttribute 'cy', cy+@v.y*rd
        
        l = (@v.z + 1.3)/1.5
        @c.setAttribute 'fill', "rgb(#{l*255},#{l*255},#{l*255})"
        @c.setAttribute 'r', l*rd/40
        
        for i in [0...@n.length]
            l = @l[i]
            n = @n[i]
            l.setAttribute 'x1', cx+@v.x*rx
            l.setAttribute 'y1', cy+@v.y*rx
            l.setAttribute 'x2', cx+n.v.x*rx
            l.setAttribute 'y2', cy+n.v.y*ry
    
for i in [0...parseInt randr(50,150)]

    d = new Dot
    
    if dt.length > 1
        d.line dt[dt.length-2]
   
anim = (now) ->

    ctr cr
    cr.setAttribute 'r', rd
    iq.slerp new Quat(), 0.05
    ms.setAttribute 'cx', mx
    ms.setAttribute 'cy', my
    ms.setAttribute 'r',  rd/50
    
    dt.sort (a,b) -> a.v.z - b.v.z
    
    for d in dt
        d.rot iq
        d.c.parentNode.appendChild d.c
        
    ms.parentNode.appendChild ms
        
    w.requestAnimationFrame anim
    lst=now
        
w.requestAnimationFrame anim
    