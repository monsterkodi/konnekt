###
 0000000  000   000  000   000  000000000
000        000 000   0000  000     000   
0000000     00000    000 0 000     000   
     000     000     000  0000     000   
0000000      000     000   000     000   
###

# piano1, piano2, piano3, piano4, piano5
# string, flute
# bell1, bell2, bell3, bell4
# organ1, organ2

class Synt
          
    constructor: (@config, @ctx, @gain) ->
        
        # 0 1  2 3  4 5 6  7 8  9 10 11
        # C Cs D Ds E F Fs G Gs A As B
    
        @freqs = [
            4186.01  
            4434.92  
            4698.63  
            4978.03  
            5274.04  
            5587.65  
            5919.91  
            6271.93  
            6644.88  
            7040.00  
            7458.62  
            7902.13
        ]
        
        @config.duration ?= 0.3
        @isr = 1.0/44100
        @initBuffers()
            
    initBuffers: ->
        
        @sampleLength = @config.duration*44100  
        @sampleLength = Math.floor @sampleLength
        @createBuffers()
        
    createBuffers: -> @samples = new Array 108        
        
    playNote: (noteIndex) ->
        
        log "index #{noteIndex}"
        if not @samples[noteIndex]?
            
            @samples[noteIndex] = new Float32Array @sampleLength
            
            frequency = @freq noteIndex
            log @config.instrument, noteIndex, frequency
            w = 2.0 * Math.PI * frequency
            func = @[@config.instrument]
            for sampleIndex in [0...@sampleLength]
                x = sampleIndex/(@sampleLength-1)
                @samples[noteIndex][sampleIndex] = func sampleIndex*@isr, w, x
            
        sample = @samples[noteIndex]
        audioBuffer = @ctx.createBuffer 1, sample.length, 44100
        buffer = audioBuffer.getChannelData 0
        for i in [0...sample.length]
            buffer[i] = sample[i]
        
        node = @ctx.createBufferSource()
        node.buffer = audioBuffer
        node.connect @gain
        node.state = node.noteOn
        node.start 0
                
    freq: (noteIndex) ->
        
        @freqs[noteIndex%12] / Math.pow(2, (8-noteIndex/12)).toFixed(3)
        
    setDuration: (v) ->
        
        if @config.duration != v
            @config.duration = v
            @initBuffers()
        
    fmod:  (x,y)   -> x%y
    sign:  (x)     -> (x>0.0) and 1.0 or -1.0
    frac:  (x)     -> x % 1.0
    sqr:   (a,x)   -> if Math.sin(x)>a then 1.0 else -1.0    
    step:  (a,x)   -> (x>=a) and 1.0 or 0.0
    over:  (x,y)   -> 1.0 - (1.0-x)*(1.0-y)
    mix:   (a,b,x) -> a + (b-a) * Math.min(Math.max(x,0.0),1.0)

    saw: (x,a) ->
        f = x % 1.0
        if (f < a) then (f / a) else (1.0 - (f-a)/(1.0-a))

    grad: (n, x) ->
        n = (n << 13) ^ n
        n = (n * (n * n * 15731 + 789221) + 1376312589)
        if (n & 0x20000000) then -x else x

    noise: (x) ->
        i = Math.floor x
        f = x - i
        w = f*f*f*(f*(f*6.0-15.0)+10.0)
        a = @grad i+0, f+0.0
        b = @grad i+1, f-1.0
        a + (b-a)*w
    
###
000  000   000   0000000  000000000  00000000   000   000  00     00  00000000  000   000  000000000   0000000
000  0000  000  000          000     000   000  000   000  000   000  000       0000  000     000     000     
000  000 0 000  0000000      000     0000000    000   000  000000000  0000000   000 0 000     000     0000000 
000  000  0000       000     000     000   000  000   000  000 0 000  000       000  0000     000          000
000  000   000  0000000      000     000   000   0000000   000   000  00000000  000   000     000     0000000 
###
                                
    ###
    00000000   000   0000000   000   000   0000000 
    000   000  000  000   000  0000  000  000   000
    00000000   000  000000000  000 0 000  000   000
    000        000  000   000  000  0000  000   000
    000        000  000   000  000   000   0000000 
    ###

    piano1: (t, w, x) -> 
        
        wt = w*t
        y  = 0.6 * Math.sin(1.0*wt) * Math.exp(-0.0008*wt)
        y += 0.3 * Math.sin(2.0*wt) * Math.exp(-0.0010*wt)
        y += 0.1 * Math.sin(4.0*wt) * Math.exp(-0.0015*wt)
        y += 0.2*y*y*y
        y *= 0.9 + 0.1*Math.cos(70.0*t)
        y  = 2.0*y*Math.exp(-22.0*t) + y
        d = 0.8; if x > d then y *= Math.pow(1-(x-d)/(1-d), 2) # decay
        y
        
    piano2: (t, w, x) =>

        t    = t + .00015*@noise(12*t)
        rt   = t
        r    = t*w*.2
        r    = @fmod(r,1)
        a    = 0.15 + 0.6*(rt)
        b    = 0.65 - 0.5*(rt)
        y    = 50*r*(r-1)*(r-.2)*(r-a)*(r-b)
        r    = t*w*.401
        r    = @fmod(r,1)
        a    = 0.12 + 0.65*(rt)
        b    = 0.67 - 0.55*(rt)
        y2   = 50*r*(r-1)*(r-.4)*(r-a)*(r-b)
        r    = t*w*.399
        r    = @fmod(r,1)
        a    = 0.14 + 0.55*(rt)
        b    = 0.66 - 0.65*(rt)
        y3   = 50*r*(r-1)*(r-.8)*(r-a)*(r-b)
        y   += .02*@noise(1000*t)
        y   /= (t*w*.0015+.1)
        y2  /= (t*w*.0020+.1)
        y3  /= (t*w*.0025+.1)
        y    = (y+y2+y3)/3
        d = 0.8; if x > d then y *= Math.pow(1-(x-d)/(1-d), 2) # decay
        y

    piano3: (t, w, x) ->
        
        tt = 1-t
        a  = Math.sin(t*w*.5)*Math.log(t+0.3)*tt
        b  = Math.sin(t*w)*t*.4
        y  = (a+b)*tt
        d = 0.8; if x > d then y *= Math.pow(1-(x-d)/(1-d), 2) # decay
        y
        
    piano4: (t, w, x) ->
        
        y  = Math.sin(w*t)
        y *= 1-x*x*x*x

    piano5: (t, w, x) ->
        
        wt = w*t
        y  = 0.6*Math.sin(1.0*wt)*Math.exp(-0.0008*wt)
        y += 0.3*Math.sin(2.0*wt)*Math.exp(-0.0010*wt)
        y += 0.1*Math.sin(4.0*wt)*Math.exp(-0.0015*wt)
        y += 0.2*y*y*y
        y *= 0.5 + 0.5*Math.cos(70.0*t) # vibrato
        y  = 2.0*y*Math.exp(-22.0*t) + y
        y *= 1-x*x*x*x

    ###
     0000000   00000000    0000000    0000000   000   000
    000   000  000   000  000        000   000  0000  000
    000   000  0000000    000  0000  000000000  000 0 000
    000   000  000   000  000   000  000   000  000  0000
     0000000   000   000   0000000   000   000  000   000
    ###
    
    organ1: (t, w, x) ->

        y  = .6 * Math.cos(w*t)   * Math.exp(-4*t)
        y += .4 * Math.cos(2*w*t) * Math.exp(-3*t)
        y += .01* Math.cos(4*w*t) * Math.exp(-1*t)
        y = y*y*y + y*y*y*y*y + y*y
        a = .5+.5*Math.cos(3.14*x)
        y = Math.sin(y*a*3.14)
        y *= 20*t*Math.exp(-.1*x)

    organ2: (t, w, x) =>

        wt = w*t
        a1 = .5+.5*Math.cos(0+t*12)
        a2 = .5+.5*Math.cos(1+t*8)
        a3 = .5+.5*Math.cos(2+t*4)
        y  = @saw(0.2500*wt,a1)*Math.exp(-2*x)
        y += @saw(0.1250*wt,a2)*Math.exp(-3*x)
        y += @saw(0.0625*wt,a3)*Math.exp(-4*x)
        y *= 0.8+0.2*Math.cos(64*t)
        
    ###
    0000000    00000000  000      000    
    000   000  000       000      000    
    0000000    0000000   000      000    
    000   000  000       000      000    
    0000000    00000000  0000000  0000000
    ###
        
    bell1: (t, w, x) ->
        
        wt = w*t
        y  = 0.100 * Math.exp(-t/1.000) * Math.sin(0.56*wt)
        y += 0.067 * Math.exp(-t/0.900) * Math.sin(0.56*wt)
        y += 0.100 * Math.exp(-t/0.650) * Math.sin(0.92*wt)
        y += 0.180 * Math.exp(-t/0.550) * Math.sin(0.92*wt)
        y += 0.267 * Math.exp(-t/0.325) * Math.sin(1.19*wt)
        y += 0.167 * Math.exp(-t/0.350) * Math.sin(1.70*wt)
        y += 0.146 * Math.exp(-t/0.250) * Math.sin(2.00*wt)
        y += 0.133 * Math.exp(-t/0.200) * Math.sin(2.74*wt)
        y += 0.133 * Math.exp(-t/0.150) * Math.sin(3.00*wt)
        y += 0.100 * Math.exp(-t/0.100) * Math.sin(3.76*wt)
        y += 0.133 * Math.exp(-t/0.075) * Math.sin(4.07*wt)
        y *= 1-x*x*x*x

    bell2: (t, w, x) ->

        wt = w*t
        y  = 0.100 * Math.exp(-t/1.000) * Math.sin(0.56*wt)
        y += 0.067 * Math.exp(-t/0.900) * Math.sin(0.56*wt)
        y += 0.100 * Math.exp(-t/0.650) * Math.sin(0.92*wt)
        y += 0.180 * Math.exp(-t/0.550) * Math.sin(0.92*wt)
        y += 0.267 * Math.exp(-t/0.325) * Math.sin(1.19*wt)
        y += 0.167 * Math.exp(-t/0.350) * Math.sin(1.70*wt)
        y += 2.0*y*Math.exp(-22.0*t) # attack
        y *= 1-x*x*x*x


    bell3: (t, w, x) ->
        wt = w*t
        y  = 0
        y += 0.100 * Math.exp(-t/1)    * Math.sin(0.25*wt)
        y += 0.200 * Math.exp(-t/0.75) * Math.sin(0.50*wt)
        y += 0.400 * Math.exp(-t/0.5)  * Math.sin(1.00*wt)
        y += 0.200 * Math.exp(-t/0.25) * Math.sin(2.00*wt)
        y += 0.100 * Math.exp(-t/0.1)  * Math.sin(4.00*wt)
        y += 2.0*y*Math.exp(-22.0*t) # attack
        y *= 1-x*x*x*x

    bell4: (t, w, x) ->
        wt = w*t
        y  = 0
        y += 0.100 * Math.exp(-t/0.9) * Math.sin(0.62*wt)
        y += 0.200 * Math.exp(-t/0.7) * Math.sin(0.86*wt)
        y += 0.500 * Math.exp(-t/0.5) * Math.sin(1.00*wt)
        y += 0.200 * Math.exp(-t/0.2) * Math.sin(1.27*wt)
        y += 0.100 * Math.exp(-t/0.1) * Math.sin(1.40*wt)
        y += 2.0*y*Math.exp(-22.0*t) # attack
        y *= 1-x*x*x*x

    ###
     0000000  000000000  00000000   000  000   000   0000000 
    000          000     000   000  000  0000  000  000      
    0000000      000     0000000    000  000 0 000  000  0000
         000     000     000   000  000  000  0000  000   000
    0000000      000     000   000  000  000   000   0000000 
    ###

    string: (t, w, x) ->
         
        wt = w*t
        f  =     Math.sin(0.251*wt)*Math.PI
        y  = 0.5*Math.sin(1*wt+f)*Math.exp(-1.0*x)
        y += 0.4*Math.sin(2*wt+f)*Math.exp(-2.0*x)
        y += 0.3*Math.sin(4*wt+f)*Math.exp(-3.0*x)
        y += 0.2*Math.sin(8*wt+f)*Math.exp(-4.0*x)
        y += 1.0*y*Math.exp(-10.0*t) # attack
        y *= 1 - x*x*x*x # fade out
        y

    ###
    00000000  000      000   000  000000000  00000000
    000       000      000   000     000     000     
    000000    000      000   000     000     0000000 
    000       000      000   000     000     000     
    000       0000000   0000000      000     00000000
    ###

    flute: (t, w, x) ->

        y  = 6.0*x*Math.exp(-2*x)*Math.sin(w*t)
        y *= 0.6+0.4*Math.sin(32*(1-x))
        
        d = 0.87; if x > d then y *= Math.pow(1-(x-d)/(1-d), 2) # decay
        y

                                                                    
        