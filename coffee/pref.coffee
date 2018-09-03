###
00000000   00000000   00000000  00000000
000   000  000   000  000       000     
00000000   0000000    0000000   000000  
000        000   000  000       000     
000        000   000  00000000  000     
###

class Pref

    constructor: ->
        
    load: ->
        @cache = prefs:'prefs', volume:0.03125
        try
            @req = window.indexedDB.open 'online', 2
            @req.onerror = (e) => @loadMenu 'open error'
            @req.onsuccess = (e) =>
                @db = e.target.result
                @read()
            @req.onupgradeneeded = (e) =>
                db    = e.target.result
                store = db.createObjectStore "prefs", keyPath: 'prefs'
                req   = store.put @cache
        catch err
            @loadMenu 'prefs catch'
          
    loadMenu: (from) ->
        
        # log "loadMenu from:#{from} level:#{world.level?.name}"
        if world?.level == undefined or world.level?.name == 'menu'
            loadLevel 'menu'
            
    read: ->
        
        trans = @db.transaction ["prefs"], 'readonly'
        store = trans.objectStore "prefs"
        req = store.get 'prefs'
        req.onerror = (e) => @loadMenu 'read error'
        req.onsuccess = (e) =>
            if not req.result
                @write()
                @loadMenu 'empty'
            else
                @cache = req.result
                snd.volume @cache.volume
                @loadMenu 'read'
            
    write: ->
        
        trans = @db.transaction ["prefs"], 'readwrite'
        store = trans.objectStore 'prefs'
        req = store.put @cache
        
    clear: ->
        
        @cache = prefs:'prefs', volume:@cache.volume ? 0.03125
        @write()
            
    set: (key, value) ->
        
        @cache[key] = value
        if @db then @write()
        
    get: (key, deflt) -> 
        @cache[key] ? deflt
            