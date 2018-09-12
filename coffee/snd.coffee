###
 0000000  000   000  0000000  
000       0000  000  000   000
0000000   000 0 000  000   000
     000  000  0000  000   000
0000000   000   000  0000000  
###

class Snd

    constructor: () ->

        @vol = 0
        
        @ctx = new (window.AudioContext || window.webkitAudioContext)()
        
        @gain = @ctx.createGain()
        @gain.connect @ctx.destination
        
        # piano1, piano2, piano3, piano4, piano5
        # string1, string2, flute
        # bell1, bell2, bell3, bell4
        # organ1, organ2
        
        @synt = {}
        @setSynt
            bot:  instrument: 'bell3'
            usr:  instrument: 'bell3'
            menu: instrument: 'string'
            line: instrument: 'flute'

    play: (o,n,c=0) ->
        
        @synt[o].playNote switch n
            when 'draw' then 3*12+c+parseInt randr 0,2
            when 'send' then 4*12+c+parseInt randr 0,2
            when 'won'  then 5*12+c+parseInt randr 0,4
            when 'lost' then 6*12+c+parseInt randr 0,2
            
    setSynt: (synt) ->
        # log 'setSynt', JSON.stringify synt
        for k,v of synt
            @synt[k] = new Synt v, @ctx, @gain
                     
    volDown: => if @vol < 0.0625 then @volume 0 else @volume @vol/2
    volUp: => @volume clamp 0.03125, 1, @vol*2
    volume: (@vol) -> 
        menuVolume @vol
        @gain.gain.value = @vol
        pref.set 'volume', @vol
        
        
