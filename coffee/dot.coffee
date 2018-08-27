###
0000000     0000000   000000000
000   000  000   000     000   
000   000  000   000     000   
000   000  000   000     000   
0000000     0000000      000   
###

class Dot
    
    constructor: ->
        
        @n = []
        @i = dt.length
        
        @v = vec(randr(-1,1), randr(-1,1), randr(-1,1)).norm()
        
        while true
            ok = true 
            for d in dt
                if @dist(d) < 0.2
                    @v = vec(randr(-1,1), randr(-1,1), randr(-1,1)).norm()
                    ok = false
                    break
            if ok 
                break
            
        @v.norm()
        @g = add 'g'
        @c = app @g, 'circle', class:'dot neutral', id:@i, cx:cx+@v.x*rx, cy:cy+@v.y*rx, r:(@v.z+1.1)*rd/50
        @c.dot = @
        dt.push @
        
    depth:      -> (@v.z+1)/2
    raise:      -> @g.parentNode.appendChild @g
    closest:    -> dt.slice(0).sort((a,b) => @dist(a)-@dist(b)).slice 1
    dist:   (d) -> @v.angle d.v
    linked: (d) -> d==undefined or d==@ or (d in @n) or (@ in d.n)
    link: -> 
        @c.classList.remove 'neutral'
        @c.classList.add 'linked'
        log @c.className
        
    line: (d) -> 
        if d == @
            log 'self?'
            return
        if @linked d
            log 'linked?'
            return
        @link()
        d.link()
        @n.push d
        d.n.push @
        l = new Line @, d
        lt.push l
        l
        
    #  0000000  00000000  000   000  0000000    
    # 000       000       0000  000  000   000  
    # 0000000   0000000   000 0 000  000   000  
    #      000  000       000  0000  000   000  
    # 0000000   00000000  000   000  0000000    
    
    send: (v) -> 
        
        dist = (d) -> v.dist u2s d.v
        clos = dt.slice(0).sort (a,b) => dist(a)-dist(b)
        delTmpl()
        if clos[0] == @
            slp dbg, [u2s(@v), v]        
        else
            slp dbg, [u2s(@v), u2s(@v)]    
            l = add 'path', class:'path', stroke:"#ff0", 'stroke-width':2, 'stroke-linejoin':"round", 'stroke-linecap':"round", style:'pointer-events:none'
            l.setAttribute 'd', arc @v, clos[0].v
            l.dot = clos[0]
            tmpl = l
        
    rot: (q) -> @v = q.rotate @v
        
    upd: ->
        
        @c.setAttribute 'cx', cx+@v.x*rd
        @c.setAttribute 'cy', cy+@v.y*rd
        
        if @c.classList.contains 'neutral'
            @c.setAttribute 'fill', 'black'
        else
            @c.setAttribute 'fill', color @
        @c.setAttribute 'r', ((@depth() + 0.3)/1.5)*rd/20
        