###
 0000000  000   000  0000000  
000       0000  000  000   000
0000000   000 0 000  000   000
     000  000  0000  000   000
0000000   000   000  0000000  
###

# frequencies = [
        # 65.41, 73.42, 82.41, 87.31, 98.00, 110.00, 123.47,
        # 130.81, 146.83, 164.81, 174.61, 196.00, 220.00, 246.94,
        # 261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88,
        # 523.25, 587.33, 659.25, 698.46, 783.99, 880.00, 987.77,
        # 1046.50, 1174.66, 1318.51, 1396.91, 1567.98, 1760.00, 1975.53
    # ]

class Snd

    constructor: () ->

        @vol = 0
        @tch = {}
        @osc = []
        
        @ctx = new (window.AudioContext || window.webkitAudioContext)()
        time = @ctx.currentTime
        
        @gain = @ctx.createGain()
        @gain.connect @ctx.destination
        @volume @vol   
        
        @addOsc()
        @addOsc()
        @addOsc 'sawtooth'
        @addOsc 'triangle'
        
        # @lfo = @ctx.createOscillator()
        # @lfo.type = 'sine'
        # @lfg = @ctx.createGain()
        # @lfg.gain.setValueAtTime 1, time
        # @lfo.start()
        # @lfo.connect @lfg
#         
        # @flt = @ctx.createBiquadFilter()
        # @flt.type = "bandpass"
        # @flt.frequency.setValueAtTime 850, time
#         
        # @lfg.connect @flt.gain
        # @flt.connect @gain
#         
        # @add = @ctx.createGain()
        # @add.gain.value = 1
        # @add.connect @flt
#         
        # @addOsc 'sine', @add
        # @addOsc 'sine', @add
        
    addOsc: (type='sine', target=@gain) ->
        osc = @ctx.createOscillator()
        osc.frequency.setValueAtTime 0, @ctx.currentTime
        osc.type = type
        osc.connect target
        osc.start()
        @osc.push osc
        
    # envelope: (gain, time, volume, attack, sustain, release) ->
#         
        # gain.gain.cancelScheduledValues time
        # gain.gain.value = volume
        # gain.gain.setValueAtTime 0, time
        # gain.gain.linearRampToValueAtTime volume, time + attack
        # gain.gain.linearRampToValueAtTime volume, time + attack + sustain
        # gain.gain.linearRampToValueAtTime 0, time + attack + sustain + release
     
    # note: (note, attack=0.02, sustain=0.2, release=0.1) ->
#         
        # time = @ctx.currentTime
#         
        # ni1 = round note
        # ni2 = ni1+[-4,-3,-2,-1,1,2,3,4][randi 0,7]
#         
        # freq1 = frequencies[clamp 0, 34, ni1]
#         
        # @osc[4].frequency.cancelScheduledValues time
        # @osc[5].frequency.cancelScheduledValues time
#         
        # log 'note', ni1, freq1, attack, sustain, release
        # @freq 4, freq1
        # @freq 5, freq1*randr 0.9, 1.1
        # @osc[5].frequency.linearRampToValueAtTime freq1*randr(0.9, 1.1), time+attack+sustain+release
        # @lfo.frequency.setValueAtTime randr(1,20), time
        # @envelope @add, time, 1, attack, sustain, release
        
    tick: ->
        # log @tch if @tch.length
        for n,d of @tch
            if d <= 0
                # log "del #{n} #{d}"
                switch n
                    when 'send bot'                        then @freq 0
                    when 'send usr'                        then @freq 1
                    when 'won bot', 'lost bot', 'draw bot' then @freq 2
                    when 'won usr', 'lost usr', 'draw usr' then @freq 3
                delete @tch[n]
                return
            else
                # log "play #{n} #{d}"
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
        menu.buttons.VOL?.innerHTML = "#{floor(@vol * 100) / 100}"
        @gain.gain.value = @vol
        pref.set 'volume', @vol
    
    touch: (n,d=1) -> 
        log "touch #{n} #{d}"
        @tch[n] = d
        
    play: (n) ->
        
        d = switch n
            when 'send bot', 'send usr' then 6
            when 'won bot', 'won usr'   then 20
            when 'lost bot', 'lost usr' then 10
            when 'draw bot', 'draw usr' then 5
            # when 'link bot', 'link usr' then 10
            else
                1
        
        @touch n, d
        
