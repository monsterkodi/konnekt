###
0000000     0000000   000000000
000   000  000   000     000   
0000000    000   000     000   
000   000  000   000     000   
0000000     0000000      000   
###

class Bot

    constructor: (dot) ->
        
        dot.setOwn 'bot'
        dot.startTimer 360
        @delay = 240
        @tsum  = 0

    anim: (dta) ->
        
        @tsum += dta
                    
        if @tsum > @delay
            
            dots = dt.filter (d) -> d.own == 'bot'
            @tsum = 0
            
            if dots.length == 0
                log 'WON!'
                reset()
                return
                
            dots.sort (a,b) -> b.units - a.units
            
            d = dots[0]
            cls = d.closest()
            
            for c in cls
                if not d.linked c
                    if d.link c
                        @delay = 300
                    else
                        @delay = 120
                    break
            