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
        hint: ["WELCOME TO", "A JS13K 2018 ENTRY\nBY MONSTERKODI"]
        dots: [
            v: [0,0,1]
            l: 'TUTORIAL 1'
            o: 'bot'
        ,
            v: [0,-0.3,0.8]
            l: 'TUTORIAL 2'
        ,
            v: [-0.3,-0.58,0.75]
            l: 'TUTORIAL 3'
        ,
            v: [ 0.3,-0.58,0.75]
            l: 'TUTORIAL 4'
        ,
            v: [0,-0.82,0.58]
            l: 'TUTORIAL 5'
        ,
            v: [0,-0.97,0.19]
            l: 'EASY AI'
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
        ]
    
    'TUTORIAL 1':
        
        addUnit: 0
        next: 'TUTORIAL 2'
        hint: ["You control the blue nodes. Your task is to fight the red nodes.\n\nNodes contain processes. The more processes, the stronger the node.", "Attack the infected red node by dragging from your blue node.\n\nEach time you attack, half of the available processes will be sent."]
        dots: [
            v: [-0.5,0,1]
            o: 'usr'
            u: 360
        ,
            v: [0.5,0,1]
            o: 'bot'
            u: 270
        ]
        
    'TUTORIAL 2':
        
        addUnit: 0
        next: 'TUTORIAL 3'
        hint: ["To win, you need to deactivate all red nodes.\n\nIt is OK to leave inactive red nodes!", "This level contains 4 inactive and 2 active red nodes.\n\nDrag anywhere to rotate the sphere."]
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
            v: [-0.1,0.1,-1]
            o: 'bot'
            u: 15
        ,
            v: [0.1,0.1,-1]
            o: 'bot'
            u: 15
        ]    
        
    'TUTORIAL 3':
        
        addUnit: 0
        next: 'TUTORIAL 4'
        hint: ["Sending to nodes that you don't own isn't free.\n\nThe farther away the target node, the higher the cost.", "The cost factor is multiplied by the number of processes sent. The more you send, the more you loose.\n\nNotice that you need more attacks -- and loose more processes -- when defeating the far node."]
        dots: [
            v: [-0.9,-0.2,0.1]
            o: 'usr'
            u: 360
        ,
            v: [-0.9,0.2,0.1]
            o: 'usr'
            u: 360
        ,
            v: [-0.9,0,0.1]
            o: 'bot'
            u: 180
        ,
            v: [0.9,0,0.1]
            o: 'bot'
            u: 180
        ]
        
    'TUTORIAL 4':
        
        addUnit: 0
        next: 'TUTORIAL 5'
        hint: ["Sending processes to nodes you own cost nothing.\n\nIt is efficient to occupy far away neutral nodes with few processes first and send larger groups later.", "Contrary to common believe,\nyou can't send processes between already connected nodes."]
        dots: [
            v: [-0.7,0.1,0.3]
            o: 'usr'
            u: 180
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
            u: 135
        ]
        lines: [ [0,1] ]
        
    'TUTORIAL 5':
        
        addUnit: 3
        next: 'EASY AI'
        hint: ["New processes are spawned regularily in active nodes.\n\nAlways make sure you have more active nodes than the opponent.", "You can see the number of active nodes in the top right corner.\n\nThe graph plots the relative amount of available processes."]
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
        
    'EASY AI':
        
        addUnit: 2 
        next: 'menu'
        hint: ["Be prepared, the red nodes are fighting back!", "You learned the basics, let's see if you can beat this slow and simple AI."]
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
            
            