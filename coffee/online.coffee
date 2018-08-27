log = console.log

main = document.getElementById 'main'
menu = main.children[1]
svg  = main.children[0]

win=window
rx=ry=0
cx=cy=0
sw=sh=0
mx=my=0
rd=0
lst=0
upd=1
drg= null
iq = new Quat
rq = new Quat
dt = []
lt= []
 
opt = (e,o) ->
    if o?
        for k in Object.keys o
            e.setAttribute k, o[k]
    e
    
elem = (t,o) ->
    e = document.createElement t
    if o.text?
        e.innerText = o.text
    menu.appendChild opt e, o
    e
        
app = (p,t,o) ->
    e = document.createElementNS "http://www.w3.org/2000/svg", t
    p.appendChild opt e, o
    e
    
add = (t,o) -> app svg, t, o
    
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

move = (e) ->
    if drg == 'rot' 
        qx = Quat.xyza 0, 1, 0, e.movementX / rd
        qy = Quat.xyza 1, 0, 0, e.movementY / -rd
        rq = qx.mul qy
        for d in dt
            d.rot rq
            upd = 1
    else if drg
        v = vec (e.clientX/sw-0.5)/(rd/sw), (e.clientY/sh-0.5)/(rd/sh), drg.v.z
        v.norm()
        switch e.button
            when 0
                drg.send v
                upd = 1
            when 2
                drg.v = v
                upd = 1
                # drg.upd()
        
    mx = e.clientX
    my = e.clientY
    
# 0000000     0000000   000   000  000   000  
# 000   000  000   000  000 0 000  0000  000  
# 000   000  000   000  000000000  000 0 000  
# 000   000  000   000  000   000  000  0000  
# 0000000     0000000   00     00  000   000  

down = (e) ->    
    
    iq = new Quat
    if drg = e.target.dot
        return
    drg = 'rot'

up = (e) -> 
    iq  = rq
    drg = null
    
win.addEventListener 'resize',    size
win.addEventListener 'mousemove', move
win.addEventListener 'mousedown', down
win.addEventListener 'mouseup',   up
win.addEventListener 'contextmenu', (e) -> e.preventDefault()
    
v = null
    
cr = add 'circle', cx:cx, cy:cy, r:rd, stroke:"#333", 'stroke-width': 1
cr.v = vec()

u2s = (v) -> vec cx+v.x*rx, cy+v.y*ry
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
    
color = (d) ->
    l = (d.depth() + 0.3)/1.5
    "rgb(#{l*255},#{l*255},#{l*255})"
    
# 000      000  000   000  00000000  
# 000      000  0000  000  000       
# 000      000  000 0 000  0000000   
# 000      000  000  0000  000       
# 0000000  000  000   000  00000000  

class Line
    
    constructor: (@s,@e) ->
        
        @c = add 'path', class:'path', stroke:"#fff", 'stroke-linejoin':"round", 'stroke-linecap':"round", style:'pointer-events:none'
       
    depth: -> (@s.depth()+@e.depth())/2 
    raise: -> @c.parentNode.appendChild @c
    upd: ->
        
        @c.setAttribute 'd', arc @s.v, @e.v
        @c.setAttribute 'stroke', color @
        
        @c.style.strokeWidth = ((@depth() + 0.3)/1.5)*rd/50
        
# 0000000     0000000   000000000  
# 000   000  000   000     000     
# 000   000  000   000     000     
# 000   000  000   000     000     
# 0000000     0000000      000     

class Dot
    
    constructor: ->
        @l = []
        @n = []
        @i = dt.length
        @v = vec randr(-1,1), randr(-1,1), randr(-1,1)
        @v.norm()
        @g = add 'g'
        @c = app @g, 'circle', class:'dot', id:@i, cx:cx+@v.x*rx, cy:cy+@v.y*rx, r:(@v.z+1.1)*rd/50, stroke:'none', fill:"#555"
        @c.dot = @
        dt.push @
        
    depth: -> (@v.z+1)/2
    raise: -> @g.parentNode.appendChild @g
    linked: (d) -> d==undefined or d==@ or (d in @n) or (@ in d.n)
    dist: (d) -> @v.angle d.v
    closest: -> dt.slice(0).sort (a,b) => @dist(a)-@dist(b)
        
    line: (d) -> 
        if d == @
            log 'self?'
            return
        if @linked d
            log 'linked?'
            return
        @n.push d
        d.n.push @
        l = new Line @, d
        @l.push l
        lt.push l
        l
        
    send: (v) -> log "send #{v.length()}", v
        
    rot: (q) -> @v = q.rotate @v
        
    upd: ->
        
        @c.setAttribute 'cx', cx+@v.x*rd
        @c.setAttribute 'cy', cy+@v.y*rd
                
        @c.setAttribute 'fill', color @
        @c.setAttribute 'r', ((d.depth() + 0.3)/1.5)*rd/20
        
        for l in @l
            l.upd()
            
for i in [0...parseInt randr(10,50)]
    d = new Dot

for d in dt
    c = d.closest().filter (a) -> not d.linked(a)
    d.line c[0]
   
#  0000000   000   000  000  00     00  
# 000   000  0000  000  000  000   000  
# 000000000  000 0 000  000  000000000  
# 000   000  000  0000  000  000 0 000  
# 000   000  000   000  000  000   000  

anim = (now) ->

    ctr cr
    cr.setAttribute 'r', rd
    
    iq.slerp new Quat(), 0.01
    
    if not iq.zero() or upd
        
        for d in dt
            d.rot iq
            d.upd()
            
        for x in (dt.concat lt).sort (a,b) -> a.depth()-b.depth()
            x.raise()
            
        upd = 0
    
    win.requestAnimationFrame anim
    lst=now
        
win.requestAnimationFrame anim

b = elem 'div', class:'button', text:'FULLSCREEN'
b.addEventListener 'click', ->
    el = document.documentElement
    rfs = el.requestFullscreen or el.webkitRequestFullScreen or el.mozRequestFullScreen or el.msRequestFullscreen 
    rfs.call el
b = elem 'div', class:'button', text:'PAUSE'
