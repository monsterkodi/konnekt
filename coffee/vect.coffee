
cos   = Math.cos
acos  = Math.acos
abs   = Math.abs
sin   = Math.sin
sqrt  = Math.sqrt
atan2 = Math.atan2
max   = Math.max
min   = Math.min

clamp = (a,b,v) -> max a, min b, v

class Vect

    constructor: (@x,@y,@z) ->
