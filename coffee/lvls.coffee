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
        msg:  "KONNEKT"
        hint: ["WELCOME TO", "A JS13K 2018 GAME\nBY MONSTERKODI"]
        dots: [
            v:[0,0,1], b:0
            l:'TUTORIAL 1'                
        ,
            v:[0,-0.3,0.8]
            l:'TUTORIAL 2'
        ,
            v:[-0.3,-0.58,0.75]
            l:'TUTORIAL 3'
        ,
            v:[0.3,-0.58,0.75]
            l:'TUTORIAL 4'
        ,
            v:[0,-0.82,0.58]
            l:'TUTORIAL 5'
        ,
            v: [0,-0.97,0.19]
            l: 'EASY'
        ,
            v:[-1,0,0]
            l:'CIRCLES'
        ,
            v:[-1,0,-1]
            l:'RING'
        ,
            v:[-1,1,-1]
            l:'POLES'
        ,
            v:[1,1,-1]
            l:'CLOSE'
        ,
            v:[1,0,-1]
            l:'UNFAIR'
        ,
            v:[1,0,-0.01]
            l:'FRENZY'
        ,
            v: [0,1,0]
            l: 'RANDOM'
        ]
        lines: [
            [0,1]
            [1,2]
            [1,3]
            [3,4]
            [2,4]
            [4,5]
            [5,6]
            [6,7]
            [7,8]
            [8,9]
            [9,10]
            [10,11]
            [11,12]
        ]
    
    'TUTORIAL 1':
        
        synt:
            usr: instrument:'piano1'
            bot: instrument:'piano2'
        addUnit: 0
        next: 'TUTORIAL 2'
        hint: ["You control the blue nodes. Your task is to fight the red nodes.\n\nNodes contain processes. The more processes, the stronger the node.", "Attack the infected red node by dragging from your blue node.\n\nEach time you attack, half of the available processes will be sent."]
        dots: [
            v: [-0.5,0,1]
            u: 360
        ,
            v: [0.5,0,1]
            b: 270
        ]
        
    'TUTORIAL 2':
        
        synt:
            usr: instrument:'bell1'
            bot: instrument:'bell2'
        addUnit: 0
        next: 'TUTORIAL 3'
        hint: ["To win, you need to deactivate all red nodes.\n\nIt is OK to leave inactive red nodes!", "This level contains 4 inactive and 2 active red nodes.\n\nDrag anywhere to rotate the sphere."]
        dots: [
            v: [0,0,1]
            u: 90
        ,
            v: [-0.2,0,1]
            b: 11
        ,
            v: [0.2,0,1]
            b: 11
        ,
            v: [0,0.2,1]
            b: 11
        ,
            v: [0,-0.2,1]
            b: 11
        ,
            v: [-0.1,0.1,-1]
            b: 15
        ,
            v: [0.1,0.1,-1]
            b: 15
        ]    
        
    'TUTORIAL 3':
        
        synt:
            usr: instrument:'bell3'
            bot: instrument:'bell4'
        addUnit: 0
        next: 'TUTORIAL 4'
        hint: ["Sending to nodes that you don't own isn't free.\n\nThe farther away the target node, the higher the cost.", "The cost factor is multiplied by the number of processes sent. The more you send, the more you loose.\n\nNotice that you need more attacks -- and loose more processes -- when defeating the far node."]
        dots: [
            v: [-0.9,-0.2,0.1]
            u: 360
        ,
            v: [-0.9,0.2,0.1]
            u: 360
        ,
            v: [-0.9,0,0.1]
            b: 180
        ,
            v: [0.9,0,0.1]
            b: 180
        ]
        
    'TUTORIAL 4':
        
        addUnit: 0
        next: 'TUTORIAL 5'
        hint: ["Sending processes to nodes you own cost nothing.\n\nIt is efficient to occupy far away neutral nodes with few processes first and send larger groups later.", "Contrary to common believe,\nyou can't send processes between already connected nodes."]
        dots: [
            v: [-0.7,0.1,0.3]
            u: 180
        ,
            v: [-0.7,-0.1,0.3]
            u: 12
        ,
            v: [0.7,-0.1,0.3]
        ,
            v: [0.7,0.1,0.3]
            b: 135
        ]
        lines: [ [0,1] ]
        
    'TUTORIAL 5':
        
        addUnit: 3
        next: 'EASY'
        hint: ["New processes are spawned regularily in active nodes.\n\nAlways make sure you have more active nodes than the opponent.", "You can see the number of active nodes in the top right corner.\n\nThe graph plots the relative amount of available processes."]
        dots: [
            v: [0,0,1]
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
            v: [-1,-1,0]
            b: 12
        ,
            v: [ 1,-1,0]
            b: 12
        ,
            v: [-1, 1,0]
            b: 12
        ,
            v: [ 1, 1,0]
            b: 12
        ,
            v: [0,0,-1]
            b: 12
        ]
        
    'EASY':
        synt:
            usr: instrument:'organ1'
            bot: instrument:'organ2'
        addUnit: 2 
        next: 'menu'
        hint: ["Be prepared, the red nodes are fighting back!", "You learned the basics, remove the virus from the system!"]
        dots: [
            v: [0,0,1]
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
            b: 60
        ]
        bot:
            speed: 8
            i:    -1
            
    'CIRCLES':
        synt:
            usr: instrument:'string'
            bot: instrument:'flute'
        addUnit: 4
        dots: [
            v: [0,0,1]
            u: 60
        ,            
            c: [8,45,0,0]
        ,
            c: [8,45,0,180]
        ,
            c: [16,90,0,0]
        ,
            v: [0,0,-1]
            b: 60
        ]
        bot:
            speed: 7
            i:    -1
        
    'POLES':
        synt:
            usr: instrument:'bell3'
            bot: instrument:'bell4'
        addUnit: 4
        dots: [
            v: [0,0,1]
            u: 60
        ,            
            c: [8,20,90,0]
        ,
            c: [8,20,-90,0]
        ,
            c: [8,20,0,90]
        ,
            c: [8,20,0,-90]
        ,
            v: [0,0,-1]
            b: 60
        ]
        bot:
            speed: 6
            i:    -1
        
    'RING':
        synt:
            usr: instrument:'bell1'
            bot: instrument:'bell2'
        addUnit: 4
        dots: [
            v: [0,0,1]
            u: 60
        ,            
            c: [5,90,-30,90,30]
        ,            
            c: [5,-90,-30,90,30]
        ,            
            c: [5,70,-120,90,30]
        ,            
            c: [5,70,-60,-90,30]
        ,
            v: [0,0,-1]
            b: 60
        ]
        bot:
            speed: 5
            i:    -1
        
    'CLOSE':
        addUnit: 4
        dots: [
            v: [-0.4,0,1]
            u: 60
        ,            
            c: [11,90,-15,45,15]
        ,            
            c: [11,-90,-15,45,15]
        ,
            v: [0.4,0,1]
            b: 60
        ]
        bot:
            speed: 4
            i:    -1

    'UNFAIR':
        addUnit: 6
        dots: [
            v: [0,0,1]
            u: 90
        ,            
            c: [4,15,180,0]
        ,            
            c: [8,30,180,0]
        ,            
            c: [16,45,180,0]
        ,
            v: [0,0,-1]
            b: 360
        ]
        bot:
            speed: 3
            i:    -1
            
    'FRENZY':
        addUnit: 12
        dots: [
            v: [0,0,1]
            u: 180
        ,            
            c: [4,22.5,0,0]
        ,            
            c: [4,22.5,180,0]
        ,            
            c: [4,22.5,90,0]
        ,            
            c: [4,22.5,-90,0]
        ,
            c: [6,40,0,0]
        ,         
            c: [6,40,180,0]
        ,         
            c: [6,40,90,0]
        ,         
            c: [6,40,-90,0]
        ,
            v: [0,0,-1]
            b: 12
        ,
            v: [1,0,0]
            b: 12
        ,
            v: [-1,0,0]
            b: 12
        ,
            v: [0,1,0]
            b: 12
        ,
            v: [0,-1,0]
            b: 12
        ]
        bot:
            speed: 2
            i:    -1
        
            
            
            