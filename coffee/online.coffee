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
drg=null
    
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
    dot = event.target
    if drg
        id = parseInt drg
        lp[id][0] = (event.clientX/sw-0.5)/(rd/sw)
        lp[id][1] = (event.clientY/sh-0.5)/(rd/sh)
        log 'drag move', drg, lp[id][0], lp[id][1]
        
    mx = event.clientX
    my = event.clientY
    
down = (event) -> 
    dot = event.target
    if dot.classList.contains 'dot'
        drg = dot.id

up = (event) -> 
    drg = null
    
w.addEventListener 'resize',    size
w.addEventListener 'mousemove', move
w.addEventListener 'mousedown', down
w.addEventListener 'mouseup',   up
    
l = elem 'path'
c = elem 'ellipse'

svg.appendChild l
svg.appendChild c
        
dist = (a,b,p) ->
    Math.min Math.pow(a[0]-p[0],2)+Math.pow(a[1]-p[1],2), Math.pow(b[0]-p[0],2)+Math.pow(b[1]-p[1],2) 
    
vec = (x,y,z) -> new Vect x,y,z
    
q = Quat.axis  0, 1, 0, -0.01
v = vec 1, 0, 0
    
anim = (now) ->

    while svg.children.length
        svg.lastChild.remove()

    svg.appendChild elem 'circle', cx:cx, cy:cy, r:rd, stroke:'gray', 'stroke-width': 1
    
    svg.appendChild elem 'circle', cx:mx, cy:my, r:sh/200, stroke:'red', fill:'red', style:"pointer-events:none"
    
    v = q.rotate v
    svg.appendChild elem 'circle', cx:cx+v.x*rx, cy:cy+v.y*rx, r:(v.z+1.1)*rd/50, stroke:'blue', fill:'blue', style:"pointer-events:none;stroke-width:2"
    
    w.requestAnimationFrame anim
    lst=now
        
w.requestAnimationFrame anim
    