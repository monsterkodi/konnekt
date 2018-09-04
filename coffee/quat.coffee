###
 0000000   000   000   0000000   000000000  
000   000  000   000  000   000     000     
000 00 00  000   000  000000000     000     
000 0000   000   000  000   000     000     
 00000 00   0000000   000   000     000     
###

class Quat

    constructor: (x, y, z, w) ->
        
        @x = x or 0
        @y = y or 0
        @z = z or 0
        @w = w ? 1

    copy: (a) ->
        
        @x = a.x
        @y = a.y
        @z = a.z
        @w = a.w
        @
        
    @axis: (v,a=0) -> 
        
        h = a / 2
        s = Math.sin h
        new Quat v.x*s, v.y*s, v.z*s, Math.cos h
        
    rotate: (v) ->

        x = v.x
        y = v.y
        z = v.z
        
        ix = @w * x + @y * z - @z * y
        iy = @w * y + @z * x - @x * z
        iz = @w * z + @x * y - @y * x
        iw = - @x * x - @y * y - @z * z

        x = ix * @w + iw * - @x + iy * - @z - iz * - @y
        y = iy * @w + iw * - @y + iz * - @x - ix * - @z
        z = iz * @w + iw * - @z + ix * - @y - iy * - @x
        
        vec x,y,z

    length: -> Math.sqrt @x * @x + @y * @y + @z * @z + @w * @w
    zero: -> zero(@x) and zero(@y) and zero(@z)

    norm: ->
        l = @length()
        if l == 0
            @x = 0
            @y = 0
            @z = 0
            @w = 1
        else
            l = 1 / l
            @x = @x * l
            @y = @y * l
            @z = @z * l
            @w = @w * l
        @

    mul: (a) ->
        
        ax = @x
        ay = @y
        az = @z
        aw = @w
        @x = ax * a.w +  aw * a.x  +  ay * a.z  - (az * a.y)
        @y = ay * a.w +  aw * a.y  +  az * a.x  - (ax * a.z)
        @z = az * a.w +  aw * a.z  +  ax * a.y  - (ay * a.x)
        @w = aw * a.w - (ax * a.x) - (ay * a.y) - (az * a.z)
        @

    slerp: (a, t) ->
        
        if t == 0
            return @
        if t == 1
            return @copy a
            
        x = @x
        y = @y
        z = @z
        w = @w
        
        cht = w * a.w + x * a.x + y * a.y + z * a.z
        
        if cht < 0
            @w = -a.w
            @x = -a.x
            @y = -a.y
            @z = -a.z
            cht = -cht
        else
            @copy a
            
        if cht >= 1.0
            @w = w
            @x = x
            @y = y
            @z = z
            return @
            
        ssht = 1.0 - (cht * cht)
        if ssht <= Number.EPSILON
            s = 1 - t
            @w = s * w + t * @w
            @x = s * x + t * @x
            @y = s * y + t * @y
            @z = s * z + t * @z
            return @norm()
            
        sht = Math.sqrt ssht
        ht = Math.atan2 sht, cht
        ra = Math.sin((1 - t) * ht) / sht
        rb = Math.sin(t * ht) / sht
        @w = w * ra + @w * rb
        @x = x * ra + @x * rb
        @y = y * ra + @y * rb
        @z = z * ra + @z * rb
        @
