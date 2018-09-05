###
 0000000   00000000   00000000   000   000
000        000   000  000   000  000   000
000  0000  0000000    00000000   000000000
000   000  000   000  000        000   000
 0000000   000   000  000        000   000
###

class Grph

    constructor: ->
        @maxSmpl = 300
        @smpls = 
            bot: []
            usr: []
        @g = add 'g'
        @p =  
            bot: app @g, 'path', class:'grph bot'
            usr: app @g, 'path', class:'grph usr'
        
    sample: ->
        
        r2y = (r) -> (0.5-r)*60
        
        s = world.units.bot + world.units.usr
        for o in ['usr', 'bot']
            @smpls[o].push world.units[o]/s
            if @smpls[o].length > @maxSmpl
                @smpls[o].shift()
            d = "M 0 #{r2y @smpls[o][0]} "
            x = 0
            for smpl in @smpls[o]
                x += 1
                d += "L #{x} #{r2y smpl} "
            @p[o].setAttribute 'd', d
            
    plot: -> 
        
        @g.setAttribute 'transform', "translate(#{screen.size.x-60-@smpls.bot.length}, 47)"


