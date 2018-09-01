###
 0000000   000       0000000   0000000    
000        000      000   000  000   000  
000  0000  000      000   000  0000000    
000   000  000      000   000  000   000  
 0000000   0000000   0000000   0000000    
###

win   = window
main  = document.getElementById 'main'

#  0000000  000   000   0000000   
# 000       000   000  000        
# 0000000    000 000   000  0000  
#      000     000     000   000  
# 0000000       0       0000000   

svg   = main.children[0]

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

pref  = new Pref

screen = 
    size:    vec()
    center:  vec()
    radius:  0
    
menu = 
    left:    main.children[1]
    right:   main.children[2]
    buttons: {}

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
    userRot:  new Quat
    inertRot: new Quat
    circle:   null
    rotSum:   vec()
    
mouse = 
    pos:    vec()
    drag:   null
    hover:  null
    touch:  null

bot  = null 
snd  = null
dbg  = null
grph = null
