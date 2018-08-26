
cos   = Math.cos
acos  = Math.acos
abs   = Math.abs
sin   = Math.sin
sqrt  = Math.sqrt
atan2 = Math.atan2
max   = Math.max
min   = Math.min
rand  = Math.random

randr = (a,b) -> a+(b-a)*rand()
clamp = (a,b,v) -> max a, min b, v

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
            @w *= l
        @
        
vec = (x,y,z) -> new Vect x,y,z        
            