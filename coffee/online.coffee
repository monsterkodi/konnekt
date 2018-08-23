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
sw=0
sh=0
lst=0

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

w.addEventListener 'resize', size
    
l = elem 'path'
c = elem 'ellipse'

svg.appendChild l
svg.appendChild c

anim = (now) ->

    while svg.children.length > 2
        svg.lastChild.remove()
    
    d = now-lst
    s1 = Math.sin now/5000
    c1 = Math.cos now/5000
    s2 = Math.sin now/100
    c2 = Math.cos now/100
    
    lp = [[c1, s1], [0.5, 0.5], [0.2, 0.2], [-c1, -s1]]
    
    c.setAttribute 'cx', cx
    c.setAttribute 'cy', cy
    c.setAttribute 'rx', rx
    c.setAttribute 'ry', ry
    
    for x in lp
        svg.appendChild elem 'circle', cx:cx+x[0]*rx, cy:cy+x[1]*ry, r:sh/100, fill:'white'
    
    l.setAttribute 'd', "M " + (lp.map (p) -> "#{cx+p[0]*rx} #{cy+p[1]*ry}" ).join ' T '
        
    w.requestAnimationFrame anim
    lst=now
        
w.requestAnimationFrame anim
    
