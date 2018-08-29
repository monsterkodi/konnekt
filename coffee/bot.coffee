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
        @dots  = [dot]
        @delay = 240
        @tsum  = 0

    anim: (dta) ->
        @tsum += dta
        # log "bot anim #{dta}"
        if @tsum > @delay
            @tsum = 0
            @dots = @dots.filter (d) -> d.own == 'bot'
            @dots.sort (a,b) -> b.units - a.units
            d = @dots[0]
            log "units: #{d.units}"
            cls = d.closest()
            for c in cls
                if not d.linked c
                    if d.link c
                        @dots.push c
                        @delay = 300
                    else
                        @delay = 120
                    break
            