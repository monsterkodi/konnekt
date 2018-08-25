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
            d.v = rq.rotate d.v
            ctr d
    else if drg
        id = parseInt drg
        drg.v.x = (event.clientX/sw-0.5)/(rd/sw)
        drg.v.y = (event.clientY/sh-0.5)/(rd/sh)
        drg.v.norm()
        ctr drg
        
    mx = event.clientX
    my = event.clientY
    
down = (event) -> 
    iq = new Quat
    dot = event.target
    if dot.classList.contains 'dot'
        drg = dot
    else
        drg = 'rot'

up = (event) -> 
    iq = rq
    drg = null
    
w.addEventListener 'resize',    size
w.addEventListener 'mousemove', move
w.addEventListener 'mousedown', down
w.addEventListener 'mouseup',   up
    
v = vec 1, 0, 0
    
cr = add 'circle', cx:cx, cy:cy, r:rd, stroke:"#333", 'stroke-width': 1
cr.v = vec()
ms = add 'circle', stroke:'none', fill:'red', style:"pointer-events:none"
for i in [0...parseInt randr(50,150)]
    v = vec randr(-1,1), randr(-1,1), randr(-1,1)
    v.norm()
    c = add 'circle', class:'dot', id:i, cx:cx+v.x*rx, cy:cy+v.y*rx, r:(v.z+1.1)*rd/50, stroke:'none', fill:"#555", style:"stroke-width:2"
    c.v = v
    dt.push c
   
anim = (now) ->

    ctr cr
    cr.setAttribute 'r', rd
    # q = Quat.axis  0, 1, 0, -0.0001*(lst-now)
    iq.slerp new Quat(), 0.05
    ms.setAttribute 'cx', mx
    ms.setAttribute 'cy', my
    ms.setAttribute 'r',  rd/50
    
    dt.sort (a,b) -> a.v.z - b.v.z
    
    for d in dt
        d.parentNode.appendChild d
        ctr d
        d.v = iq.rotate d.v
        l = (d.v.z + 1.1)/1.8
        d.style.zIndex = parseInt l*1000
        d.setAttribute 'z-index', parseInt l*1000
        d.setAttribute 'fill', "rgb(#{l*255},#{l*255},#{l*255})"
        d.setAttribute 'r', (d.v.z+1.1)*rd/40
    
    ms.parentNode.appendChild ms
        
    w.requestAnimationFrame anim
    lst=now
        
w.requestAnimationFrame anim
    