###
0000000     0000000   000000000
000   000  000   000     000   
000   000  000   000     000   
000   000  000   000     000   
0000000     0000000      000   
###

class Dot
    
    constructor: (@v) ->
        
        @minUnits = 12 # minimum number of units to allow linking other dots 
        
        @own = ''
        @units = 0
        @targetUnits = 0
        
        @n = []
        @i = world.dots.length
                            
        @v.norm()
        @g = add 'g'
        @c = app @g, 'circle', class:'dot', id:@i, cx:0, cy:0, r:1.3
        @c.dot = @
        world.dots.push @
        
    # 000000000  000  00     00  00000000  00000000   
    #    000     000  000   000  000       000   000  
    #    000     000  000000000  0000000   0000000    
    #    000     000  000 0 000  000       000   000  
    #    000     000  000   000  00000000  000   000  
    
    startTimer: (units, @snd='send', @cst=0) ->
        
        @targetUnits += units
        clearInterval @timer
        @timer = setInterval @onTimer, 160
        
    onTimer: => 
        
        return if world.pause
        
        snd.play @own, @snd, @cst
        
        if @targetUnits > @units
            @units += 10
            if @units >= @targetUnits
                @units = @targetUnits
        else
            @units -= 10
            if @units <= @targetUnits
                @units = @targetUnits

        if @units == @targetUnits
            clearInterval @timer
            delete @timer
                
        if @units == 0
            @unlink()
            
        @drawPie()
        
    setUnits: (@units) -> 
        
        @targetUnits = @units
        @drawPie()
        
    addUnit: (num=1) ->

        if num != 0
            @targetUnits = clamp 0, 360, @targetUnits + num
            @units       = clamp 0, 360, @units + num
            @drawPie()
        
    drawPie: ->
        
        if not @pie then @pie = app @g, 'path', class:'pie'
        
        #A rx ry x-axis-rotation large-arc-flag sweep-flag x y
        if @units < @minUnits
            @c.classList.remove 'linked'
            s =  0
            c = -1
            @pie.setAttribute 'd', "M0,-1 A1,1 0 1,0 0,1 A1,1 0 0,0 0,-1 z"
        else
            @c.classList.add 'linked'
            s =   Math.sin d2r @units
            c = - Math.cos d2r @units
            f = @units <= 180 and '1,0' or '0,0'
            @pie.setAttribute 'd', "M0,0 L0,-1 A1,1 0 #{f} #{s},#{c} z"
            
    depth:      -> (@v.z+1)/2
    zdepth:     -> @depth()
    radius:     -> ((@depth() + 0.3)/1.5) * screen.radius/20
    raise:      -> @g.parentNode.appendChild @g
    closest:    -> world.dots.slice(0).sort((a,d) => @dist(a)-@dist(d)).slice 1
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
        
        if d == @ or @targetUnits < @minUnits or @linked d
            return
            
        cost = 0.5 * r2d(@dist d) / 180
        if d.own == @own
            cost = 0
            
        ul = Math.ceil @targetUnits * 0.5
        uh = Math.ceil ul * (1-cost)

        if cost == 0
            if d.targetUnits + uh > 360
                tooMuch = d.targetUnits + uh - 360
                uh -= tooMuch
                ul -= tooMuch
                                
        ou = uh
                        
        if d.own != '' and d.own != @own
            ou = -uh
            new Sprk @, ul
            if uh == d.targetUnits
                sound = 'draw'
                new Sprk d, uh
            else if uh < d.targetUnits
                sound = 'lost'
                new Sprk d, uh
            else 
                sound = 'won'
                lnk = 1
                ou = uh - d.targetUnits
                new Sprk d, d.targetUnits               
                d.unlink() 
                d.setOwn @own
        else
            lnk = 1
            sound = 'send'
            d.setOwn @own 
            new Sprk d, Math.floor ul * cost
        
        @startTimer  -ul, sound, parseInt cost*18
        d.startTimer ou
        
        if lnk
            world.update = 1
            new Line @, d
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
        
        oldTarget = world.tmpline.usr?.e
        delTmpl 'usr'

        if mouse.touch and mouse.touch != @ and not @linked mouse.touch
            tgt = mouse.touch
        else
            dist = (d) -> v.angle d.v
            clos = world.dots.slice(0).sort (a,b) => dist(a)-dist(b)
            tgt = clos[0]
        
        if tgt != @ and not @linked tgt
            target = tgt
            if oldTarget != target
                snd.play 'line', 'won', parseInt 0.1 * r2d @dist target
        else
            target = 
                v: v
                depth: -> (v.z+1)/2
                
        world.tmpline.usr = new Line @, target, true
        
    rot: (q) -> @v = q.rotate @v
        
    upd: ->
        p = u2s @v
        @g.setAttribute 'transform', "translate(#{p.x},#{p.y}) scale(#{@radius()})"
        brightness @
            