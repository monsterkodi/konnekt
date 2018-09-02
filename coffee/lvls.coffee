###
000      00000000  000   000  00000000  000       0000000
000      000       000   000  000       000      000     
000      0000000    000 000   0000000   000      0000000 
000      000          000     000       000           000
0000000  00000000      0      00000000  0000000  0000000 
###

levels = 
    
    menu:
        
        addUnit:0
        msg:  "WELCOME TO\nKONNEKT"
        dots: [
            v: [0,0,1]
            l: 'level1'
        ,
            v: [0,-0.3,0.8]
            l: 'level2'
        ,
            v: [0,-0.4,0.6]
            l: 'level3'
        ,
            v: [0,-0.6,0.4]
            l: 'level4'
        ,
            v: [0,-0.8,0.8]
            l: 'level5'
        ,
            v: [0,-1,0]
            l: 'level6'
        ,
            v: [0,1,0]
            l: 'random'
        ]
        
    
    level1:
        
        addUnit: 0
        hint: "Attack the red node by dragging from the blue node.\n\nEach time you attack, half of the available processes will be sent."
        dots: [
            v: [-0.5,0,1]
            o: 'usr'
            u: 360
        ,
            v: [0.5,0,1]
            o: 'bot'
            u: 270
        ]
        
    level2:
        
        addUnit: 0
        hint: "To win, you need to deactivate all red nodes.\n\nIt is OK to leave inactive red nodes!\n\nDrag anywhere to rotate the sphere."
        dots: [
            v: [0.0,0.0,1]
            o: 'usr'
            u: 90
        ,
            v: [-0.2,0,1]
            o: 'bot'
            u: 11
        ,
            v: [0.2,0,1]
            o: 'bot'
            u: 11
        ,
            v: [0,0.2,1]
            o: 'bot'
            u: 11
        ,
            v: [0,-0.2,1]
            o: 'bot'
            u: 11
        ,
            v: [0,0.01,-1]
            o: 'bot'
            u: 45
        ]    
        
    level3:
        
        addUnit: 0
        hint: "Sending to nodes that you don't own isn't free.\n\nThe farther away the target node, the higher the cost."
        dots: [
            v: [-0.9,-0.2,0.1]
            o: 'usr'
            u: 150
        ,
            v: [-0.9,0.2,0.1]
            o: 'usr'
            u: 100
        ,
            v: [-0.9,0,0.1]
            o: 'bot'
            u: 90
        ,
            v: [0.9,0,0.1]
            o: 'bot'
            u: 90
        ]
        
    level4:
        
        addUnit: 0
        hint: "Sending processes to owned nodes doesn't cost anything.\n\nBut you can't send processes between connected nodes!"
        dots: [
            v: [-0.7,0.1,0.3]
            o: 'usr'
            u: 360
        ,
            v: [-0.7,-0.1,0.3]
            o: 'usr'
            u: 12
        ,
            v: [0.7,-0.1,0.3]
            u: 10
        ,
            v: [0.7,0.1,0.3]
            o: 'bot'
            u: 270
        ]
        
    level5:
        
        addUnit: 3
        hint: "New processes are regularily spawned in active nodes.\n\nAlways make sure you have more active nodes than the opponent."
        dots: [
            v: [0,0,1]
            o: 'usr'
            u: 60
        ,
            v: [-0.5,-0.5,1]
        ,
            v: [ 0.5,-0.5,1]
        ,
            v: [-0.5, 0.5,1]
        ,
            v: [ 0.5, 0.5,1]
        ,
            v: [-1, 0,1]
        ,
            v: [ 1, 0,1]
        ,
            v: [ 0,-1,1]
        ,           
            v: [ 0, 1,1]
        ,
            v: [-1,-1,-1]
            o: 'bot'
            u: 12
        ,
            v: [ 1,-1,-1]
            o: 'bot'
            u: 12
        ,
            v: [-1, 1,-1]
            o: 'bot'
            u: 12
        ,
            v: [ 1, 1,-1]
            o: 'bot'
            u: 12
        ,
            v: [0,0,-1]
            o: 'bot'
            u: 12
        ]
        
    level6:
        
        addUnit: 2            
        hint: "Be prepared, the red nodes are fighting back!"
        dots: [
            v: [0,0,1]
            o: 'usr'
            u: 60
        ,
            v: [-0.5,-0.5,1]
        ,
            v: [ 0.5,-0.5,1]
        ,
            v: [-0.5, 0.5,1]
        ,
            v: [ 0.5, 0.5,1]
        ,
            v: [-1, 0,1]
        ,
            v: [ 1, 0,1]
        ,
            v: [ 0,-1,1]
        ,           
            v: [ 0, 1,1]
        ,
            v: [-1,-1,-1]
        ,
            v: [ 1,-1,-1]
        ,
            v: [-1, 1,-1]
        ,
            v: [ 1, 1,-1]
        ,
            v: [0,0,-1]
            o: 'bot'
            u: 60
        ]
        bot:
            speed: 8
            i:    -1
            
            