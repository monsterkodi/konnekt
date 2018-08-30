###
0000000     0000000   000000000
000   000  000   000     000   
000   000  000   000     000   
000   000  000   000     000   
0000000     0000000      000   
###

class Dot
    
    constructor: ->
        
        @minUnits = 12 # minimum number of units to allow linking other dots 
        
        @own = ''
        @units = 0
        @targetUnits = 0
        
        @n = []
        @i = world.dots.length
        
        @v = vec(randr(-1,1), randr(-1,1), randr(-1,1)).norm()
        
        while true
            ok = true 
            for d in world.dots
                if @dist(d) < 0.2
                    @v = vec(randr(-1,1), randr(-1,1), randr(-1,1)).norm()
                    ok = false
                    break
            if ok 
                break
            
        @v.norm()
        @g = add 'g'
        @c = app @g, 'circle', class:'dot', id:@i, cx:0, cy:0, r:1.3
        @c.dot = @
        world.dots.push @
        
    startTimer: (units) ->
        
        @targetUnits += units
        @timer = setInterval @onTimer, 100
        if not @pie
            @pie = app @g, 'path', class:'pie'
        
    onTimer: => 
        
        if @targetUnits > @units
            @units += 10
            if @units >= @targetUnits
                @units = @targetUnits
                clearInterval @timer
                delete @timer
        else
            @units -= 10
            if @units <= @targetUnits
                @units = @targetUnits
                clearInterval @timer
                delete @timer
            
        if @units == 0
            @unlink()
            
        @drawPie()
        
    addUnit: ->
        if @targetUnits < 360 and @units > @minUnits
            @targetUnits += 1
            @units += 1
            @drawPie()
        
    drawPie: ->
        #A rx ry x-axis-rotation large-arc-flag sweep-flag x y
        if @units <= @minUnits
            @c.classList.remove 'linked'
            s =  0
            c = -1
            @pie.setAttribute 'd', "M0,-1 A1,1 0 1,0 0,1 A1,1 0 0,0 0,-1 z"
        else
            @c.classList.add 'linked'
            s =   sin d2r @units
            c = - cos d2r @units
            f = @units <= 180 and '1,0' or '0,0'
            @pie.setAttribute 'd', "M0,0 L0,-1 A1,1 0 #{f} #{s},#{c} z"
            
        # log "onTimer own:'#{@own}' class:'#{@c.getAttribute'class'}'"
        
    depth:      -> (@v.z+1)/2
    zdepth:     -> @depth()
    raise:      -> @g.parentNode.appendChild @g
    closest:    -> world.dots.slice(0).sort((a,b) => @dist(a)-@dist(b)).slice 1
    dist:   (d) -> @v.angle d.v

    neutralize: ->
        @own = ''
        @units = 0
        @targetUnits = 0
        @c.classList.remove 'bot'
        @c.classList.remove 'usr'
    
    linked: (d) -> (d in @n) or (@ in d.n)
    unlink: () ->
        world.lines = world.lines.filter (l) => 
            if l.s == @ or l.e == @
                l.e.n = l.e.n.filter (n) => n != @
                l.s.n = l.s.n.filter (n) => n != @
                l.c.remove()
                false
            else
                true
        @n = []
        @neutralize()
            
    # 000      000  000   000  000   000  
    # 000      000  0000  000  000  000   
    # 000      000  000 0 000  0000000    
    # 000      000  000  0000  000  000   
    # 0000000  000  000   000  000   000  
    
    link: (d) ->
        
        if d == @
            log 'self?'
            return
            
        if @linked d
            log 'linked?'
            return
        
        if @units < @minUnits
            # log 'empty!'
            return
            
        uh = ceil @units/2
        ou = uh
                        
        if d.own != '' and d.own != @own
            ou = -uh
            if uh == d.targetUnits
                log 'draw!'                
            else if uh < d.targetUnits
                log 'lost!'
            else 
                lnk = true
                ou = uh - d.targetUnits
                d.unlink() 
                d.setOwn @own
        else
            lnk = true
            d.setOwn @own 
        
        @startTimer  -uh
        d.startTimer ou
        
        if lnk
            @n.push d
            d.n.push @
            l = new Line @, d
            world.lines.push l
            upd = 1
            l
        else
            null
               
    setOwn: (@own) -> 
        @c.classList.toggle 'bot', @own == 'bot'
        @c.classList.toggle 'usr', @own == 'usr'
        
    #  0000000  00000000  000   000  0000000    
    # 000       000       0000  000  000   000  
    # 0000000   0000000   000 0 000  000   000  
    #      000  000       000  0000  000   000  
    # 0000000   00000000  000   000  0000000    
    
    send: (v) -> 
        
        dist = (d) -> v.dist u2s d.v
        clos = world.dots.slice(0).sort (a,b) => dist(a)-dist(b)
        delTmpl()
        if clos[0] == @
            slp dbg, [v, v]
        else
            slp dbg, [u2s(@v), u2s(@v)]    
            l = add 'path', class:'path', stroke:"#ff0", 'stroke-width':2, 'stroke-linejoin':"round", 'stroke-linecap':"round", style:'pointer-events:none'
            l.setAttribute 'd', arc @v, clos[0].v
            l.dot = clos[0]
            tmpl = l
        
    rot: (q) -> @v = q.rotate @v
        
    upd: ->
        p = u2s @v
        @g.setAttribute 'transform', "translate(#{p.x},#{p.y}) scale(#{((@depth() + 0.3)/1.5)*screen.radius/20})"
        brightness @
            