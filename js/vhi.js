var sat = 1.0;
var ds = -0.04;
var hue = 0;
var dh = 5;
var foot = null;
var cursor = '\u2589';

function xionType(e,a) {
  var c = a.shift();
  var h = e.attr('href');
  e.attr('href', h+c);
  e.html(e.html().slice(0,-1)); // whack the cursor off
  e.append(c);
  if (a.length > 0) {
    e.append(cursor);
    var d = parseInt(Math.random()*30);
    setTimeout(xionType, 10, e,a);
  } else {
    var span = $('<span id="cursor">');
    span.html(cursor);
    e.append(span);
  }
}

$(document).ready(function() {
  foot = $('#footer');
  
  setInterval(function() {
    var hue_string = hue + "deg";
    var val = "saturate( " + sat + ") hue-rotate( " + hue_string + ")";
    foot.css('-webkit-filter', val);
    foot.css('-moz-filter', val);

    hue += dh;
    if(hue <= 0 || hue >= 360)
      dh *= -1;

    sat += ds;
    if(sat <= 0.1 || sat >= 1.0)
      ds *= -1;
  }, 80);

  $('#contactlink').bind('click', function(evt) {
    evt.preventDefault();
    $(this).unbind();
    var c = $('#contact');
    c.html('');
    var a = $('<a id="maillink" target="_blank" href="mailto:">');
    c.append(a);
    var addr = ['j','o','s','e','p','h','@','v','e','l','o','t','r','o','n','h','e','a','v','y','i','n','d','u','s','t','r','i','e','s','.','c','o','m'];
    xionType(a,addr);
  });
});

