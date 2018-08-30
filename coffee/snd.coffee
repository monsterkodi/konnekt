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
        
        @ctx = new (window.AudioContext || window.webkitAudioContext)()
        
        @gain = @ctx.createGain()
        @gain.connect @ctx.destination
        @volume @vol   

        @osc = [0,0,0,0]
        @osc[0] = @ctx.createOscillator()
        @osc[0].type = 'sine'
        @osc[0].connect @gain
        @osc[0].start()
        @freq 0
        
        @osc[1] = @ctx.createOscillator()
        @osc[1].type = 'sine'
        @osc[1].connect @gain
        @osc[1].start()
        @freq 1
        
        @osc[2] = @ctx.createOscillator()
        @osc[2].type = 'sawtooth'
        @osc[2].connect @gain
        @osc[2].start()
        @freq 2

        @osc[3] = @ctx.createOscillator()
        @osc[3].type = 'triangle'
        @osc[3].connect @gain
        @osc[3].start()
        @freq 3
        
    tick: ->
        # log @tch if @tch.length
        for n,d of @tch
            if d <= 0
                # log "del #{n} #{d}"
                switch n
                    when 'send bot'             then @freq 0
                    when 'send usr'             then @freq 1
                    when 'won bot', 'lost bot', 'draw bot' then @freq 2
                    when 'won usr', 'lost usr', 'draw usr' then @freq 3
                delete @tch[n]
                return
            else
                # log "play #{n} #{d}"
                switch n
                    when 'send bot'   then @freq 0, randr 120,  160
                    when 'send usr'   then @freq 1, randr 1000, 2000
                    when 'won bot'    then @freq 2, randr 120, 1000
                    when 'draw bot'   then @freq 2, randr 120, 220
                    when 'lost bot'   then @freq 2, randr 140, 180
                    when 'won usr'    then @freq 3, randr 1100, 3000
                    when 'draw usr'   then @freq 3, randr 1100, 2200
                    when 'lost usr'   then @freq 3, randr 1000, 1100
            @tch[n] = d-1
     
    volDown: => if @vol < 0.0625 then @volume 0 else @volume @vol/2
    volUp: => @volume clamp 0.03125, 1, @vol*2
    volume: (@vol) -> cnt.vol?.innerHTML = "VOL #{floor(@vol * 100) / 100}"; @gain.gain.value = @vol
    freq: (i,f=0) -> @osc[i].frequency.setValueAtTime f, @ctx.currentTime
    
    touch: (n,d=1) -> @tch[n] = d
        
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
        
