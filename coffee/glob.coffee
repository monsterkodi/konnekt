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
svg  = main.children[0]

rx=ry = 0
cx=cy = 0
sw=sh = 0
mx=my = 0
rd    = 0
lst   = 0
upd   = 1
drg   = null
iq    = new Quat
rq    = new Quat
dt    = []
lt    = []
cr    = null
dbg   = null
tmpl  = null
rsum  = vec()
