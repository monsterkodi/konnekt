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
    
lp = [[1,0], [0.5, 0.5, 'Q'], [0.2, 0.2], [-0.5, -0.5, 'T'], [-1, 0]]
    
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
    
anim = (now) ->

    while svg.children.length > 2
        svg.lastChild.remove()
    
    c.setAttribute 'cx', cx
    c.setAttribute 'cy', cy
    c.setAttribute 'rx', rx
    c.setAttribute 'ry', ry
    
    for i in [0...lp.length]
        x = lp[i]
        dot = svg.appendChild elem 'circle', class:'dot', id:i, cx:cx+x[0]*rx, cy:cy+x[1]*ry, r:sh/100, fill:'white'
    
    svg.appendChild elem 'circle', cx:mx, cy:my, r:sh/200, stroke:'red', fill:'red', style:"pointer-events:none"
    
    # minDist = 2e+20
    # for i in [1...lp.length]
        # a = lp[i-1]
        # b = lp[i]
        # d = dist a, b, [mx, my]
        # if d < minDist
            # minL = i
            
    # log 'minL', minL
            
    l.setAttribute 'd', "M " + (lp.map (x) -> "#{x[2] ? ' '}#{cx+x[0]*rx} #{cy+x[1]*ry} ").join '' 
        
    w.requestAnimationFrame anim
    lst=now
        
w.requestAnimationFrame anim
    

# deCasteljauPos: (index, point, factor) ->
#     
    # thisp = @posAt index
    # prevp = @posAt index-1
#     
    # switch point[0]
        # when 'C'
            # ctrl1 = @posAt index, 'ctrl1'
            # ctrl2 = @posAt index, 'ctrl2'
        # when 'Q'
            # ctrl1 = @posAt index, 'ctrlq'
            # ctrl2 = ctrl1
        # when 'S'
            # ctrl1 = @posAt index, 'ctrlr'
            # ctrl2 = @posAt index, 'ctrls'

    # p1 = prevp.interpolate ctrl1, factor
    # p2 = ctrl1.interpolate ctrl2, factor
    # p3 = ctrl2.interpolate thisp, factor
#     
    # p4 = p1.interpolate p2, factor
    # p5 = p2.interpolate p3, factor
    # p6 = p4.interpolate p5, factor

# deCasteljau: (index, point) ->
#     
    # thisp = @posAt index
    # prevp = @posAt index-1
#     
    # ctrl1 = @posAt index, 'ctrl1'
    # ctrl2 = @posAt index, 'ctrl2'

    # p23 = ctrl1.mid ctrl2
    # p12 = prevp.mid ctrl1
    # p34 = thisp.mid ctrl2
#     
    # p123  = p12.mid p23
    # p234  = p23.mid p34
    # p1234 = p123.mid p234
#     
    # point[1] = p12.x
    # point[2] = p12.y
    # point[3] = p123.x
    # point[4] = p123.y
    # point[5] = p1234.x
    # point[6] = p1234.y
#     
    # ['C', p234.x, p234.y, p34.x, p34.y, thisp.x, thisp.y]