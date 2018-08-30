
###
000   000  00000000   0000000
000   000  000       000     
 000 000   0000000   000     
   000     000       000     
    0      00000000   0000000
###

abs   = Math.abs
cos   = Math.cos
acos  = Math.acos
sin   = Math.sin
sqrt  = Math.sqrt
atan2 = Math.atan2
max   = Math.max
min   = Math.min
rand  = Math.random
PI    = Math.PI
ceil  = Math.ceil
floor = Math.floor
EPS   = Number.EPSILON

randr = (a,b) -> a+(b-a)*rand()
clamp = (a,b,v) -> max a, min b, v
zero  = (v) -> abs(v) < EPS

log = console.log 
r2d = (r) -> 180 * r / PI
d2r = (d) -> PI * d / 180

class Vec

    constructor: (@x=0,@y=0,@z=0) ->
    cpy: -> vec @x, @y, @z

    add: (v) -> 
        @x+=v.x 
        @y+=v.y 
        @z+=v.z
        @
        
    mul: (f) ->
        @x*=f
        @y*=f
        @z*=f
        @
    times: (f) -> @cpy().mul f
    minus: (v) -> vec @x-v.x,@y-v.y,@z-v.z
    to:    (v) -> v.minus @
    dist:  (v) -> @minus(v).length()
    dot:   (v) -> @x * v.x + @y * v.y + @z * v.z
    cross: (v) -> vec @y * v.z - @z * v.y, @z * v.x - @x * v.z, @x * v.y - @y * v.x
    length:    -> sqrt @x*@x + @y*@y + @z*@z

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
        
    angle: (v) -> acos clamp -1, 1, @dot(v) / sqrt( @length() * v.length() )
        
vec = (x,y,z) -> new Vec x,y,z        
            