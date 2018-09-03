###
000      000  000   000  00000000  
000      000  0000  000  000       
000      000  000 0 000  0000000   
000      000  000  0000  000       
0000000  000  000   000  00000000  
###

class Line
    
    constructor: (@s,@e,tmp) ->
                
        @c = add 'path', class:'line'
        @c.classList.add @s.own if @s.own
        
        if tmp
            @c.classList.add 'tmp'
        else
            @s.n?.push @e
            @e.n?.push @s
            world.lines.push @
       
    del: -> @c.remove()
    depth: -> (@s.depth()+@e.depth())/2 
    zdepth: -> Math.min(@s.depth(),@e.depth()) - 0.001
    raise: -> @c.parentNode?.appendChild @c
    upd: ->
        
        @c.setAttribute 'd', arc @s.v, @e.v
        brightness @
        @c.style.strokeWidth = ((@depth() + 0.3)/1.5)*screen.radius/50
