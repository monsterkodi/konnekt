
###
000   000  00000000   0000000
000   000  000       000     
 000 000   0000000   000     
   000     000       000     
    0      00000000   0000000
###

randr = (a,b) -> a+(b-a)*Math.random()
clamp = (a,b,v) -> Math.max a, Math.min b, v
zero  = (a) -> Math.abs(a) < Number.EPSILON

log = console.log 
r2d = (a) -> 180 * a / Math.PI
d2r = (a) -> Math.PI * a / 180

class Vec

    constructor: (@x=0,@y=0,@z=0) ->
    cpy: -> vec @x, @y, @z

    add: (a) -> 
        @x+=a.x 
        @y+=a.y 
        @z+=a.z
        @
        
    mul: (b) ->
        @x*=b
        @y*=b
        @z*=b
        @
        
    times: (f) -> @cpy().mul f
    minus: (a) -> vec @x-a.x,@y-a.y,@z-a.z
    to:    (a) -> a.minus @
    dist:  (a) -> @minus(a).length()
    dot:   (a) -> @x*a.x+@y*a.y+@z*a.z
    cross: (a) -> vec @y*a.z-@z*a.y,@z*a.x-@x*a.z,@x*a.y-@y*a.x
    length:    -> Math.sqrt @x*@x+@y*@y+@z*@z

    norm: ->
        l = @length()
        if l == 0
            @x = 0
            @y = 0
            @z = 0
        else
            l = 1 / l
            @x *= l
            @y *= l
            @z *= l
        @
        
    angle: (a) -> Math.acos clamp -1, 1, @dot(a) / Math.sqrt( @length() * a.length() )
        
vec = (x,y,z) -> new Vec x,y,z        
            