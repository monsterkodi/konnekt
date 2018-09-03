###
 0000000   000       0000000   0000000    
000        000      000   000  000   000  
000  0000  000      000   000  0000000    
000   000  000      000   000  000   000  
 0000000   0000000   0000000   0000000    
###

win  = window
main = document.getElementById 'main'
pref = new Pref

#  0000000  000   000   0000000   
# 000       000   000  000        
# 0000000    000 000   000  0000  
#      000     000     000   000  
# 0000000       0       0000000   

svg = main.children[0]

opt = (e,o) ->
    if o?
        for k in Object.keys o
            e.setAttribute k, o[k]
    e
    
app = (p,t,o) ->
    e = document.createElementNS "http://www.w3.org/2000/svg", t
    p.appendChild opt e, o
    e
    
add = (t,o) -> app svg, t, o

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

#  0000000   0000000  00000000   00000000  00000000  000   000  
# 000       000       000   000  000       000       0000  000  
# 0000000   000       0000000    0000000   0000000   000 0 000  
#      000  000       000   000  000       000       000  0000  
# 0000000    0000000  000   000  00000000  00000000  000   000  

screen = 
    size:    vec()
    center:  vec()
    radius:  0
    
u2s = (v) -> vec screen.center.x+v.x*screen.radius, screen.center.y+v.y*screen.radius
s2u = (s) ->
    s = s.minus(screen.center).times 1/screen.radius
    if s.length() > 1
        s.norm()
    else
        vec s.x, s.y, sqrt 1 - s.x*s.x - s.y*s.y
    
rotq = (v) ->
    
    qx = Quat.xyza 0, 1, 0, v.x /  screen.radius
    qy = Quat.xyza 1, 0, 0, v.y / -screen.radius
    qx.mul qy
        
# 00     00  00000000  000   000  000   000  
# 000   000  000       0000  000  000   000  
# 000000000  0000000   000 0 000  000   000  
# 000 0 000  000       000  0000  000   000  
# 000   000  00000000  000   000   0000000   

menu = 
    left:    main.children[1]
    right:   main.children[2]
    buttons: {}

# 000   000   0000000   00000000   000      0000000    
# 000 0 000  000   000  000   000  000      000   000  
# 000000000  000   000  0000000    000      000   000  
# 000   000  000   000  000   000  000      000   000  
# 00     00   0000000   000   000  0000000  0000000    

world =
    pause:    0
    update:   0
    time:     0
    delta:    0
    ticks:    0
    dots:     []
    sparks:   []
    lines:    []
    tmpline:  {}
    units:    {}
    userRot:  quat()
    inertRot: quat()
    circle:   null
    rotSum:   vec()
    
# 00     00   0000000   000   000   0000000  00000000  
# 000   000  000   000  000   000  000       000       
# 000000000  000   000  000   000  0000000   0000000   
# 000 0 000  000   000  000   000       000  000       
# 000   000   0000000    0000000   0000000   00000000  

mouse = 
    pos:    vec()
    drag:   null
    hover:  null
    touch:  null

bot  = null 
snd  = new Snd 
dbg  = null
grph = null
