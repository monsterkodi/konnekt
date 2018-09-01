###
 0000000  00000000   00000000   000   000
000       000   000  000   000  000  000 
0000000   00000000   0000000    0000000  
     000  000        000   000  000  000 
0000000   000        000   000  000   000
###

class Sprk

    constructor: (@dot, @units) ->
        
        @ticks = 0
        @sparks = []
        @g = add 'g'
        for i in [0...@units]
            @sparks.push app @g, 'circle', class:"spark #{@dot.own}", r:screen.radius/60
            
        world.sparks.push @
        
    upd: ->
        
        p = u2s @dot.v
        @g.setAttribute 'transform', "translate(#{p.x}, #{p.y})"
        
        z = 0.5+@dot.depth()*0.5
        
        if not world.pause
            @ticks += 1
            
        mu = max 10*@units, 120
        if @ticks > mu
            for s in @sparks
                s.remove()
            world.sparks.splice world.sparks.indexOf(@), 1
        else
            angle = 0
            f = @ticks/mu            
            for s in @sparks
                angle += 2 * PI / @sparks.length
                v = vec cos(angle), sin(angle)
                v.mul mu * f * z * screen.radius / 600
                s.setAttribute 'r', (0.5+0.5*f) * z * screen.radius / 60
                s.setAttribute 'opacity', cos f * PI
                s.setAttribute 'cx', v.x
                s.setAttribute 'cy', v.y
    
        