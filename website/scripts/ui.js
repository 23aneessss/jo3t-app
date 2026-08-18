/* JO3T marketing site — progressive enhancement only.
   Theme toggle, hero radar animation, scroll reveal. Nothing here is required
   for the page to be readable or navigable. */
(function () {
  'use strict';

  var root = document.documentElement;
  var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  /* ------------------------------------------------------------------ theme */

  var STORAGE_KEY = 'jo3t-theme';
  var toggle = document.getElementById('theme-toggle');
  var label = toggle && toggle.querySelector('.theme-toggle-label');
  var darkQuery = window.matchMedia('(prefers-color-scheme: dark)');

  function storedTheme() {
    try {
      var v = window.localStorage.getItem(STORAGE_KEY);
      return v === 'dark' || v === 'light' ? v : null;
    } catch (e) {
      return null;
    }
  }

  function applyTheme(theme, persist) {
    root.setAttribute('data-theme', theme);
    if (toggle) {
      var isDark = theme === 'dark';
      toggle.setAttribute('aria-pressed', String(isDark));
      toggle.setAttribute(
        'aria-label',
        isDark ? 'Switch to light theme' : 'Switch to dark theme'
      );
      if (label) label.textContent = isDark ? 'Light' : 'Dark';
    }
    if (persist) {
      try {
        window.localStorage.setItem(STORAGE_KEY, theme);
      } catch (e) {
        /* storage unavailable (private mode, blocked cookies) — theme still applies */
      }
    }
  }

  applyTheme(storedTheme() || (darkQuery.matches ? 'dark' : 'light'), false);

  if (toggle) {
    toggle.addEventListener('click', function () {
      applyTheme(root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark', true);
    });
  }

  // Follow the OS while the visitor has not made an explicit choice.
  var onSchemeChange = function (e) {
    if (!storedTheme()) applyTheme(e.matches ? 'dark' : 'light', false);
  };
  if (darkQuery.addEventListener) darkQuery.addEventListener('change', onSchemeChange);
  else if (darkQuery.addListener) darkQuery.addListener(onSchemeChange);

  /* ------------------------------------------------------------ hero radar */

  var canvas = document.getElementById('radar');
  var ctx = canvas && canvas.getContext && canvas.getContext('2d');

  if (ctx) {
    var SIZE = 520;              // logical drawing units
    var CX = SIZE / 2;
    var CY = SIZE / 2;
    var MAX_R = 232;             // outermost ring radius
    var RINGS = [0.34, 0.58, 0.82, 1];

    // Places orbiting the pin. radius is a fraction of MAX_R, speed in rad/sec.
    var PLACES = [
      { r: 0.40, a: 0.3, speed: 0.20, size: 7 },
      { r: 0.40, a: 3.6, speed: 0.20, size: 5 },
      { r: 0.63, a: 1.4, speed: -0.13, size: 8 },
      { r: 0.63, a: 4.7, speed: -0.13, size: 6 },
      { r: 0.63, a: 5.9, speed: -0.13, size: 5 },
      { r: 0.86, a: 0.9, speed: 0.09, size: 6 },
      { r: 0.86, a: 2.5, speed: 0.09, size: 8 },
      { r: 0.86, a: 4.1, speed: 0.09, size: 5 },
      { r: 0.86, a: 5.4, speed: 0.09, size: 7 }
    ];

    var palette = readPalette();

    function readPalette() {
      var cs = getComputedStyle(root);
      var get = function (name, fallback) {
        var v = cs.getPropertyValue(name).trim();
        return v || fallback;
      };
      return {
        accent: get('--accent', '#E8520A'),
        light: get('--orange-light', '#FF6B2B'),
        dark: get('--orange-dark', '#9E3006'),
        ring: get('--border-strong', '#D9C8BC'),
        muted: get('--text-muted', '#61524A')
      };
    }

    function resize() {
      var dpr = Math.min(window.devicePixelRatio || 1, 2);
      var css = canvas.clientWidth || SIZE;
      canvas.width = Math.round(css * dpr);
      canvas.height = Math.round(css * dpr);
      var scale = (css * dpr) / SIZE;
      ctx.setTransform(scale, 0, 0, scale, 0, 0);
    }

    function drawPin(x, y, s) {
      // Map pin: two arcs into a point, matching the app icon silhouette.
      ctx.save();
      ctx.translate(x, y);
      ctx.scale(s, s);
      ctx.beginPath();
      ctx.moveTo(0, 30);
      ctx.bezierCurveTo(-19, 2, -26, -6, -26, -16);
      ctx.arc(0, -16, 26, Math.PI, 0, false);
      ctx.bezierCurveTo(26, -6, 19, 2, 0, 30);
      ctx.closePath();
      var g = ctx.createLinearGradient(-26, -42, 26, 30);
      g.addColorStop(0, palette.light);
      g.addColorStop(1, palette.dark);
      ctx.fillStyle = g;
      ctx.fill();
      // fork + knife notch
      ctx.fillStyle = 'rgba(255,255,255,.92)';
      ctx.fillRect(-8.5, -28, 2.6, 10);
      ctx.fillRect(-4.5, -28, 2.6, 10);
      ctx.fillRect(-8.5, -20, 6.6, 2.6);
      ctx.fillRect(-6.6, -18, 2.8, 20);
      ctx.beginPath();
      ctx.moveTo(4.6, -28);
      ctx.quadraticCurveTo(11, -26, 11, -18);
      ctx.quadraticCurveTo(11, -13, 4.6, -13);
      ctx.closePath();
      ctx.fill();
      ctx.fillRect(6, -14, 2.8, 16);
      ctx.restore();
    }

    function drawFrame(t) {
      ctx.clearRect(0, 0, SIZE, SIZE);

      // static orbit rings
      ctx.lineWidth = 1;
      for (var i = 0; i < RINGS.length; i++) {
        ctx.beginPath();
        ctx.arc(CX, CY, MAX_R * RINGS[i], 0, Math.PI * 2);
        ctx.strokeStyle = palette.ring;
        ctx.globalAlpha = 0.5 - i * 0.07;
        ctx.stroke();
      }
      ctx.globalAlpha = 1;

      // expanding ping rings — three, evenly offset in the 3.6s cycle
      if (t !== null) {
        for (var p = 0; p < 3; p++) {
          var phase = ((t / 3600) + p / 3) % 1;
          var r = MAX_R * (0.12 + phase * 0.95);
          ctx.beginPath();
          ctx.arc(CX, CY, r, 0, Math.PI * 2);
          ctx.strokeStyle = palette.accent;
          ctx.globalAlpha = Math.max(0, 0.45 * (1 - phase));
          ctx.lineWidth = 2;
          ctx.stroke();
        }
        ctx.globalAlpha = 1;
      }

      // sweep wedge
      var sweep = t === null ? -Math.PI / 3 : (t / 1000) * 0.7;
      var wedge = 1.05;
      ctx.save();
      ctx.translate(CX, CY);
      ctx.rotate(sweep);
      var sg = ctx.createLinearGradient(0, 0, MAX_R, -MAX_R * 0.35);
      sg.addColorStop(0, hexToRgba(palette.accent, 0.34));
      sg.addColorStop(1, hexToRgba(palette.accent, 0));
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.arc(0, 0, MAX_R, -wedge, 0, false);
      ctx.closePath();
      ctx.fillStyle = sg;
      ctx.fill();
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.lineTo(MAX_R, 0);
      ctx.strokeStyle = hexToRgba(palette.accent, 0.75);
      ctx.lineWidth = 2;
      ctx.stroke();
      ctx.restore();

      // orbiting place dots — brighten briefly after the sweep passes them
      var sweepAngle = norm(sweep);
      for (var d = 0; d < PLACES.length; d++) {
        var pl = PLACES[d];
        var ang = t === null ? pl.a : pl.a + (t / 1000) * pl.speed;
        var px = CX + Math.cos(ang) * MAX_R * pl.r;
        var py = CY + Math.sin(ang) * MAX_R * pl.r;

        var behind = norm(sweepAngle - norm(ang));
        var lit = behind < wedge ? 1 - behind / wedge : 0;
        if (t === null) lit = 0.35;

        ctx.beginPath();
        ctx.arc(px, py, pl.size + 5 * lit, 0, Math.PI * 2);
        ctx.fillStyle = palette.accent;
        ctx.globalAlpha = 0.45 + 0.55 * lit;
        ctx.fill();

        ctx.beginPath();
        ctx.arc(px, py, pl.size + 5 + 9 * lit, 0, Math.PI * 2);
        ctx.strokeStyle = palette.accent;
        ctx.globalAlpha = 0.35 * lit;
        ctx.lineWidth = 2;
        ctx.stroke();
        ctx.globalAlpha = 1;
      }

      // centre disc + pin
      ctx.beginPath();
      ctx.arc(CX, CY, 46, 0, Math.PI * 2);
      ctx.fillStyle = hexToRgba(palette.accent, 0.1);
      ctx.fill();
      drawPin(CX, CY - 4, 0.95);
    }

    function norm(a) {
      var x = a % (Math.PI * 2);
      return x < 0 ? x + Math.PI * 2 : x;
    }

    function hexToRgba(color, alpha) {
      var hex = String(color).trim();
      if (hex.charAt(0) !== '#') return hex; // already rgb()/named — used opaque
      if (hex.length === 4) {
        hex = '#' + hex[1] + hex[1] + hex[2] + hex[2] + hex[3] + hex[3];
      }
      var n = parseInt(hex.slice(1), 16);
      return 'rgba(' + ((n >> 16) & 255) + ',' + ((n >> 8) & 255) + ',' + (n & 255) + ',' + alpha + ')';
    }

    var rafId = null;
    var running = false;

    function loop(now) {
      drawFrame(now);
      rafId = window.requestAnimationFrame(loop);
    }

    function start() {
      if (running) return;
      running = true;
      rafId = window.requestAnimationFrame(loop);
    }

    function stop() {
      running = false;
      if (rafId !== null) window.cancelAnimationFrame(rafId);
      rafId = null;
    }

    function render() {
      resize();
      palette = readPalette();
      if (reduceMotion.matches) {
        stop();
        drawFrame(null); // single static frame: rings, dots, pin, no motion
      } else {
        drawFrame(performance.now());
        start();
      }
    }

    render();

    var resizeTimer;
    window.addEventListener('resize', function () {
      window.clearTimeout(resizeTimer);
      resizeTimer = window.setTimeout(render, 150);
    });

    if (reduceMotion.addEventListener) reduceMotion.addEventListener('change', render);
    else if (reduceMotion.addListener) reduceMotion.addListener(render);

    // Repaint with the new palette when the theme flips.
    new MutationObserver(function () {
      palette = readPalette();
      if (reduceMotion.matches) drawFrame(null);
    }).observe(root, { attributes: true, attributeFilter: ['data-theme'] });

    // Do not burn frames while the tab or the hero is out of sight.
    document.addEventListener('visibilitychange', function () {
      if (reduceMotion.matches) return;
      if (document.hidden) stop();
      else start();
    });

    if ('IntersectionObserver' in window) {
      new IntersectionObserver(function (entries) {
        if (reduceMotion.matches) return;
        if (entries[0].isIntersecting) start();
        else stop();
      }, { threshold: 0 }).observe(canvas);
    }
  }

  /* ---------------------------------------------------------- scroll reveal */

  var revealables = document.querySelectorAll('.reveal');
  if (revealables.length && 'IntersectionObserver' in window && !reduceMotion.matches) {
    document.body.classList.add('reveal-ready');
    var io = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            io.unobserve(entry.target);
          }
        });
      },
      { rootMargin: '0px 0px -8% 0px', threshold: 0.08 }
    );
    Array.prototype.forEach.call(revealables, function (el) {
      io.observe(el);
    });
  }
})();
