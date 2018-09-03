
# 000       0000000    0000000   0000000        000      00000000  000   000  00000000  000        
# 000      000   000  000   000  000   000      000      000       000   000  000       000        
# 000      000   000  000000000  000   000      000      0000000    000 000   0000000   000        
# 000      000   000  000   000  000   000      000      000          000     000       000        
# 0000000   0000000   000   000  0000000        0000000  00000000      0      00000000  0000000    

loadLevel = (level='random') ->
    
    svg.innerHTML = ''
    
    menu.buttons.bot.innerHTML = ''
    menu.buttons.usr.innerHTML = ''
    
    world.circle = add 'circle', class:'world', cx:screen.center.x, cy:screen.center.y, r:screen.radius
    world.circle.v = vec()
    
    dbg = add 'line', class:'dbg'
    
    world.ticks  = 0
    world.dots   = []        
    world.lines  = []
    world.update = 1
    world.winner = null
    
    bot = null
    
    hint()
    
    switch level
        when 'random' then randomLevel()
        else
            initLevel level
    
    if world.pause
        pause()
        
# 000  000   000  000  000000000        000      00000000  000   000  00000000  000    
# 000  0000  000  000     000           000      000       000   000  000       000    
# 000  000 0 000  000     000           000      0000000    000 000   0000000   000    
# 000  000  0000  000     000           000      000          000     000       000    
# 000  000   000  000     000           0000000  00000000      0      00000000  0000000

initLevel = (name) ->
    
    level = levels[name]
    level.name = name
        
    for d in level.dots
        dot = new Dot vec d.v[0], d.v[1], d.v[2]
        if d.o
            dot.setOwn d.o
            dot.setUnits d.u if d.u
        if d.l
            dot.level = d.l
            if pref.get d.l
                dot.setOwn 'usr'
        
    for l in level.lines ? []
        new Line world.dots[l[0]], world.dots[l[1]]
            
    if level.bot
        l = world.dots.length 
        i = (l + level.bot.i) % l
        bot = new Bot world.dots[i]
        if level.bot.speed
            bot.speed = level.bot.speed
        
    if level.msg
        if not world.pause
            pause() # hack to hide menu items
            pause()
        msg level.msg
        
    if level.hint
        hint level.hint[0], level.hint[1]
        
    world.level   = level
    world.addUnit = level.addUnit
    
    if world.addUnit
        grph = new Grph
    
# 00000000    0000000   000   000  0000000     0000000   00     00  
# 000   000  000   000  0000  000  000   000  000   000  000   000  
# 0000000    000000000  000 0 000  000   000  000   000  000000000  
# 000   000  000   000  000  0000  000   000  000   000  000 0 000  
# 000   000  000   000  000   000  0000000     0000000   000   000  

randomLevel = ->
    
    grph = new Grph
    
    world.addUnit = 1
    world.level = 
        name: 'random'
    
    d = new Dot vec 0,0,1
    d.setOwn 'usr'
    
    nodes = world.nodes ? 2 * parseInt randr 8, 20
    for i in [1...nodes/2]
        v = vec randr(-1,1), randr(-1,1), randr(0,1)
        v.norm()
        
        while true
            ok = true 
            for ed in world.dots
                if v.angle(ed.v) < 0.2
                    v = vec randr(-1,1), randr(-1,1), randr(0,1) 
                    v.norm()
                    ok = false
                    break
            if ok 
                break
        
        new Dot v
        
    for i in [nodes/2-1..0]
        new Dot world.dots[i].v.times(-1).add vec 0.01
    
    b = world.dots[world.dots.length-1]
    b.setOwn 'bot'
    bot = new Bot()
    
    b.startTimer 360
    d.startTimer 360
    