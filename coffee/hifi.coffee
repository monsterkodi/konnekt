###
000   000  000  00000000  000
000   000  000  000       000
000000000  000  000000    000
000   000  000  000       000
000   000  000  000       000
###

# frequencies = [
        # 65.41, 73.42, 82.41, 87.31, 98.00, 110.00, 123.47,
        # 130.81, 146.83, 164.81, 174.61, 196.00, 220.00, 246.94,
        # 261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88,
        # 523.25, 587.33, 659.25, 698.46, 783.99, 880.00, 987.77,
        # 1046.50, 1174.66, 1318.51, 1396.91, 1567.98, 1760.00, 1975.53
    # ]
    
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
        