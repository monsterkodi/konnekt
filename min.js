(function() {
  /*
  000   000  00000000   0000000
  000   000  000       000     
   000 000   0000000   000     
     000     000       000     
      0      00000000   0000000
  */
  /*
  000      00000000  000   000  00000000  000       0000000
  000      000       000   000  000       000      000     
  000      0000000    000 000   0000000   000      0000000 
  000      000          000     000       000           000
  0000000  00000000      0      00000000  0000000  0000000 
  */
  /*
  00     00  00000000  000   000  000   000    
  000   000  000       0000  000  000   000    
  000000000  0000000   000 0 000  000   000    
  000 0 000  000       000  0000  000   000    
  000   000  00000000  000   000   0000000     
  */
  /*
   0000000   000       0000000   0000000    
  000        000      000   000  000   000  
  000  0000  000      000   000  0000000    
  000   000  000      000   000  000   000  
   0000000   0000000   0000000   0000000    
  */
  var Bot, Dot, Grph, Line, Pref, Quat, Snd, Sprk, Synt, Vec, add, anim, app, arc, bot, brightness, choice, clamp, d2r, dbg, delTmpl, elem, fontSize, forceLevel, grph, hint, index, initLevel, isFullscreen, j, level, levelList, levels, loadLevel, loadNext, log, main, menu, menuAbout, menuVolume, menus, mouse, msg, onDown, onMove, onUp, opt, pause, popup, pref, r2d, randomLevel, randr, ref, rotq, s2u, screen, setHover, showMenu, size, snd, svg, toggleFullscreen, u2s, vec, visibility, win, world, zero,
    indexOf = [].indexOf;

  randr = function(a, b) {
    return a + (b - a) * Math.random();
  };

  clamp = function(a, b, v) {
    return Math.max(a, Math.min(b, v));
  };

  zero = function(a) {
    return Math.abs(a) < Number.EPSILON;
  };

  log = console.log;

  r2d = function(a) {
    return 180 * a / Math.PI;
  };

  d2r = function(a) {
    return Math.PI * a / 180;
  };

  Vec = class Vec {
    constructor(x1 = 0, y1 = 0, z1 = 0) {
      this.x = x1;
      this.y = y1;
      this.z = z1;
    }

    cpy() {
      return vec(this.x, this.y, this.z);
    }

    add(a) {
      this.x += a.x;
      this.y += a.y;
      this.z += a.z;
      return this;
    }

    mul(b) {
      this.x *= b;
      this.y *= b;
      this.z *= b;
      return this;
    }

    times(f) {
      return this.cpy().mul(f);
    }

    minus(a) {
      return vec(this.x - a.x, this.y - a.y, this.z - a.z);
    }

    to(a) {
      return a.minus(this);
    }

    dist(a) {
      return this.minus(a).length();
    }

    dot(a) {
      return this.x * a.x + this.y * a.y + this.z * a.z;
    }

    cross(a) {
      return vec(this.y * a.z - this.z * a.y, this.z * a.x - this.x * a.z, this.x * a.y - this.y * a.x);
    }

    length() {
      return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
    }

    norm() {
      var l;
      l = this.length();
      if (l === 0) {
        this.x = 0;
        this.y = 0;
        this.z = 0;
      } else {
        l = 1 / l;
        this.x *= l;
        this.y *= l;
        this.z *= l;
      }
      return this;
    }

    angle(a) {
      return Math.acos(clamp(-1, 1, this.dot(a) / Math.sqrt(this.length() * a.length())));
    }

  };

  vec = function(x, y, z) {
    return new Vec(x, y, z);
  };

  /*
   0000000   000   000   0000000   000000000  
  000   000  000   000  000   000     000     
  000 00 00  000   000  000000000     000     
  000 0000   000   000  000   000     000     
   00000 00   0000000   000   000     000     
  */
  Quat = class Quat {
    constructor(x, y, z, w) {
      this.x = x || 0;
      this.y = y || 0;
      this.z = z || 0;
      this.w = w != null ? w : 1;
    }

    copy(a) {
      this.x = a.x;
      this.y = a.y;
      this.z = a.z;
      this.w = a.w;
      return this;
    }

    static axis(v, a = 0) {
      var h, s;
      h = a / 2;
      s = Math.sin(h);
      return new Quat(v.x * s, v.y * s, v.z * s, Math.cos(h));
    }

    rotate(v) {
      var iw, ix, iy, iz, x, y, z;
      x = v.x;
      y = v.y;
      z = v.z;
      ix = this.w * x + this.y * z - this.z * y;
      iy = this.w * y + this.z * x - this.x * z;
      iz = this.w * z + this.x * y - this.y * x;
      iw = -this.x * x - this.y * y - this.z * z;
      x = ix * this.w + iw * -this.x + iy * -this.z - iz * -this.y;
      y = iy * this.w + iw * -this.y + iz * -this.x - ix * -this.z;
      z = iz * this.w + iw * -this.z + ix * -this.y - iy * -this.x;
      return vec(x, y, z);
    }

    length() {
      return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
    }

    zero() {
      return zero(this.x) && zero(this.y) && zero(this.z);
    }

    norm() {
      var l;
      l = this.length();
      if (l === 0) {
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.w = 1;
      } else {
        l = 1 / l;
        this.x = this.x * l;
        this.y = this.y * l;
        this.z = this.z * l;
        this.w = this.w * l;
      }
      return this;
    }

    mul(a) {
      var aw, ax, ay, az;
      ax = this.x;
      ay = this.y;
      az = this.z;
      aw = this.w;
      this.x = ax * a.w + aw * a.x + ay * a.z - (az * a.y);
      this.y = ay * a.w + aw * a.y + az * a.x - (ax * a.z);
      this.z = az * a.w + aw * a.z + ax * a.y - (ay * a.x);
      this.w = aw * a.w - (ax * a.x) - (ay * a.y) - (az * a.z);
      return this;
    }

    slerp(a, t) {
      var cht, ht, ra, rb, s, sht, ssht, w, x, y, z;
      if (t === 0) {
        return this;
      }
      if (t === 1) {
        return this.copy(a);
      }
      x = this.x;
      y = this.y;
      z = this.z;
      w = this.w;
      cht = w * a.w + x * a.x + y * a.y + z * a.z;
      if (cht < 0) {
        this.w = -a.w;
        this.x = -a.x;
        this.y = -a.y;
        this.z = -a.z;
        cht = -cht;
      } else {
        this.copy(a);
      }
      if (cht >= 1.0) {
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
        return this;
      }
      ssht = 1.0 - (cht * cht);
      if (ssht <= Number.EPSILON) {
        s = 1 - t;
        this.w = s * w + t * this.w;
        this.x = s * x + t * this.x;
        this.y = s * y + t * this.y;
        this.z = s * z + t * this.z;
        return this.norm();
      }
      sht = Math.sqrt(ssht);
      ht = Math.atan2(sht, cht);
      ra = Math.sin((1 - t) * ht) / sht;
      rb = Math.sin(t * ht) / sht;
      this.w = w * ra + this.w * rb;
      this.x = x * ra + this.x * rb;
      this.y = y * ra + this.y * rb;
      this.z = z * ra + this.z * rb;
      return this;
    }

  };

  /*
  00000000   00000000   00000000  00000000
  000   000  000   000  000       000     
  00000000   0000000    0000000   000000  
  000        000   000  000       000     
  000        000   000  00000000  000     
  */
  Pref = class Pref {
    constructor() {}

    load() {
      var err;
      this.cache = {
        prefs: 'prefs',
        volume: 0.03125
      };
      try {
        this.req = window.indexedDB.open('konekt', 3);
        this.req.onerror = (e) => {
          return this.loadMenu('open error');
        };
        this.req.onsuccess = (e) => {
          this.db = e.target.result;
          return this.read();
        };
        return this.req.onupgradeneeded = (e) => {
          var db, req, store;
          db = e.target.result;
          store = db.createObjectStore("prefs", {
            keyPath: 'prefs'
          });
          return req = store.put(this.cache);
        };
      } catch (error) {
        err = error;
        return this.loadMenu('prefs catch');
      }
    }

    loadMenu(from) {
      var ref;
      
      // log "loadMenu from:#{from} level:#{world.level?.name}"
      if ((typeof world !== "undefined" && world !== null ? world.level : void 0) === void 0 || ((ref = world.level) != null ? ref.name : void 0) === 'menu') {
        return loadLevel('menu');
      }
    }

    read() {
      var req, store, trans;
      trans = this.db.transaction(["prefs"], 'readonly');
      store = trans.objectStore("prefs");
      req = store.get('prefs');
      req.onerror = (e) => {
        return this.loadMenu('read error');
      };
      return req.onsuccess = (e) => {
        if (!req.result) {
          this.write();
          return this.loadMenu('empty');
        } else {
          this.cache = req.result;
          snd.volume(this.cache.volume);
          return this.loadMenu('read');
        }
      };
    }

    write() {
      var req, store, trans;
      trans = this.db.transaction(["prefs"], 'readwrite');
      store = trans.objectStore('prefs');
      return req = store.put(this.cache);
    }

    clear() {
      var ref;
      this.cache = {
        prefs: 'prefs',
        volume: (ref = this.cache.volume) != null ? ref : 0.03125
      };
      return this.write();
    }

    set(key, value) {
      this.cache[key] = value;
      if (this.db) {
        return this.write();
      }
    }

    get(key, v) {
      var ref;
      return (ref = this.cache[key]) != null ? ref : v;
    }

  };

  /*
   0000000  000   000  000   000  000000000
  000        000 000   0000  000     000   
  0000000     00000    000 0 000     000   
       000     000     000  0000     000   
  0000000      000     000   000     000   
  */
  // piano1, piano2, piano3, piano4, piano5
  // string, flute
  // bell1, bell2, bell3, bell4
  // organ1, organ2
  Synt = class Synt {
    constructor(config, ctx, gain) {
      var base;
      this.piano2 = this.piano2.bind(this);
      this.organ2 = this.organ2.bind(this);
      this.config = config;
      this.ctx = ctx;
      this.gain = gain;
      
      // 0 1  2 3  4 5 6  7 8  9 10 11
      // C Cs D Ds E F Fs G Gs A As B
      this.freqs = [4186.01, 4434.92, 4698.63, 4978.03, 5274.04, 5587.65, 5919.91, 6271.93, 6644.88, 7040.00, 7458.62, 7902.13];
      if ((base = this.config).duration == null) {
        base.duration = 0.3;
      }
      this.isr = 1.0 / 44100;
      this.initBuffers();
    }

    initBuffers() {
      this.sampleLength = this.config.duration * 44100;
      this.sampleLength = Math.floor(this.sampleLength);
      return this.createBuffers();
    }

    createBuffers() {
      return this.samples = new Array(108);
    }

    playNote(noteIndex) {
      var audioBuffer, buffer, frequency, func, i, j, node, ref, ref1, sample, sampleIndex, u, w, x;
      
      // log "note #{noteIndex}"
      if (this.samples[noteIndex] == null) {
        this.samples[noteIndex] = new Float32Array(this.sampleLength);
        frequency = this.freq(noteIndex);
        // log @config.instrument, noteIndex, frequency
        w = 2.0 * Math.PI * frequency;
        func = this[this.config.instrument];
        for (sampleIndex = j = 0, ref = this.sampleLength; (0 <= ref ? j < ref : j > ref); sampleIndex = 0 <= ref ? ++j : --j) {
          x = sampleIndex / (this.sampleLength - 1);
          this.samples[noteIndex][sampleIndex] = func(sampleIndex * this.isr, w, x);
        }
      }
      sample = this.samples[noteIndex];
      audioBuffer = this.ctx.createBuffer(1, sample.length, 44100);
      buffer = audioBuffer.getChannelData(0);
      for (i = u = 0, ref1 = sample.length; (0 <= ref1 ? u < ref1 : u > ref1); i = 0 <= ref1 ? ++u : --u) {
        buffer[i] = sample[i];
      }
      node = this.ctx.createBufferSource();
      node.buffer = audioBuffer;
      node.connect(this.gain);
      node.state = node.noteOn;
      return node.start(0);
    }

    freq(noteIndex) {
      return this.freqs[noteIndex % 12] / Math.pow(2, 8 - noteIndex / 12).toFixed(3);
    }

    setDuration(v) {
      if (this.config.duration !== v) {
        this.config.duration = v;
        return this.initBuffers();
      }
    }

    fmod(x, y) {
      return x % y;
    }

    sign(x) {
      return (x > 0.0) && 1.0 || -1.0;
    }

    frac(x) {
      return x % 1.0;
    }

    sqr(a, x) {
      if (Math.sin(x) > a) {
        return 1.0;
      } else {
        return -1.0;
      }
    }

    step(a, x) {
      return (x >= a) && 1.0 || 0.0;
    }

    over(x, y) {
      return 1.0 - (1.0 - x) * (1.0 - y);
    }

    mix(a, b, x) {
      return a + (b - a) * Math.min(Math.max(x, 0.0), 1.0);
    }

    saw(x, a) {
      var f;
      f = x % 1.0;
      if (f < a) {
        return f / a;
      } else {
        return 1.0 - (f - a) / (1.0 - a);
      }
    }

    grad(n, x) {
      n = (n << 13) ^ n;
      n = n * (n * n * 15731 + 789221) + 1376312589;
      if (n & 0x20000000) {
        return -x;
      } else {
        return x;
      }
    }

    noise(x) {
      var a, b, f, i, w;
      i = Math.floor(x);
      f = x - i;
      w = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
      a = this.grad(i + 0, f + 0.0);
      b = this.grad(i + 1, f - 1.0);
      return a + (b - a) * w;
    }

    /*
    000  000   000   0000000  000000000  00000000   000   000  00     00  00000000  000   000  000000000   0000000
    000  0000  000  000          000     000   000  000   000  000   000  000       0000  000     000     000     
    000  000 0 000  0000000      000     0000000    000   000  000000000  0000000   000 0 000     000     0000000 
    000  000  0000       000     000     000   000  000   000  000 0 000  000       000  0000     000          000
    000  000   000  0000000      000     000   000   0000000   000   000  00000000  000   000     000     0000000 
    */
    /*
    00000000   000   0000000   000   000   0000000 
    000   000  000  000   000  0000  000  000   000
    00000000   000  000000000  000 0 000  000   000
    000        000  000   000  000  0000  000   000
    000        000  000   000  000   000   0000000 
    */
    piano1(t, w, x) {
      var d, wt, y;
      wt = w * t;
      y = 0.6 * Math.sin(1.0 * wt) * Math.exp(-0.0008 * wt);
      y += 0.3 * Math.sin(2.0 * wt) * Math.exp(-0.0010 * wt);
      y += 0.1 * Math.sin(4.0 * wt) * Math.exp(-0.0015 * wt);
      y += 0.2 * y * y * y;
      y *= 0.9 + 0.1 * Math.cos(70.0 * t);
      y = 2.0 * y * Math.exp(-22.0 * t) + y;
      d = 0.8;
      if (x > d) {
        y *= Math.pow(1 - (x - d) / (1 - d), 2); // decay
      }
      return y;
    }

    piano2(t, w, x) {
      var a, b, d, r, rt, y, y2, y3;
      t = t + .00015 * this.noise(12 * t);
      rt = t;
      r = t * w * .2;
      r = this.fmod(r, 1);
      a = 0.15 + 0.6 * rt;
      b = 0.65 - 0.5 * rt;
      y = 50 * r * (r - 1) * (r - .2) * (r - a) * (r - b);
      r = t * w * .401;
      r = this.fmod(r, 1);
      a = 0.12 + 0.65 * rt;
      b = 0.67 - 0.55 * rt;
      y2 = 50 * r * (r - 1) * (r - .4) * (r - a) * (r - b);
      r = t * w * .399;
      r = this.fmod(r, 1);
      a = 0.14 + 0.55 * rt;
      b = 0.66 - 0.65 * rt;
      y3 = 50 * r * (r - 1) * (r - .8) * (r - a) * (r - b);
      y += .02 * this.noise(1000 * t);
      y /= t * w * .0015 + .1;
      y2 /= t * w * .0020 + .1;
      y3 /= t * w * .0025 + .1;
      y = (y + y2 + y3) / 3;
      d = 0.8;
      if (x > d) {
        y *= Math.pow(1 - (x - d) / (1 - d), 2); // decay
      }
      return y;
    }

    piano3(t, w, x) {
      var a, b, d, tt, y;
      tt = 1 - t;
      a = Math.sin(t * w * .5) * Math.log(t + 0.3) * tt;
      b = Math.sin(t * w) * t * .4;
      y = (a + b) * tt;
      d = 0.8;
      if (x > d) {
        y *= Math.pow(1 - (x - d) / (1 - d), 2); // decay
      }
      return y;
    }

    piano4(t, w, x) {
      var y;
      y = Math.sin(w * t);
      return y *= 1 - x * x * x * x;
    }

    piano5(t, w, x) {
      var wt, y;
      wt = w * t;
      y = 0.6 * Math.sin(1.0 * wt) * Math.exp(-0.0008 * wt);
      y += 0.3 * Math.sin(2.0 * wt) * Math.exp(-0.0010 * wt);
      y += 0.1 * Math.sin(4.0 * wt) * Math.exp(-0.0015 * wt);
      y += 0.2 * y * y * y;
      y *= 0.5 + 0.5 * Math.cos(70.0 * t); // vibrato
      y = 2.0 * y * Math.exp(-22.0 * t) + y;
      return y *= 1 - x * x * x * x;
    }

    /*
     0000000   00000000    0000000    0000000   000   000
    000   000  000   000  000        000   000  0000  000
    000   000  0000000    000  0000  000000000  000 0 000
    000   000  000   000  000   000  000   000  000  0000
     0000000   000   000   0000000   000   000  000   000
    */
    organ1(t, w, x) {
      var a, y;
      y = .6 * Math.cos(w * t) * Math.exp(-4 * t);
      y += .4 * Math.cos(2 * w * t) * Math.exp(-3 * t);
      y += .01 * Math.cos(4 * w * t) * Math.exp(-1 * t);
      y = y * y * y + y * y * y * y * y + y * y;
      a = .5 + .5 * Math.cos(3.14 * x);
      y = Math.sin(y * a * 3.14);
      return y *= 20 * t * Math.exp(-.1 * x);
    }

    organ2(t, w, x) {
      var a1, a2, a3, wt, y;
      wt = w * t;
      a1 = .5 + .5 * Math.cos(0 + t * 12);
      a2 = .5 + .5 * Math.cos(1 + t * 8);
      a3 = .5 + .5 * Math.cos(2 + t * 4);
      y = this.saw(0.2500 * wt, a1) * Math.exp(-2 * x);
      y += this.saw(0.1250 * wt, a2) * Math.exp(-3 * x);
      y += this.saw(0.0625 * wt, a3) * Math.exp(-4 * x);
      return y *= 0.8 + 0.2 * Math.cos(64 * t);
    }

    /*
    0000000    00000000  000      000    
    000   000  000       000      000    
    0000000    0000000   000      000    
    000   000  000       000      000    
    0000000    00000000  0000000  0000000
    */
    bell1(t, w, x) {
      var wt, y;
      wt = w * t;
      y = 0.100 * Math.exp(-t / 1.000) * Math.sin(0.56 * wt);
      y += 0.067 * Math.exp(-t / 0.900) * Math.sin(0.56 * wt);
      y += 0.100 * Math.exp(-t / 0.650) * Math.sin(0.92 * wt);
      y += 0.180 * Math.exp(-t / 0.550) * Math.sin(0.92 * wt);
      y += 0.267 * Math.exp(-t / 0.325) * Math.sin(1.19 * wt);
      y += 0.167 * Math.exp(-t / 0.350) * Math.sin(1.70 * wt);
      y += 0.146 * Math.exp(-t / 0.250) * Math.sin(2.00 * wt);
      y += 0.133 * Math.exp(-t / 0.200) * Math.sin(2.74 * wt);
      y += 0.133 * Math.exp(-t / 0.150) * Math.sin(3.00 * wt);
      y += 0.100 * Math.exp(-t / 0.100) * Math.sin(3.76 * wt);
      y += 0.133 * Math.exp(-t / 0.075) * Math.sin(4.07 * wt);
      return y *= 1 - x * x * x * x;
    }

    bell2(t, w, x) {
      var wt, y;
      wt = w * t;
      y = 0.100 * Math.exp(-t / 1.000) * Math.sin(0.56 * wt);
      y += 0.067 * Math.exp(-t / 0.900) * Math.sin(0.56 * wt);
      y += 0.100 * Math.exp(-t / 0.650) * Math.sin(0.92 * wt);
      y += 0.180 * Math.exp(-t / 0.550) * Math.sin(0.92 * wt);
      y += 0.267 * Math.exp(-t / 0.325) * Math.sin(1.19 * wt);
      y += 0.167 * Math.exp(-t / 0.350) * Math.sin(1.70 * wt);
      y += 2.0 * y * Math.exp(-22.0 * t); // attack
      return y *= 1 - x * x * x * x;
    }

    bell3(t, w, x) {
      var wt, y;
      wt = w * t;
      y = 0;
      y += 0.100 * Math.exp(-t / 1) * Math.sin(0.25 * wt);
      y += 0.200 * Math.exp(-t / 0.75) * Math.sin(0.50 * wt);
      y += 0.400 * Math.exp(-t / 0.5) * Math.sin(1.00 * wt);
      y += 0.200 * Math.exp(-t / 0.25) * Math.sin(2.00 * wt);
      y += 0.100 * Math.exp(-t / 0.1) * Math.sin(4.00 * wt);
      y += 2.0 * y * Math.exp(-22.0 * t); // attack
      return y *= 1 - x * x * x * x;
    }

    bell4(t, w, x) {
      var wt, y;
      wt = w * t;
      y = 0;
      y += 0.100 * Math.exp(-t / 0.9) * Math.sin(0.62 * wt);
      y += 0.200 * Math.exp(-t / 0.7) * Math.sin(0.86 * wt);
      y += 0.500 * Math.exp(-t / 0.5) * Math.sin(1.00 * wt);
      y += 0.200 * Math.exp(-t / 0.2) * Math.sin(1.27 * wt);
      y += 0.100 * Math.exp(-t / 0.1) * Math.sin(1.40 * wt);
      y += 2.0 * y * Math.exp(-22.0 * t); // attack
      return y *= 1 - x * x * x * x;
    }

    /*
     0000000  000000000  00000000   000  000   000   0000000 
    000          000     000   000  000  0000  000  000      
    0000000      000     0000000    000  000 0 000  000  0000
     000     000     000   000  000  000  0000  000   000
    0000000      000     000   000  000  000   000   0000000 
    */
    string(t, w, x) {
      var f, wt, y;
      wt = w * t;
      f = Math.sin(0.251 * wt) * Math.PI;
      y = 0.5 * Math.sin(1 * wt + f) * Math.exp(-1.0 * x);
      y += 0.4 * Math.sin(2 * wt + f) * Math.exp(-2.0 * x);
      y += 0.3 * Math.sin(4 * wt + f) * Math.exp(-3.0 * x);
      y += 0.2 * Math.sin(8 * wt + f) * Math.exp(-4.0 * x);
      y += 1.0 * y * Math.exp(-10.0 * t); // attack
      y *= 1 - x * x * x * x; // fade out
      return y;
    }

    /*
    00000000  000      000   000  000000000  00000000
    000       000      000   000     000     000     
    000000    000      000   000     000     0000000 
    000       000      000   000     000     000     
    000       0000000   0000000      000     00000000
    */
    flute(t, w, x) {
      var d, y;
      y = 6.0 * x * Math.exp(-2 * x) * Math.sin(w * t);
      y *= 0.6 + 0.4 * Math.sin(32 * (1 - x));
      d = 0.87;
      if (x > d) {
        y *= Math.pow(1 - (x - d) / (1 - d), 2); // decay
      }
      return y;
    }

  };

  /*
   0000000  000   000  0000000  
  000       0000  000  000   000
  0000000   000 0 000  000   000
       000  000  0000  000   000
  0000000   000   000  0000000  
  */
  Snd = class Snd {
    constructor() {
      this.volDown = this.volDown.bind(this);
      this.volUp = this.volUp.bind(this);
      this.vol = 0;
      this.ctx = new (window.AudioContext || window.webkitAudioContext)();
      this.gain = this.ctx.createGain();
      this.gain.connect(this.ctx.destination);
      this.gain.gain.value = this.vol;
      
      // piano1, piano2, piano3, piano4, piano5
      // string1, string2, flute
      // bell1, bell2, bell3, bell4
      // organ1, organ2, organ3, organ4
      this.synt = {};
      this.setSynt({
        usr: {
          instrument: 'bell3'
        },
        bot: {
          instrument: 'bell3'
        },
        menu: {
          instrument: 'string'
        }
      });
    }

    play(o, n, c = 0) {
      return this.synt[o].playNote((function() {
        switch (n) {
          case 'draw':
            return 3 * 12 + c;
          case 'send':
            return 4 * 12 + c;
          case 'won':
            return 5 * 12 + c;
          case 'lost':
            return 6 * 12 + c;
        }
      })());
    }

    setSynt(synt) {
      var k, results, v;
      log('setSynt', synt);
      results = [];
      for (k in synt) {
        v = synt[k];
        results.push(this.synt[k] = new Synt(v, this.ctx, this.gain));
      }
      return results;
    }

    volDown() {
      if (this.vol < 0.0625) {
        return this.volume(0);
      } else {
        return this.volume(this.vol / 2);
      }
    }

    volUp() {
      return this.volume(clamp(0.03125, 1, this.vol * 2));
    }

    volume(vol1) {
      this.vol = vol1;
      menuVolume(this.vol);
      this.gain.gain.value = this.vol;
      return pref.set('volume', this.vol);
    }

  };

  /*
   0000000   00000000   00000000   000   000
  000        000   000  000   000  000   000
  000  0000  0000000    00000000   000000000
  000   000  000   000  000        000   000
   0000000   000   000  000        000   000
  */
  Grph = class Grph {
    constructor() {
      this.maxSmpl = 300;
      this.smpls = {
        bot: [],
        usr: []
      };
      this.g = add('g');
      this.p = {
        bot: app(this.g, 'path', {
          class: 'grph bot'
        }),
        usr: app(this.g, 'path', {
          class: 'grph usr'
        })
      };
    }

    sample() {
      var d, j, len, len1, o, r2y, ref, ref1, results, s, smpl, u, x;
      r2y = function(r) {
        return (0.5 - r) * 60;
      };
      s = world.units.bot + world.units.usr;
      ref = ['usr', 'bot'];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        o = ref[j];
        this.smpls[o].push(world.units[o] / s);
        if (this.smpls[o].length > this.maxSmpl) {
          this.smpls[o].shift();
        }
        d = `M 0 ${r2y(this.smpls[o][0])} `;
        x = 0;
        ref1 = this.smpls[o];
        for (u = 0, len1 = ref1.length; u < len1; u++) {
          smpl = ref1[u];
          x += 1;
          d += `L ${x} ${r2y(smpl)} `;
        }
        results.push(this.p[o].setAttribute('d', d));
      }
      return results;
    }

    plot() {
      return this.g.setAttribute('transform', `translate(${screen.size.x - 60 - this.smpls.bot.length}, 47)`);
    }

  };

  win = window;

  main = document.getElementById('main');

  pref = new Pref;

  //  0000000  000   000   0000000   
  // 000       000   000  000        
  // 0000000    000 000   000  0000  
  //      000     000     000   000  
  // 0000000       0       0000000   
  svg = main.children[0];

  opt = function(e, o) {
    var j, k, len, ref;
    if (o != null) {
      ref = Object.keys(o);
      for (j = 0, len = ref.length; j < len; j++) {
        k = ref[j];
        e.setAttribute(k, o[k]);
      }
    }
    return e;
  };

  app = function(p, t, o) {
    var e;
    e = document.createElementNS("http://www.w3.org/2000/svg", t);
    p.appendChild(opt(e, o));
    return e;
  };

  add = function(t, o) {
    return app(svg, t, o);
  };

  arc = function(a, b) {
    var d, i, j, n, q, r, ref, s, v;
    r = a.angle(b);
    n = parseInt(r / 0.087);
    s = u2s(a);
    d = `M ${s.x} ${s.y}`;
    q = Quat.axis(a.cross(b).norm(), r / (n + 1));
    v = a.cpy();
    for (i = j = 0, ref = n; (0 <= ref ? j < ref : j > ref); i = 0 <= ref ? ++j : --j) {
      v = q.rotate(v);
      s = u2s(v);
      d += ` L ${s.x} ${s.y}`;
    }
    s = u2s(b);
    d += ` L ${s.x} ${s.y}`;
    return d;
  };

  brightness = function(d) {
    return d.c.style.opacity = (d.depth() + 0.3) / 1.3;
  };

  //  0000000   0000000  00000000   00000000  00000000  000   000  
  // 000       000       000   000  000       000       0000  000  
  // 0000000   000       0000000    0000000   0000000   000 0 000  
  //      000  000       000   000  000       000       000  0000  
  // 0000000    0000000  000   000  00000000  00000000  000   000  
  screen = {
    size: vec(),
    center: vec(),
    radius: 0
  };

  u2s = function(a) {
    return vec(screen.center.x + a.x * screen.radius, screen.center.y + a.y * screen.radius);
  };

  s2u = function(a) {
    a = a.minus(screen.center).times(1 / screen.radius);
    if (a.length() > 1) {
      return a.norm();
    } else {
      return vec(a.x, a.y, Math.sqrt(1 - a.x * a.x - a.y * a.y));
    }
  };

  rotq = function(a) {
    return Quat.axis(vec(0, 1, 0), a.x / screen.radius).mul(Quat.axis(vec(1, 0, 0), a.y / -screen.radius));
  };

  
  // 00     00  00000000  000   000  000   000  
  // 000   000  000       0000  000  000   000  
  // 000000000  0000000   000 0 000  000   000  
  // 000 0 000  000       000  0000  000   000  
  // 000   000  00000000  000   000   0000000   
  menu = {
    left: main.children[1],
    right: main.children[2],
    buttons: {}
  };

  // 000   000   0000000   00000000   000      0000000    
  // 000 0 000  000   000  000   000  000      000   000  
  // 000000000  000   000  0000000    000      000   000  
  // 000   000  000   000  000   000  000      000   000  
  // 00     00   0000000   000   000  0000000  0000000    
  world = {
    pause: 0,
    update: 0,
    time: 0,
    delta: 0,
    ticks: 0,
    dots: [],
    sparks: [],
    lines: [],
    tmpline: {},
    units: {},
    userRot: new Quat,
    inertRot: new Quat,
    circle: null,
    rotSum: vec()
  };

  
  // 00     00   0000000   000   000   0000000  00000000  
  // 000   000  000   000  000   000  000       000       
  // 000000000  000   000  000   000  0000000   0000000   
  // 000 0 000  000   000  000   000       000  000       
  // 000   000   0000000    0000000   0000000   00000000  
  mouse = {
    pos: vec(),
    drag: null,
    hover: null,
    touch: null
  };

  bot = null;

  snd = new Snd;

  grph = null;

  levelList = [
    {
      
      // 00     00  00000000  000   000  000   000  
      // 000   000  000       0000  000  000   000  
      // 000000000  0000000   000 0 000  000   000  
      // 000 0 000  000       000  0000  000   000  
      // 000   000  00000000  000   000   0000000   
      name: 'menu',
      addUnit: 0,
      msg: "KONNEKT",
      hint: ["WELCOME TO",
    "A JS13K 2018 GAME\nBY MONSTERKODI"],
      dots: [
        {
          v: [0,
        0,
        1],
          b: 0,
          l: 'TUTORIAL 1'
        },
        {
          v: [0,
        -0.3,
        0.8],
          l: 'TUTORIAL 2'
        },
        {
          v: [-0.3,
        -0.58,
        0.75],
          l: 'TUTORIAL 3'
        },
        {
          v: [0.3,
        -0.58,
        0.75],
          l: 'TUTORIAL 4'
        },
        {
          v: [0,
        -0.82,
        0.58],
          l: 'TUTORIAL 5'
        },
        {
          v: [0,
        -0.97,
        0.19],
          l: 'EASY'
        },
        {
          v: [-1,
        0,
        0],
          l: 'CIRCLES'
        },
        {
          v: [-1,
        0,
        -1],
          l: 'RING'
        },
        {
          v: [-1,
        1,
        -1],
          l: 'CLOSE'
        },
        {
          v: [1,
        1,
        -1],
          l: 'POLES'
        },
        {
          v: [1,
        0,
        -1],
          l: 'UNFAIR'
        },
        {
          v: [1,
        0,
        -0.01],
          l: 'FRENZY'
        },
        {
          v: [0,
        1,
        0],
          l: 'RANDOM'
        }
      ],
      lines: [[0,
    1],
    [1,
    2],
    [1,
    3],
    [3,
    4],
    [2,
    4],
    [4,
    5],
    [5,
    6],
    [6,
    7],
    [7,
    8],
    [8,
    9],
    [9,
    10],
    [10,
    11],
    [11,
    12]]
    },
    {
      // 000000000  000   000  000000000   0000000   00000000   000   0000000   000               000  
      //    000     000   000     000     000   000  000   000  000  000   000  000             00000  
      //    000     000   000     000     000   000  0000000    000  000000000  000            000000  
      //    000     000   000     000     000   000  000   000  000  000   000  000               000  
      //    000      0000000      000      0000000   000   000  000  000   000  0000000           000  
      name: 'TUTORIAL 1',
      synt: {
        usr: {
          instrument: 'piano1'
        },
        bot: {
          instrument: 'piano2'
        }
      },
      addUnit: 0,
      hint: ["You control the blue nodes. Your task is to fight the red nodes.\n\nNodes contain processes. The more processes, the stronger the node.",
    "Attack the infected red node by dragging from your blue node.\n\nEach time you attack, half of the available processes will be sent."],
      dots: [
        {
          v: [-0.5,
        0,
        1],
          u: 360
        },
        {
          v: [0.5,
        0,
        1],
          b: 270
        }
      ]
    },
    {
      // 000000000  000   000  000000000   0000000   00000000   000   0000000   000            00000   
      //    000     000   000     000     000   000  000   000  000  000   000  000               000  
      //    000     000   000     000     000   000  0000000    000  000000000  000              000   
      //    000     000   000     000     000   000  000   000  000  000   000  000             000    
      //    000      0000000      000      0000000   000   000  000  000   000  0000000        000000  
      name: 'TUTORIAL 2',
      synt: {
        usr: {
          instrument: 'bell1'
        },
        bot: {
          instrument: 'bell2'
        }
      },
      addUnit: 0,
      hint: ["To win, you need to deactivate all red nodes.\n\nIt is OK to leave inactive red nodes!",
    "This level contains 4 inactive and 2 active red nodes.\n\nDrag anywhere to rotate the sphere."],
      dots: [
        {
          v: [0,
        0,
        1],
          u: 90
        },
        {
          v: [-0.2,
        0,
        1],
          b: 11
        },
        {
          v: [0.2,
        0,
        1],
          b: 11
        },
        {
          v: [0,
        0.2,
        1],
          b: 11
        },
        {
          v: [0,
        -0.2,
        1],
          b: 11
        },
        {
          v: [-0.1,
        0.1,
        -1],
          b: 15
        },
        {
          v: [0.1,
        0.1,
        -1],
          b: 15
        }
      ]
    },
    {
      // 000000000  000   000  000000000   0000000   00000000   000   0000000   000            000000   
      //    000     000   000     000     000   000  000   000  000  000   000  000                000  
      //    000     000   000     000     000   000  0000000    000  000000000  000              0000   
      //    000     000   000     000     000   000  000   000  000  000   000  000                000  
      //    000      0000000      000      0000000   000   000  000  000   000  0000000        000000   
      name: 'TUTORIAL 3',
      synt: {
        usr: {
          instrument: 'bell3'
        },
        bot: {
          instrument: 'bell4'
        }
      },
      addUnit: 0,
      hint: ["Sending to nodes that you don't own isn't free.\n\nThe farther away the target node, the higher the cost.",
    "The cost factor is multiplied by the number of processes sent. The more you send, the more you loose.\n\nNotice that you need more attacks -- and loose more processes -- when defeating the far node."],
      dots: [
        {
          v: [-0.9,
        -0.2,
        0.1],
          u: 360
        },
        {
          v: [-0.9,
        0.2,
        0.1],
          u: 360
        },
        {
          v: [-0.9,
        0,
        0.1],
          b: 180
        },
        {
          v: [0.9,
        0,
        0.1],
          b: 180
        }
      ]
    },
    {
      name: 'TUTORIAL 4',
      addUnit: 0,
      hint: ["Sending processes to nodes you own cost nothing.\n\nIt is efficient to occupy far away neutral nodes with few processes first and send larger groups later.",
    "Contrary to common believe,\nyou can't send processes between already connected nodes."],
      dots: [
        {
          v: [-0.7,
        0.1,
        0.3],
          u: 180
        },
        {
          v: [-0.7,
        -0.1,
        0.3],
          u: 12
        },
        {
          v: [0.7,
        -0.1,
        0.3]
        },
        {
          v: [0.7,
        0.1,
        0.3],
          b: 135
        }
      ],
      lines: [[0,
    1]]
    },
    {
      
      // 000000000  000   000  000000000   0000000   00000000   000   0000000   000            0000000   
      //    000     000   000     000     000   000  000   000  000  000   000  000            000       
      //    000     000   000     000     000   000  0000000    000  000000000  000            0000000   
      //    000     000   000     000     000   000  000   000  000  000   000  000                 000  
      //    000      0000000      000      0000000   000   000  000  000   000  0000000        0000000   
      name: 'TUTORIAL 5',
      addUnit: 3,
      hint: ["New processes are spawned regularily in active nodes.\n\nAlways make sure you have more active nodes than the opponent.",
    "You can see the number of active nodes in the top right corner.\n\nThe graph plots the relative amount of available processes."],
      dots: [
        {
          v: [0,
        0,
        1],
          u: 60
        },
        {
          v: [-0.5,
        -0.5,
        1]
        },
        {
          v: [0.5,
        -0.5,
        1]
        },
        {
          v: [-0.5,
        0.5,
        1]
        },
        {
          v: [0.5,
        0.5,
        1]
        },
        {
          v: [-1,
        0,
        1]
        },
        {
          v: [1,
        0,
        1]
        },
        {
          v: [0,
        -1,
        1]
        },
        {
          v: [0,
        1,
        1]
        },
        {
          v: [-1,
        -1,
        0],
          b: 12
        },
        {
          v: [1,
        -1,
        0],
          b: 12
        },
        {
          v: [-1,
        1,
        0],
          b: 12
        },
        {
          v: [1,
        1,
        0],
          b: 12
        },
        {
          v: [0,
        0,
        -1],
          b: 12
        }
      ]
    },
    {
      // 00000000   0000000    0000000  000   000  
      // 000       000   000  000        000 000   
      // 0000000   000000000  0000000     00000    
      // 000       000   000       000     000     
      // 00000000  000   000  0000000      000     
      name: 'EASY',
      synt: {
        usr: {
          instrument: 'organ1'
        },
        bot: {
          instrument: 'organ2'
        }
      },
      addUnit: 2,
      hint: ["Be prepared, the red nodes are fighting back!",
    "You learned the basics, remove the virus from the system!"],
      dots: [
        {
          v: [0,
        0,
        1],
          u: 60
        },
        {
          v: [-0.5,
        -0.5,
        1]
        },
        {
          v: [0.5,
        -0.5,
        1]
        },
        {
          v: [-0.5,
        0.5,
        1]
        },
        {
          v: [0.5,
        0.5,
        1]
        },
        {
          v: [-1,
        0,
        1]
        },
        {
          v: [1,
        0,
        1]
        },
        {
          v: [0,
        -1,
        1]
        },
        {
          v: [0,
        1,
        1]
        },
        {
          v: [-1,
        -1,
        -1]
        },
        {
          v: [1,
        -1,
        -1]
        },
        {
          v: [-1,
        1,
        -1]
        },
        {
          v: [1,
        1,
        -1]
        },
        {
          v: [0,
        0,
        -1],
          b: 60
        }
      ],
      bot: {
        speed: 8,
        i: -1
      }
    },
    {
      
      //  0000000  000  00000000    0000000  000      00000000   0000000  
      // 000       000  000   000  000       000      000       000       
      // 000       000  0000000    000       000      0000000   0000000   
      // 000       000  000   000  000       000      000            000  
      //  0000000  000  000   000   0000000  0000000  00000000  0000000   
      name: 'CIRCLES',
      synt: {
        usr: {
          instrument: 'string'
        },
        bot: {
          instrument: 'flute'
        }
      },
      addUnit: 4,
      dots: [
        {
          v: [0,
        0,
        1],
          u: 60
        },
        {
          c: [8,
        45,
        0,
        0]
        },
        {
          c: [8,
        45,
        0,
        180]
        },
        {
          c: [16,
        90,
        0,
        0]
        },
        {
          v: [0,
        0,
        -1],
          b: 60
        }
      ],
      bot: {
        speed: 7,
        i: -1
      }
    },
    {
      // 00000000   000  000   000   0000000   
      // 000   000  000  0000  000  000        
      // 0000000    000  000 0 000  000  0000  
      // 000   000  000  000  0000  000   000  
      // 000   000  000  000   000   0000000   
      name: 'RING',
      synt: {
        usr: {
          instrument: 'bell1'
        },
        bot: {
          instrument: 'bell2'
        }
      },
      addUnit: 4,
      dots: [
        {
          v: [0,
        0,
        1],
          u: 60
        },
        {
          c: [5,
        90,
        -30,
        90,
        30]
        },
        {
          c: [5,
        -90,
        -30,
        90,
        30]
        },
        {
          c: [5,
        70,
        -120,
        90,
        30]
        },
        {
          c: [5,
        70,
        -60,
        -90,
        30]
        },
        {
          v: [0,
        0,
        -1],
          b: 60
        }
      ],
      bot: {
        speed: 5,
        i: -1
      }
    },
    {
      //  0000000  000       0000000    0000000  00000000  
      // 000       000      000   000  000       000       
      // 000       000      000   000  0000000   0000000   
      // 000       000      000   000       000  000       
      //  0000000  0000000   0000000   0000000   00000000  
      name: 'CLOSE',
      addUnit: 4,
      dots: [
        {
          v: [-0.4,
        0,
        1],
          u: 60
        },
        {
          c: [11,
        90,
        -15,
        45,
        15]
        },
        {
          c: [11,
        -90,
        -15,
        45,
        15]
        },
        {
          v: [0.4,
        0,
        1],
          b: 60
        }
      ],
      bot: {
        speed: 4,
        i: -1
      }
    },
    {
      // 00000000    0000000   000      00000000   0000000  
      // 000   000  000   000  000      000       000       
      // 00000000   000   000  000      0000000   0000000   
      // 000        000   000  000      000            000  
      // 000         0000000   0000000  00000000  0000000   
      name: 'POLES',
      synt: {
        usr: {
          instrument: 'bell3'
        },
        bot: {
          instrument: 'bell4'
        }
      },
      addUnit: 4,
      dots: [
        {
          v: [0,
        0,
        1],
          u: 60
        },
        {
          c: [8,
        20,
        90,
        0]
        },
        {
          c: [8,
        20,
        -90,
        0]
        },
        {
          c: [8,
        20,
        0,
        90]
        },
        {
          c: [8,
        20,
        0,
        -90]
        },
        {
          v: [0,
        0,
        -1],
          b: 60
        }
      ],
      bot: {
        speed: 6,
        i: -1
      }
    },
    {
      
      // 000   000  000   000  00000000   0000000   000  00000000   
      // 000   000  0000  000  000       000   000  000  000   000  
      // 000   000  000 0 000  000000    000000000  000  0000000    
      // 000   000  000  0000  000       000   000  000  000   000  
      //  0000000   000   000  000       000   000  000  000   000  
      name: 'UNFAIR',
      addUnit: 6,
      dots: [
        {
          v: [0,
        0,
        1],
          u: 90
        },
        {
          c: [4,
        15,
        180,
        0]
        },
        {
          c: [8,
        30,
        180,
        0]
        },
        {
          c: [16,
        45,
        180,
        0]
        },
        {
          v: [0,
        0,
        -1],
          b: 360
        }
      ],
      bot: {
        speed: 3,
        i: -1
      }
    },
    {
      // 00000000  00000000   00000000  000   000  0000000  000   000  
      // 000       000   000  000       0000  000     000    000 000   
      // 000000    0000000    0000000   000 0 000    000      00000    
      // 000       000   000  000       000  0000   000        000     
      // 000       000   000  00000000  000   000  0000000     000     
      name: 'FRENZY',
      addUnit: 12,
      dots: [
        {
          v: [0,
        0,
        1],
          u: 180
        },
        {
          c: [4,
        22.5,
        0,
        0]
        },
        {
          c: [4,
        22.5,
        180,
        0]
        },
        {
          c: [4,
        22.5,
        90,
        0]
        },
        {
          c: [4,
        22.5,
        -90,
        0]
        },
        {
          c: [6,
        40,
        0,
        0]
        },
        {
          c: [6,
        40,
        180,
        0]
        },
        {
          c: [6,
        40,
        90,
        0]
        },
        {
          c: [6,
        40,
        -90,
        0]
        },
        {
          v: [0,
        0,
        -1],
          b: 12
        },
        {
          v: [1,
        0,
        0],
          b: 12
        },
        {
          v: [-1,
        0,
        0],
          b: 12
        },
        {
          v: [0,
        1,
        0],
          b: 12
        },
        {
          v: [0,
        -1,
        0],
          b: 12
        }
      ],
      bot: {
        speed: 2,
        i: -1
      }
    }
  ];

  levels = {};

  for (index = j = 0, ref = levelList.length; (0 <= ref ? j < ref : j > ref); index = 0 <= ref ? ++j : --j) {
    level = levelList[index];
    level.index = index;
    levels[level.name] = level;
  }

  /*
   0000000  00000000   00000000   000   000
  000       000   000  000   000  000  000 
  0000000   00000000   0000000    0000000  
   000  000        000   000  000  000 
  0000000   000        000   000  000   000
  */
  Sprk = class Sprk {
    constructor(dot1, units) {
      var i, ref1, u;
      this.dot = dot1;
      this.units = Math.ceil(units / 3);
      this.sparks = [];
      this.ticks = 0;
      this.g = add('g');
      for (i = u = 0, ref1 = this.units; (0 <= ref1 ? u < ref1 : u > ref1); i = 0 <= ref1 ? ++u : --u) {
        this.sparks.push(app(this.g, 'circle', {
          class: `spark ${this.dot.own}`,
          r: screen.radius / 60
        }));
      }
      world.sparks.push(this);
    }

    upd() {
      var angle, f, i1, len, len1, mu, p, ref1, ref2, results, s, u, v, z;
      p = u2s(this.dot.v);
      this.g.setAttribute('transform', `translate(${p.x}, ${p.y})`);
      z = 0.5 + this.dot.depth() * 0.5;
      if (!world.pause) {
        this.ticks += 1;
      }
      mu = Math.max(5 * this.units, 120);
      if (this.ticks > mu) {
        ref1 = this.sparks;
        for (u = 0, len = ref1.length; u < len; u++) {
          s = ref1[u];
          s.remove();
        }
        return world.sparks.splice(world.sparks.indexOf(this), 1);
      } else {
        angle = 0;
        f = this.ticks / mu;
        ref2 = this.sparks;
        results = [];
        for (i1 = 0, len1 = ref2.length; i1 < len1; i1++) {
          s = ref2[i1];
          angle += 2 * Math.PI / this.sparks.length;
          v = vec(Math.cos(angle), Math.sin(angle));
          v.mul(this.dot.radius() + mu * f * z * screen.radius / 500);
          s.setAttribute('r', (0.5 + 0.5 * f) * z * screen.radius / 60);
          s.setAttribute('opacity', Math.cos(f * Math.PI));
          s.setAttribute('cx', v.x);
          results.push(s.setAttribute('cy', v.y));
        }
        return results;
      }
    }

  };

  /*
  0000000     0000000   000000000
  000   000  000   000     000   
  000   000  000   000     000   
  000   000  000   000     000   
  0000000     0000000      000   
  */
  Dot = class Dot {
    constructor(v1) {
      this.onTimer = this.onTimer.bind(this);
      this.v = v1;
      this.minUnits = 12; // minimum number of units to allow linking other dots 
      this.own = '';
      this.units = 0;
      this.targetUnits = 0;
      this.n = [];
      this.i = world.dots.length;
      this.v.norm();
      this.g = add('g');
      this.c = app(this.g, 'circle', {
        class: 'dot',
        id: this.i,
        cx: 0,
        cy: 0,
        r: 1.3
      });
      this.c.dot = this;
      world.dots.push(this);
    }

    
    // 000000000  000  00     00  00000000  00000000   
    //    000     000  000   000  000       000   000  
    //    000     000  000000000  0000000   0000000    
    //    000     000  000 0 000  000       000   000  
    //    000     000  000   000  00000000  000   000  
    startTimer(units, snd1 = 'send', cst = 0) {
      this.snd = snd1;
      this.cst = cst;
      this.targetUnits += units;
      clearInterval(this.timer);
      return this.timer = setInterval(this.onTimer, 160);
    }

    onTimer() {
      if (world.pause) {
        return;
      }
      snd.play(this.own, this.snd, this.cst);
      if (this.targetUnits > this.units) {
        this.units += 10;
        if (this.units >= this.targetUnits) {
          this.units = this.targetUnits;
        }
      } else {
        this.units -= 10;
        if (this.units <= this.targetUnits) {
          this.units = this.targetUnits;
        }
      }
      if (this.units === this.targetUnits) {
        clearInterval(this.timer);
        delete this.timer;
      }
      if (this.units === 0) {
        this.unlink();
      }
      return this.drawPie();
    }

    setUnits(units1) {
      this.units = units1;
      this.targetUnits = this.units;
      return this.drawPie();
    }

    addUnit(num = 1) {
      if (num !== 0) {
        this.targetUnits = clamp(0, 360, this.targetUnits + num);
        this.units = clamp(0, 360, this.units + num);
        return this.drawPie();
      }
    }

    drawPie() {
      var c, f, s;
      if (!this.pie) {
        this.pie = app(this.g, 'path', {
          class: 'pie'
        });
      }
      
      //A rx ry x-axis-rotation large-arc-flag sweep-flag x y
      if (this.units < this.minUnits) {
        this.c.classList.remove('linked');
        s = 0;
        c = -1;
        return this.pie.setAttribute('d', "M0,-1 A1,1 0 1,0 0,1 A1,1 0 0,0 0,-1 z");
      } else {
        this.c.classList.add('linked');
        s = Math.sin(d2r(this.units));
        c = -Math.cos(d2r(this.units));
        f = this.units <= 180 && '1,0' || '0,0';
        return this.pie.setAttribute('d', `M0,0 L0,-1 A1,1 0 ${f} ${s},${c} z`);
      }
    }

    depth() {
      return (this.v.z + 1) / 2;
    }

    zdepth() {
      return this.depth();
    }

    radius() {
      return ((this.depth() + 0.3) / 1.5) * screen.radius / 20;
    }

    raise() {
      return this.g.parentNode.appendChild(this.g);
    }

    closest() {
      return world.dots.slice(0).sort((a, d) => {
        return this.dist(a) - this.dist(d);
      }).slice(1);
    }

    dist(d) {
      return this.v.angle(d.v);
    }

    neutralize() {
      this.own = '';
      this.units = 0;
      this.targetUnits = 0;
      this.c.classList.remove('bot');
      return this.c.classList.remove('usr');
    }

    linked(d) {
      return (indexOf.call(this.n, d) >= 0) || (indexOf.call(d.n, this) >= 0);
    }

    unlink() {
      world.lines = world.lines.filter((l) => {
        if (l.s === this || l.e === this) {
          l.e.n = l.e.n.filter((n) => {
            return n !== this;
          });
          l.s.n = l.s.n.filter((n) => {
            return n !== this;
          });
          l.c.remove();
          return false;
        } else {
          return true;
        }
      });
      this.n = [];
      return this.neutralize();
    }

    
    // 000      000  000   000  000   000  
    // 000      000  0000  000  000  000   
    // 000      000  000 0 000  0000000    
    // 000      000  000  0000  000  000   
    // 0000000  000  000   000  000   000  
    link(d) {
      var cost, lnk, ou, sound, tooMuch, uh, ul;
      if (d === this || this.targetUnits < this.minUnits || this.linked(d)) {
        return;
      }
      cost = 0.5 * r2d(this.dist(d)) / 180;
      if (d.own === this.own) {
        cost = 0;
      }
      ul = Math.ceil(this.targetUnits * 0.5);
      uh = Math.ceil(ul * (1 - cost));
      // log "ul #{ul} uh #{uh} #{cost}"
      if (cost === 0) {
        if (d.targetUnits + uh > 360) {
          tooMuch = d.targetUnits + uh - 360;
          uh -= tooMuch;
          ul -= tooMuch;
        }
      }
      ou = uh;
      if (d.own !== '' && d.own !== this.own) {
        ou = -uh;
        new Sprk(this, ul);
        if (uh === d.targetUnits) {
          sound = 'draw';
          new Sprk(d, uh);
        } else if (uh < d.targetUnits) {
          sound = 'lost';
          new Sprk(d, uh);
        } else {
          sound = 'won';
          lnk = 1;
          ou = uh - d.targetUnits;
          new Sprk(d, d.targetUnits);
          d.unlink();
          d.setOwn(this.own);
        }
      } else {
        lnk = 1;
        sound = 'send';
        d.setOwn(this.own);
        new Sprk(d, Math.floor(ul * cost));
      }
      this.startTimer(-ul, sound, parseInt(cost * 18));
      d.startTimer(ou);
      if (lnk) {
        world.update = 1;
        return new Line(this, d);
      } else {
        return null;
      }
    }

    setOwn(own) {
      this.own = own;
      this.c.classList.toggle('bot', this.own === 'bot');
      return this.c.classList.toggle('usr', this.own === 'usr');
    }

    
    //  0000000  00000000  000   000  0000000    
    // 000       000       0000  000  000   000  
    // 0000000   0000000   000 0 000  000   000  
    //      000  000       000  0000  000   000  
    // 0000000   00000000  000   000  0000000    
    send(v) {
      var clos, dist, target, tgt;
      delTmpl('usr');
      if (mouse.touch && mouse.touch !== this && !this.linked(mouse.touch)) {
        tgt = mouse.touch;
      } else {
        dist = function(d) {
          return v.angle(d.v);
        };
        clos = world.dots.slice(0).sort((a, b) => {
          return dist(a) - dist(b);
        });
        tgt = clos[0];
      }
      if (tgt !== this && !this.linked(tgt)) {
        target = tgt;
      } else {
        target = {
          v: v,
          depth: function() {
            return (v.z + 1) / 2;
          }
        };
      }
      return world.tmpline.usr = new Line(this, target, true);
    }

    rot(q) {
      return this.v = q.rotate(this.v);
    }

    upd() {
      var p;
      p = u2s(this.v);
      this.g.setAttribute('transform', `translate(${p.x},${p.y}) scale(${this.radius()})`);
      return brightness(this);
    }

  };

  /*
  0000000     0000000   000000000
  000   000  000   000     000   
  0000000    000   000     000   
  000   000  000   000     000   
  0000000     0000000      000   
  */
  Bot = class Bot {
    constructor() {
      this.speed = 4;
      this.tsum = 0;
    }

    tmpl(d, c) {
      delTmpl('bot');
      world.tmpline.bot = new Line(d, c, true);
      return world.update = 1;
    }

    anim(dta) {
      var c, cls, d, dots, len, u;
      this.tsum += dta;
      if (this.tsum > this.speed * 60) {
        dots = world.dots.filter(function(d) {
          return d.own === 'bot';
        });
        this.tsum = 0;
        if (dots.length === 0) {
          return;
        }
        dots.sort(function(a, b) {
          return b.units - a.units;
        });
        d = dots[0];
        cls = d.closest();
        for (u = 0, len = cls.length; u < len; u++) {
          c = cls[u];
          if (!d.linked(c)) {
            d.link(c);
            this.tmpl(d, c);
            return;
          }
        }
      }
    }

  };

  /*
  000      000  000   000  00000000  
  000      000  0000  000  000       
  000      000  000 0 000  0000000   
  000      000  000  0000  000       
  0000000  000  000   000  00000000  
  */
  Line = class Line {
    constructor(s1, e1, tmp) {
      var ref1, ref2;
      this.s = s1;
      this.e = e1;
      this.c = add('path', {
        class: 'line'
      });
      if (this.s.own) {
        this.c.classList.add(this.s.own);
      }
      if (tmp) {
        this.c.classList.add('tmp');
        this.s.c.classList.add('src');
      } else {
        if ((ref1 = this.s.n) != null) {
          ref1.push(this.e);
        }
        if ((ref2 = this.e.n) != null) {
          ref2.push(this.s);
        }
        world.lines.push(this);
      }
    }

    del() {
      this.s.c.classList.remove('src');
      return this.c.remove();
    }

    depth() {
      return (this.s.depth() + this.e.depth()) / 2;
    }

    zdepth() {
      return Math.min(this.s.depth(), this.e.depth()) - 0.001;
    }

    raise() {
      var ref1;
      return (ref1 = this.c.parentNode) != null ? ref1.appendChild(this.c) : void 0;
    }

    upd() {
      this.c.setAttribute('d', arc(this.s.v, this.e.v));
      brightness(this);
      return this.c.style.strokeWidth = ((this.depth() + 0.3) / 1.5) * screen.radius / 50;
    }

  };

  // 000       0000000    0000000   0000000        000      00000000  000   000  00000000  000        
  // 000      000   000  000   000  000   000      000      000       000   000  000       000        
  // 000      000   000  000000000  000   000      000      0000000    000 000   0000000   000        
  // 000      000   000  000   000  000   000      000      000          000     000       000        
  // 0000000   0000000   000   000  0000000        0000000  00000000      0      00000000  0000000    
  loadNext = function() {
    var ref1, ref2;
    if (world.winner === 'usr') {
      return loadLevel((ref1 = (ref2 = levelList[world.level.index + 1]) != null ? ref2.name : void 0) != null ? ref1 : 'menu');
    } else if (world.level.index < 6) {
      return forceLevel(world.level.name);
    } else {
      return loadLevel('menu');
    }
  };

  forceLevel = function(level) {
    world.level = null;
    return loadLevel(level);
  };

  loadLevel = function(level) {
    svg.innerHTML = '';
    menu.bot.innerHTML = '';
    menu.usr.innerHTML = '';
    world.circle = add('circle', {
      class: 'world',
      cx: screen.center.x,
      cy: screen.center.y,
      r: screen.radius
    });
    world.circle.v = vec();
    world.ticks = 0;
    world.dots = [];
    world.lines = [];
    world.update = 1;
    world.winner = null;
    mouse.drag = null;
    bot = null;
    delTmpl('usr');
    delTmpl('bot');
    hint();
    popup();
    if (level === 'menu') {
      showMenu('menu');
    } else {
      showMenu('game');
    }
    switch (level) {
      case 'RANDOM':
        randomLevel();
        break;
      default:
        initLevel(level);
    }
    if (world.pause) {
      return pause();
    }
  };

  
  // 000  000   000  000  000000000        000      00000000  000   000  00000000  000    
  // 000  0000  000  000     000           000      000       000   000  000       000    
  // 000  000 0 000  000     000           000      0000000    000 000   0000000   000    
  // 000  000  0000  000     000           000      000          000     000       000    
  // 000  000   000  000     000           0000000  00000000      0      00000000  0000000
  initLevel = function(name) {
    var a, d, dot, i, i1, j1, l, len, len1, q, ref1, ref2, ref3, ref4, ref5, ref6, u, v;
    if (((ref1 = world.level) != null ? ref1.name : void 0) === name) {
      return;
    }
    level = levels[name];
    ref2 = level.dots;
    for (u = 0, len = ref2.length; u < len; u++) {
      d = ref2[u];
      if (d.c) {
        for (i = i1 = 0, ref3 = d.c[0]; (0 <= ref3 ? i1 < ref3 : i1 > ref3); i = 0 <= ref3 ? ++i1 : --i1) {
          q = Quat.axis(vec(0, 1, 0), d2r(d.c[2])).mul(Quat.axis(vec(1, 0, 0), d2r(d.c[3])));
          v = vec(0, 0, 1);
          v = Quat.axis(vec(1, 0, 0), d2r(d.c[1])).rotate(v);
          a = (ref4 = d.c[4]) != null ? ref4 : 360 / d.c[0];
          v = Quat.axis(vec(0, 0, 1), d2r(i * a)).rotate(v);
          v = q.rotate(v);
          dot = new Dot(v);
        }
        continue;
      }
      dot = new Dot(vec(d.v[0], d.v[1], d.v[2]));
      if (d.u) {
        dot.setOwn('usr');
        dot.setUnits(d.u);
      }
      if (d.b) {
        dot.setOwn('bot');
        dot.setUnits(d.b);
      }
      if (name === 'menu') {
        dot.level = d.l;
        if (pref.get(d.l)) {
          dot.setOwn('usr');
        }
      }
    }
    ref6 = (ref5 = level.lines) != null ? ref5 : [];
    for (j1 = 0, len1 = ref6.length; j1 < len1; j1++) {
      l = ref6[j1];
      new Line(world.dots[l[0]], world.dots[l[1]]);
    }
    if (level.bot) {
      l = world.dots.length;
      i = (l + level.bot.i) % l;
      bot = new Bot(world.dots[i]);
      if (level.bot.speed) {
        bot.speed = level.bot.speed;
      }
    }
    if (level.msg) {
      msg(level.msg);
    } else {
      msg();
    }
    if (level.hint) {
      hint(level.hint[0], level.hint[1]);
    } else {
      hint('', level.name);
    }
    if (name === 'menu') {
      delete level.msg;
      delete level.hint;
    }
    world.level = level;
    world.addUnit = level.addUnit;
    if (level.synt) {
      snd.setSynt(level.synt);
    }
    if (world.addUnit) {
      return grph = new Grph;
    }
  };

  
  // 00000000    0000000   000   000  0000000     0000000   00     00  
  // 000   000  000   000  0000  000  000   000  000   000  000   000  
  // 0000000    000000000  000 0 000  000   000  000   000  000000000  
  // 000   000  000   000  000  0000  000   000  000   000  000 0 000  
  // 000   000  000   000  000   000  0000000     0000000   000   000  
  randomLevel = function() {
    var b, d, ed, i, i1, j1, len, nodes, ok, ref1, ref2, ref3, ref4, u, v;
    grph = new Grph;
    world.addUnit = 1;
    world.level = {
      name: 'RANDOM'
    };
    d = new Dot(vec(0, 0, 1));
    d.setOwn('usr');
    nodes = (ref1 = world.nodes) != null ? ref1 : 2 * parseInt(randr(8, 20));
    for (i = u = 1, ref2 = nodes / 2; (1 <= ref2 ? u < ref2 : u > ref2); i = 1 <= ref2 ? ++u : --u) {
      v = vec(randr(-1, 1), randr(-1, 1), randr(0, 1));
      v.norm();
      while (true) {
        ok = true;
        ref3 = world.dots;
        for (i1 = 0, len = ref3.length; i1 < len; i1++) {
          ed = ref3[i1];
          if (v.angle(ed.v) < 0.2) {
            v = vec(randr(-1, 1), randr(-1, 1), randr(0, 1));
            v.norm();
            ok = false;
            break;
          }
        }
        if (ok) {
          break;
        }
      }
      new Dot(v);
    }
    for (i = j1 = ref4 = nodes / 2 - 1; (ref4 <= 0 ? j1 <= 0 : j1 >= 0); i = ref4 <= 0 ? ++j1 : --j1) {
      new Dot(world.dots[i].v.times(-1).add(vec(0.01)));
    }
    b = world.dots[world.dots.length - 1];
    b.setOwn('bot');
    bot = new Bot();
    b.startTimer(360);
    return d.startTimer(360);
  };

  menuVolume = function(vol) {
    var ref1;
    snd.play('menu', 'draw');
    return (ref1 = menu.buttons.VOL) != null ? ref1.innerHTML = `${Math.floor(vol * 100) / 100}` : void 0;
  };

  menus = {
    menu: [
      {
        OPTIONS: {
          click: function() {
            return showMenu('options');
          }
        }
      }
    ],
    game: [
      {
        PAUSE: {
          click: function() {
            return pause();
          }
        }
      }
    ],
    options: [
      {
        OPTIONS: {
          click: function() {
            return showMenu('menu');
          }
        }
      },
      {
        FULLSCREEN: {
          click: function() {
            return toggleFullscreen();
          }
        }
      },
      {
        VOLUME: {
          class: 'choice',
          values: ['-',
      'VOL',
      '+'],
          cb: function(c) {
            if (c === '+') {
              return snd.volUp();
            } else if (c === '-') {
              return snd.volDown();
            }
          }
        }
      },
      {
        ABOUT: {
          click: function() {
            return menuAbout();
          }
        }
      },
      {
        'RESET PROGRESS': {
          click: function() {
            pref.clear();
            return forceLevel('menu');
          }
        }
      }
    ],
    pause: [
      {
        UNPAUSE: {
          click: function() {
            return pause();
          }
        }
      },
      {
        MENU: {
          click: function() {
            return loadLevel('menu');
          }
        }
      },
      {
        RESET: {
          click: function() {
            return forceLevel(world.level.name);
          }
        }
      },
      {
        FULLSCREEN: {
          click: function() {
            return toggleFullscreen();
          }
        }
      },
      {
        VOLUME: {
          class: 'choice',
          values: ['-',
      'VOL',
      '+'],
          cb: function(c) {
            if (c === '+') {
              return snd.volUp();
            } else if (c === '-') {
              return snd.volDown();
            }
          }
        }
      }
    ],
    next: [
      {
        NEXT: {
          click: function() {
            return loadNext();
          }
        }
      },
      {
        MENU: {
          click: function() {
            return loadLevel('menu');
          }
        }
      },
      {
        RESET: {
          click: function() {
            return forceLevel(world.level.name);
          }
        }
      }
    ]
  };

  //  0000000  000   000   0000000   000   000  
  // 000       000   000  000   000  000 0 000  
  // 0000000   000000000  000   000  000000000  
  //      000  000   000  000   000  000   000  
  // 0000000   000   000   0000000   00     00  
  showMenu = function(m) {
    var info, item, k, len, mnu, name, ref1, results, u, v;
    snd.play('menu', 'send');
    ref1 = menu.buttons;
    for (k in ref1) {
      v = ref1[k];
      v.remove();
      delete menu.buttons[k];
    }
    mnu = menus[m];
    results = [];
    for (u = 0, len = mnu.length; u < len; u++) {
      item = mnu[u];
      name = Object.keys(item)[0];
      info = item[name];
      if (info.class == null) {
        info.class = 'button';
      }
      if (info.text == null) {
        info.text = name;
      }
      if (info.class === 'choice') {
        results.push(choice(info));
      } else {
        results.push(menu.buttons[name] = elem('div', info, menu.left));
      }
    }
    return results;
  };

  
  // 00000000  000   000  000      000       0000000   0000000  00000000   00000000  00000000  000   000  
  // 000       000   000  000      000      000       000       000   000  000       000       0000  000  
  // 000000    000   000  000      000      0000000   000       0000000    0000000   0000000   000 0 000  
  // 000       000   000  000      000           000  000       000   000  000       000       000  0000  
  // 000        0000000   0000000  0000000  0000000    0000000  000   000  00000000  00000000  000   000  
  isFullscreen = function() {
    return document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement;
  };

  toggleFullscreen = function() {
    var efs, el, rfs;
    snd.play('menu', 'draw');
    if (isFullscreen()) {
      efs = document.exitFullscreen || document.webkitExitFullscreen || document.mozCancelFullScreen;
      return efs.call(document);
    } else {
      el = document.documentElement;
      rfs = el.requestFullscreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullscreen;
      return rfs.call(el);
    }
  };

  // 00000000  000      00000000  00     00  
  // 000       000      000       000   000  
  // 0000000   000      0000000   000000000  
  // 000       000      000       000 0 000  
  // 00000000  0000000  00000000  000   000  
  elem = function(t, o, p) {
    var e;
    // log "#{t} #{p}", o
    e = document.createElement(t);
    if (o.text != null) {
      e.innerText = o.text;
    }
    if (o.html != null) {
      e.innerHTML = o.html;
    }
    if (o.click != null) {
      e.addEventListener('click', o.click);
    }
    p.appendChild(opt(e, o));
    return e;
  };

  
  // 00     00   0000000   0000000   
  // 000   000  000       000        
  // 000000000  0000000   000  0000  
  // 000 0 000       000  000   000  
  // 000   000  0000000    0000000   
  msg = function(t, cls = '') {
    var ref1;
    if ((ref1 = screen.msg) != null) {
      ref1.remove();
    }
    if (t) {
      screen.msg = elem('div', {
        class: `msg ${cls}`,
        text: t
      }, main);
      return fontSize('msg', screen.msg);
    }
  };

  
  // 000   000  000  000   000  000000000  
  // 000   000  000  0000  000     000     
  // 000000000  000  000 0 000     000     
  // 000   000  000  000  0000     000     
  // 000   000  000  000   000     000     
  hint = function(t1, t2) {
    var ref1, ref2;
    if ((ref1 = screen.hint1) != null) {
      ref1.remove();
    }
    if ((ref2 = screen.hint2) != null) {
      ref2.remove();
    }
    if (t1) {
      screen.hint1 = elem('div', {
        class: "hint1",
        text: t1
      }, main);
      fontSize('hint', screen.hint1);
    }
    if (t2) {
      screen.hint2 = elem('div', {
        class: "hint2",
        text: t2
      }, main);
      return fontSize('hint', screen.hint2);
    }
  };

  
  // 00000000    0000000   00000000   000   000  00000000   
  // 000   000  000   000  000   000  000   000  000   000  
  // 00000000   000   000  00000000   000   000  00000000   
  // 000        000   000  000        000   000  000        
  // 000         0000000   000         0000000   000        
  popup = function(p, t) {
    var ref1, s;
    if ((ref1 = screen.popup) != null) {
      ref1.remove();
    }
    if (t) {
      s = u2s(p);
      screen.popup = elem('div', {
        class: "popup",
        text: t
      }, main);
      screen.popup.style.left = `${s.x}px`;
      screen.popup.style.top = `${s.y - screen.radius / 7}px`;
      return fontSize('hint', screen.popup);
    }
  };

  
  //  0000000  000   000   0000000   000   0000000  00000000  
  // 000       000   000  000   000  000  000       000       
  // 000       000000000  000   000  000  000       0000000   
  // 000       000   000  000   000  000  000       000       
  //  0000000  000   000   0000000   000   0000000  00000000  
  choice = function(info) {
    var c, chose, len, ref1, results, u;
    menu.buttons[info.text] = elem('div', info, menu.left);
    ref1 = info.values;
    results = [];
    for (u = 0, len = ref1.length; u < len; u++) {
      c = ref1[u];
      chose = function(info, c) {
        return function(e) {
          var i1, len1, ref2, value;
          ref2 = info.values;
          for (i1 = 0, len1 = ref2.length; i1 < len1; i1++) {
            value = ref2[i1];
            menu.buttons[value].classList.remove('highlight');
          }
          if (c !== '+' && c !== '-' && c !== 'VOL') {
            e.target.classList.add('highlight');
          }
          if (c !== 'VOL') {
            info.cb(c);
          }
          return e.stopPropagation();
        };
      };
      menu.buttons[c] = elem('div', {
        class: 'button',
        text: c,
        click: chose(info, c)
      }, menu.left);
      if (c === 'VOL') {
        results.push(menuVolume(snd.vol));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  //  0000000   0000000     0000000   000   000  000000000  
  // 000   000  000   000  000   000  000   000     000     
  // 000000000  0000000    000   000  000   000     000     
  // 000   000  000   000  000   000  000   000     000     
  // 000   000  0000000     0000000    0000000      000     
  menuAbout = function() {
    var closeAbout, ref1, t;
    snd.play('menu', 'draw');
    if ((ref1 = menu.about) != null) {
      ref1.remove();
    }
    closeAbout = function(e) {
      menu.about.remove();
      delete menu.about;
      return snd.play('menu', 'won');
    };
    t = '';
    t += "<div class='konnekt'>KONNEKT</div> is my entry for the <a href='https://js13kgames.com/' target='_blank'>js13kgames</a> 2018 competition.<br>";
    t += "Thanks to the organizers!<p>";
    t += "The sources are available at ";
    t += "<a href='https://github.com/monsterkodi/konnekt' target='_blank'>github</a>.<p>";
    t += "I hope you had some fun playing the game.<div class='version'>v1.0</div>";
    return menu.about = elem('div', {
      class: 'about',
      html: t,
      click: closeAbout
    }, main);
  };

  menu.usr = elem('div', {
    class: 'button usr'
  }, menu.right);

  menu.bot = elem('div', {
    class: 'button bot'
  }, menu.right);

  /*
  00     00   0000000   000  000   000    
  000   000  000   000  000  0000  000    
  000000000  000000000  000  000 0 000    
  000 0 000  000   000  000  000  0000    
  000   000  000   000  000  000   000    
  */

  //  0000000  000  0000000  00000000  
  // 000       000     000   000       
  // 0000000   000    000    0000000   
  //      000  000   000     000       
  // 0000000   000  0000000  00000000  
  fontSize = function(name, e) {
    var s;
    if (e) {
      s = (function() {
        switch (name) {
          case 'msg':
            return screen.radius / 6;
          case 'hint':
            return screen.radius / 20;
          case 'menu':
            return Math.max(12, screen.radius / 30);
        }
      })();
      return e.style.fontSize = `${parseInt(s)}px`;
    }
  };

  size = function() {
    var br;
    br = svg.getBoundingClientRect();
    screen.size = vec(br.width, br.height);
    screen.center = vec(br.width / 2, br.height / 2);
    screen.radius = 0.4 * Math.min(screen.size.x, screen.size.y);
    world.update = 1;
    if (world.circle) {
      world.circle.setAttribute('cx', screen.center.x);
      world.circle.setAttribute('cy', screen.center.y);
      world.circle.setAttribute('r', screen.radius);
    }
    fontSize('hint', screen.hint1);
    fontSize('hint', screen.hint2);
    fontSize('msg', screen.msg);
    fontSize('menu', menu.left);
    return grph != null ? grph.plot() : void 0;
  };

  size();

  // 00     00   0000000   000   000  00000000  
  // 000   000  000   000  000   000  000       
  // 000000000  000   000   000 000   0000000   
  // 000 0 000  000   000     000     000       
  // 000   000   0000000       0      00000000  
  dbg = elem('div', {
    class: 'dbg'
  }, main);

  onMove = function(e) {
    var d, len, moved, ref1, u;
    if (e.touches != null) {
      mouse.pos = vec(e.touches[0].clientX, e.touches[0].clientY);
      moved = vec(e.touches[0].movementX, e.touches[0].movementY);
      e.preventDefault();
    } else {
      mouse.pos = vec(e.clientX, e.clientY);
      moved = vec(e.movementX, e.movementY);
    }
    dbg.innerHTML = `moved: ${moved.x} ${moved.y}`;
    if (mouse.drag === 'rot') {
      world.userRot = rotq(moved);
      ref1 = world.dots;
      for (u = 0, len = ref1.length; u < len; u++) {
        d = ref1[u];
        d.rot(world.userRot);
        world.update = 1;
      }
      return world.rotSum.add(moved.times(1 / 10));
    } else if (mouse.drag) {
      switch (e.buttons) {
        case 1:
          mouse.drag.send(s2u(mouse.pos));
          return world.update = 1;
      }
    }
  };

  // when 2
  // mouse.drag.v = s2u mouse.pos
  // world.update = 1
  win.addEventListener('mousemove', onMove);

  win.addEventListener('touchmove', onMove);

  
  // 0000000     0000000   000   000  000   000  
  // 000   000  000   000  000 0 000  0000  000  
  // 000   000  000   000  000000000  000 0 000  
  // 000   000  000   000  000   000  000  0000  
  // 0000000     0000000   00     00  000   000  
  delTmpl = function(o) {
    var ref1;
    if ((ref1 = world.tmpline[o]) != null) {
      ref1.del();
    }
    return delete world.tmpline[o];
  };

  onDown = function(e) {
    var ref1, ref2;
    delTmpl('usr');
    world.inertRot = new Quat;
    hint();
    popup();
    dbg.innerHTML = `down: ${((ref1 = e.touches) != null ? ref1[0].clientX : void 0)} ${((ref2 = e.touches) != null ? ref2[0].clientY : void 0)}`;
    if (world.level.name === 'menu') {
      msg();
    } else if (world.winner && e.buttons === 1 && !e.target.classList.contains('button')) {
      loadNext();
      return;
    }
    if (mouse.drag = e.target.dot) {
      if (world.level.name === 'menu') {
        if (e.buttons === 1) {
          loadLevel(mouse.drag.level);
        }
        return;
      }
      if (!world.pause) {
        if (mouse.drag.c.classList.contains('linked')) {
          if (mouse.drag.own !== 'bot') {
            return;
          }
        }
      }
    }
    return mouse.drag = 'rot';
  };

  win.addEventListener('mousedown', onDown);

  win.addEventListener('touchstart', onDown);

  
  // 000   000  00000000   
  // 000   000  000   000  
  // 000   000  00000000   
  // 000   000  000        
  //  0000000   000        
  onUp = function(e) {
    if (mouse.drag === 'rot') {
      world.inertRot = rotq(world.rotSum);
    } else if (mouse.drag) {
      world.inertRot = new Quat;
      if (world.tmpline.usr && world.tmpline.usr.e.c) {
        mouse.drag.link(world.tmpline.usr.e);
      }
      mouse.drag.c.classList.remove('src');
    }
    delTmpl('usr');
    mouse.drag = null;
    return world.update = 1;
  };

  win.addEventListener('mouseup', onUp);

  win.addEventListener('touchend', onUp);

  
  // 000   000   0000000   000   000  00000000  00000000     
  // 000   000  000   000  000   000  000       000   000    
  // 000000000  000   000   000 000   0000000   0000000      
  // 000   000  000   000     000     000       000   000    
  // 000   000   0000000       0      00000000  000   000    
  svg.addEventListener('mouseover', function(e) {
    var d;
    mouse.touch = e.target.dot;
    if (mouse.drag) {
      return;
    }
    if (d = e.target.dot) {
      if (!world.pause && d.c.classList.contains('linked') && d.own === 'usr' || world.level.name === 'menu') {
        if (d !== mouse.hover) {
          setHover(d);
          d.c.classList.add('src');
          if (world.level.name === 'menu') {
            msg();
            hint();
            return popup(d.v, d.level);
          }
        }
      } else if (mouse.hover) {
        return setHover();
      }
    }
  });

  setHover = function(a, r = 1) {
    var ref1;
    if (r) {
      if ((ref1 = mouse.hover) != null) {
        ref1.c.classList.remove('src');
      }
    }
    return mouse.hover = a;
  };

  svg.addEventListener('mouseout', function(e) {
    var d;
    mouse.touch = null;
    if (d = e.target.dot) {
      if (d === mouse.hover) {
        setHover(null, d !== mouse.drag);
        if (world.level.name === 'menu') {
          return popup();
        }
      }
    }
  });

  
  // 000   000  00000000  000   000  
  // 000  000   000        000 000   
  // 0000000    0000000     00000    
  // 000  000   000          000     
  // 000   000  00000000     000     
  win.addEventListener('keydown', function(e) {
    switch (e.keyCode) {
      case 32:
      case 27:
        return pause(); // space, esc
    }
  });

  // else log 'keydown', e

  // 00000000    0000000   000   000   0000000  00000000  
  // 000   000  000   000  000   000  000       000       
  // 00000000   000000000  000   000  0000000   0000000   
  // 000        000   000  000   000       000  000       
  // 000        000   000   0000000   0000000   00000000  
  pause = function(m = 'PAUSED', cls = '', status = 'pause') {
    var ref1;
    if (((ref1 = world.level) != null ? ref1.name : void 0) === 'menu') {
      return;
    }
    world.pause = !world.pause;
    showMenu(world.winner && 'next' || world.pause && 'pause' || 'game');
    return msg(world.pause && m || '', cls);
  };

  visibility = function() {
    if (document.hidden && !world.pause) {
      return pause();
    }
  };

  //  0000000   000   000  000  00     00  
  // 000   000  0000  000  000  000   000  
  // 000000000  000 0 000  000  000000000  
  // 000   000  000  0000  000  000 0 000  
  // 000   000  000   000  000  000   000  
  anim = function(now) {
    var d, dots, i1, items, j1, k1, l, l1, len, len1, len2, len3, len4, len5, m1, nextTick, ow, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, spark, u, x;
    nextTick = function() {
      win.requestAnimationFrame(anim);
      return now;
    };
    world.delta = (now - world.time) / 16;
    world.time = now;
    if (!world.level) {
      return nextTick();
    }
    if (!world.pause && world.level.name !== 'menu') {
      world.ticks += 1;
      if (world.ticks % 60 === 0) {
        ref1 = ['usr', 'bot'];
        for (u = 0, len = ref1.length; u < len; u++) {
          ow = ref1[u];
          dots = world.dots.filter(function(d) {
            return d.own === ow;
          });
          world.units[ow] = dots.reduce((function(a, b) {
            return a + b.targetUnits;
          }), 0);
          dots = dots.filter(function(d) {
            return d.units >= d.minUnits;
          });
          menu[ow].innerHTML = `&#9679; ${dots.length}`;
          if (dots.length === 0) {
            if (ow === 'bot') {
              world.winner = 'usr';
              pause('ONLINE!', 'usr');
              pref.set(world.level.name, true);
            } else {
              world.winner = 'bot';
              pause('OFFLINE!', 'bot');
            }
            if ((ref2 = screen.hint) != null) {
              ref2.remove();
            }
            world.update = 1;
            return nextTick();
          }
          for (i1 = 0, len1 = dots.length; i1 < len1; i1++) {
            d = dots[i1];
            d.addUnit(world.addUnit);
          }
        }
        if (grph != null) {
          grph.sample();
        }
        if (grph != null) {
          grph.plot();
        }
      }
      if (bot != null) {
        bot.anim(world.delta);
      }
    }
    world.rotSum.mul(0.8);
    world.inertRot.slerp(new Quat(), 0.01 * world.delta);
    if (!world.inertRot.zero() || world.update) {
      ref3 = world.dots;
      for (j1 = 0, len2 = ref3.length; j1 < len2; j1++) {
        d = ref3[j1];
        d.rot(world.inertRot);
        d.upd();
      }
      ref4 = world.lines;
      for (k1 = 0, len3 = ref4.length; k1 < len3; k1++) {
        l = ref4[k1];
        l.upd();
      }
      if ((ref5 = world.tmpline.usr) != null) {
        ref5.upd();
      }
      if ((ref6 = world.tmpline.bot) != null) {
        ref6.upd();
      }
      items = world.lines.concat(world.dots);
      if (world.tmpline.usr != null) {
        items.push(world.tmpline.usr);
      }
      if (world.tmpline.bot != null) {
        items.push(world.tmpline.bot);
      }
      ref7 = items.sort(function(a, b) {
        return a.zdepth() - b.zdepth();
      });
      for (l1 = 0, len4 = ref7.length; l1 < len4; l1++) {
        x = ref7[l1];
        x.raise();
      }
      world.update = 0;
    }
    ref8 = world.sparks.slice(0);
    for (m1 = 0, len5 = ref8.length; m1 < len5; m1++) {
      spark = ref8[m1];
      spark.upd();
    }
    return nextTick();
  };

  win.addEventListener('resize', size);

  win.addEventListener('contextmenu', function(e) {
    return e.preventDefault();
  });

  document.addEventListener('visibilitychange', visibility, false);

  pref.load();

  win.requestAnimationFrame(anim);

}).call(this);
