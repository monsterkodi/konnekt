###
 0000000   000       0000000   0000000    
000        000      000   000  000   000  
000  0000  000      000   000  0000000    
000   000  000      000   000  000   000  
 0000000   0000000   0000000   0000000    
###

win   = window
main  = document.getElementById 'main'
svg   = main.children[0]
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
    lines:    []
    templine: {}
    userRot:  new Quat
    inertRot: new Quat
    circle:   null
    rotSum:   vec()
    
mouse = 
    pos:    vec()
    drag:   null
    hover:  null

bot = null 
snd = null
dbg = null
