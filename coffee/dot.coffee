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
        @c = app @g, 'circle', class:'dot', id:@i, cx:0, cy:0, r:1.3
        @c.dot = @
        dt.push @
        
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
    closest:    -> dt.slice(0).sort((a,b) => @dist(a)-@dist(b)).slice 1
    dist:   (d) -> @v.angle d.v

    neutralize: ->
        @own = ''
        @units = 0
        @targetUnits = 0
        @c.classList.remove 'bot'
        @c.classList.remove 'usr'
    
    linked: (d) -> (d in @n) or (@ in d.n)
    unlink: () ->
        log 'unlink', lt.length, @
        lt = lt.filter (l) => 
            if l.s == @ or l.e == @
                log 'remove l1ne', l
                l.e.n = l.e.n.filter (n) -> n != @
                l.s.n = l.s.n.filter (n) -> n != @
                l.c.remove()
                log 'remove line', l
                false
            else
                true
        log 'unlink', lt.length, @
        @n = []
        @neutralize()
            
    link: (d) ->
        
        if d == @
            log 'self?'
            return
            
        if @linked d
            log 'linked?'
            return
        
        if @units < @minUnits
            log 'empty!'
            return
            
        uh = ceil @units/2
        ou = uh
                        
        if d.own != '' and d.own != @own
            log 'attack!', @, d
            ou = -uh
            if uh == d.targetUnits
                log 'draw!'                
            else if uh < d.targetUnits
                log 'lost!'
            else 
                lnk = true
                d.unlink() 
                d.setOwn @own
                ou = uh - d.targetUnits
                log 'won!'
        else
            lnk = true
            d.setOwn @own 
        
        @startTimer  -uh
        d.startTimer ou
        
        if lnk
            @n.push d
            d.n.push @
            l = new Line @, d
            lt.push l
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
        @g.setAttribute 'transform', "translate(#{cx+@v.x*rd},#{cy+@v.y*rd}) scale(#{((@depth() + 0.3)/1.5)*rd/20})"
        brightness @
            