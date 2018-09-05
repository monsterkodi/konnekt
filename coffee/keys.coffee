###
000   000  00000000  000   000   0000000
000  000   000        000 000   000     
0000000    0000000     00000    0000000 
000  000   000          000          000
000   000  00000000     000     0000000 
###

class Keyboard

    @noteNames = ['C', 'Cs', 'D', 'Ds', 'E', 'F', 'Fs', 'G', 'Gs', 'A', 'As', 'B']

    @notes = 
        C:    4186.01  
        Cs:   4434.92  
        D:    4698.63  
        Ds:   4978.03  
        E:    5274.04  
        F:    5587.65  
        Fs:   5919.91  
        G:    6271.93  
        Gs:   6644.88  
        A:    7040.00  
        As:   7458.62  
        B:    7902.13
        
    @keys = 
        C:    'z'
        Cs:   's'
        D:    'x'
        Ds:   'd'
        E:    'c'
        F:    'v'
        Fs:   'g'
        G:    'b'
        Gs:   'h'
        A:    'n'
        As:   'j'
        B:    'm'

    @allFreq: =>
        if not @allFreq_?
            @allFreq_ = {}            
            for n in @allNoteNames()
                nb = n.slice(0,-1)
                o = Number(n.slice(-1))
                frequency = @notes[nb] / Math.pow(2, (8-o))
                @allFreq_[n] = frequency.toFixed(3)
        @allFreq_
    
    @noteIndex: (noteName) => @allNoteNames().indexOf noteName  
    @numNotes: => @noteNames.length * 9
    @maxNoteIndex: => @numNotes()-1
    @allNoteNames: =>
        if not @allNoteNames_?
            @allNoteNames_ = []
            for o in [0..8]
                for n in @noteNames
                    @allNoteNames_.push "#{n}#{o}"
            log '@allNoteNames', @allNoteNames_
        @allNoteNames_
        