###
00000000   00000000   00000000  00000000
000   000  000   000  000       000     
00000000   0000000    0000000   000000  
000        000   000  000       000     
000        000   000  00000000  000     
###

class Pref

    constructor: () ->
        @cache = prefs:'prefs', volume:0.03125
        @req = window.indexedDB.open 'onlinedb', 2
        # @req.onerror = (e) => log 'db error!', e.target.errorCode
        @req.onsuccess = (e) =>
            @db = e.target.result
            @read()
        @req.onupgradeneeded = (e) =>
            @db = e.target.result
            store = @db.createObjectStore "prefs", keyPath: 'prefs'
            req = store.add @cache
            # req.onerror = (e) -> log 'db init error!', e.target
            req.onsuccess = (e) => 
                @read()
            
    read: ->
        trans = @db.transaction ["prefs"]
        store = trans.objectStore "prefs"
        req = store.get 'prefs'
        req.onsuccess = (e) =>
            if not req.result
                @write()
            else
                @cache = req.result
                snd.volume @cache.volume
            
    write: ->
        trans = @db.transaction ["prefs"], 'readwrite'
        store = trans.objectStore 'prefs'
        req = store.put @cache
        # req.onerror = (e) -> log 'db write error!', e.target
        req.onsuccess = (e) -> 
            
    set: (key, value) -> 
        @cache[key] = value
        if @db then @write()
        
    get: (key, deflt) -> 
        @cache[key] ? deflt
            