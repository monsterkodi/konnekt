###
 0000000   000       0000000   0000000    
000        000      000   000  000   000  
000  0000  000      000   000  0000000    
000   000  000      000   000  000   000  
 0000000   0000000   0000000   0000000    
###

win  = window
main = document.getElementById 'main'
menu = main.children[1]
menu2 = main.children[2]
svg  = main.children[0]

screen = 
    size:    vec()
    center:  vec()
    radius:  0

world =
    dots:  []
    lines: []
    
mouse = vec()

lst   = 0
upd   = 1
drg   = null
snd   = null
iq    = new Quat
rq    = new Quat
cr    = null
dbg   = null
bot   = null 
tmpl  = null
rsum  = vec()
cnt   = {}
