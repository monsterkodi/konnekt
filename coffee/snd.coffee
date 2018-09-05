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
        @tch = {}
        @osc = []
        
        @ctx = new (window.AudioContext || window.webkitAudioContext)()
        
        @gain = @ctx.createGain()
        @gain.connect @ctx.destination
        
        instrument = 
            instrument: 'bell3'
            noteName:   'C4'
            sampleRate: 44100
            duration:   0.4
            
        @synth = new Synth instrument, @ctx, @gain
        
        @addOsc 'sine'
        @addOsc 'sine'
        @addOsc 'sawtooth'
        @addOsc 'triangle'
                
    addOsc: (type) ->
        osc = @ctx.createOscillator()
        osc.frequency.setValueAtTime 0, @ctx.currentTime
        osc.type = type
        osc.connect @gain
        osc.start()
        @osc.push osc
        
    tick: ->
        for n,d of @tch
            if d <= 0
                switch n
                    when 'send bot'                        then @freq 0
                    when 'send usr'                        then @freq 1
                    when 'won bot', 'lost bot', 'draw bot' then @freq 2
                    when 'won usr', 'lost usr', 'draw usr' then @freq 3
                delete @tch[n]
                return
            else
                switch n
                    when 'send bot'   then @freq 0, randr 120,  160
                    when 'send usr'   then @freq 1, randr 1000, 2000
                    when 'won bot'    then @freq 2, randr 120,  1000
                    when 'draw bot'   then @freq 2, randr 120,  220
                    when 'lost bot'   then @freq 2, randr 140,  180
                    when 'won usr'    then @freq 3, randr 1100, 3000
                    when 'draw usr'   then @freq 3, randr 1100, 2200
                    when 'lost usr'   then @freq 3, randr 1000, 1100
            @tch[n] = d-1
     
    freq: (i,f=0) -> @osc[i].frequency.setValueAtTime f, @ctx.currentTime
    
    volDown: => if @vol < 0.0625 then @volume 0 else @volume @vol/2
    volUp: => @volume clamp 0.03125, 1, @vol*2
    volume: (@vol) -> 
        menuVolume @vol
        @gain.gain.value = @vol
        pref.set 'volume', @vol
        
    play: (n) ->
        
        @synth.playNote 'C4'
        
        d = switch n
            when 'send bot', 'send usr' then 6
            when 'won bot', 'won usr'   then 20
            when 'lost bot', 'lost usr' then 10
            when 'draw bot', 'draw usr' then 5
            else
                1
        
        @tch[n] = d
        
