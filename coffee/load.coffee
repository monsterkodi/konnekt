
# 000       0000000    0000000   0000000        000      00000000  000   000  00000000  000        
# 000      000   000  000   000  000   000      000      000       000   000  000       000        
# 000      000   000  000000000  000   000      000      0000000    000 000   0000000   000        
# 000      000   000  000   000  000   000      000      000          000     000       000        
# 0000000   0000000   000   000  0000000        0000000  00000000      0      00000000  0000000    

loadNext = ->
    if world.winner == 'usr'
        loadLevel world.level.next ? 'menu'
    else
        forceLevel world.level.name

forceLevel = (level) -> world.level = null; loadLevel level
        
loadLevel = (level) ->
    
    svg.innerHTML = ''
    
    menu.bot.innerHTML = ''
    menu.usr.innerHTML = ''
    
    world.circle = add 'circle', class:'world', cx:screen.center.x, cy:screen.center.y, r:screen.radius
    world.circle.v = vec()
    
    world.ticks  = 0
    world.dots   = []        
    world.lines  = []
    world.update = 1
    world.winner = null
    mouse.drag = null
    
    bot = null
    
    delTmpl 'usr'
    delTmpl 'bot'
    
    hint()
    popup()
    
    if level == 'menu'
        showMenu 'menu'
    else
        showMenu 'game'
    
    switch level
        when 'RANDOM' then randomLevel()
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

    return if world.level?.name == name
    
    level = levels[name]
    
    level.name = name
        
    for d in level.dots
        
        if d.c
            for i in [0...d.c[0]]
                q = Quat.axis(vec(0,1,0),d2r(d.c[2])).mul Quat.axis(vec(1,0,0),d2r(d.c[3]))
                v = vec 0,0,1 
                v = Quat.axis(vec(1,0,0),d2r(d.c[1])).rotate v
                a = d.c[4] ? 360/d.c[0]
                v = Quat.axis(vec(0,0,1),d2r(i*a)).rotate v
                v = q.rotate v
                dot = new Dot v
            continue
        
        dot = new Dot vec d.v[0], d.v[1], d.v[2]
        if d.u
            dot.setOwn 'usr'
            dot.setUnits d.u 
        if d.b
            dot.setOwn 'bot'
            dot.setUnits d.b 
        if name == 'menu'
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
        msg level.msg
    else
        msg()
        
    if level.hint
        hint level.hint[0], level.hint[1]
    else
        hint()

    if name == 'menu'
        delete level.msg
        delete level.hint
  
    world.level   = level
    world.addUnit = level.addUnit
    
    if level.synt
        snd.setSynt level.synt
    
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
    world.level = name: 'RANDOM'
    
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
    