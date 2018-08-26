
cos   = Math.cos
acos  = Math.acos
abs   = Math.abs
sin   = Math.sin
sqrt  = Math.sqrt
atan2 = Math.atan2
max   = Math.max
min   = Math.min
rand  = Math.random
PI    = Math.PI

randr = (a,b) -> a+(b-a)*rand()
clamp = (a,b,v) -> max a, min b, v

r2d = (r) -> 180 * r / PI
d2r = (d) -> PI * d / 180

class Vect

    constructor: (@x=0,@y=0,@z=0) ->
    cpy: -> new Vect @x, @y, @z

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
        
    dot: (v) -> @x * v.x + @y * v.y + @z * v.z
    cross: (v) -> new Vect @y * v.z - @z * v.y, @z * v.x - @x * v.z, @x * v.y - @y * v.x
    length: -> sqrt @x * @x + @y * @y + @z * @z

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
        
vec = (x,y,z) -> new Vect x,y,z        
            