###
0000000     0000000   000000000
000   000  000   000     000   
0000000    000   000     000   
000   000  000   000     000   
0000000     0000000      000   
###

class Bot

    constructor: () ->
        
        @speed = 4
        @tsum  = 0

    tmpl: (d,c) ->

        delTmpl 'bot'
        d.c.classList.add 'src'
        world.tmpline.bot = new Line d, c, true
        world.update = 1
        
    anim: (dta) ->
        
        @tsum += dta
                    
        if @tsum > @speed * 60
            
            dots = world.dots.filter (d) -> d.own == 'bot'
            @tsum = 0
                            
            dots.sort (a,b) -> b.units - a.units
            
            d = dots[0]
            cls = d.closest()
            
            for c in cls
                if not d.linked c
                    d.link c
                    @tmpl d, c
                    return
            