###
 0000000  00000000   00000000   000   000
000       000   000  000   000  000  000 
0000000   00000000   0000000    0000000  
     000  000        000   000  000  000 
0000000   000        000   000  000   000
###

class Sprk

    constructor: (d, units) ->
        
        @ticks = 0
        @sparks = []
        @orig = u2s d.v
        for i in [0...units]
            @sparks.push add 'circle', class:"spark #{d.own}", r:screen.radius/60
            
        window.requestAnimationFrame @anim
        
    anim: =>
        
        @ticks += 1
        if @ticks > 60
            for s in @sparks
                s.remove()
        else
            angle = 0
            f = @ticks/120
            for s in @sparks
                angle += 2 * PI / @sparks.length
                v = vec cos(angle), sin(angle)
                v.mul 200*f
                v.add @orig
                s.setAttribute 'opacity', cos f * PI
                s.setAttribute 'cx', v.x
                s.setAttribute 'cy', v.y
                
            window.requestAnimationFrame @anim
            
    
        