var n = 100;
var v_limit = 0.301;
var comScale = .006;
var sepScale = .0085;
var alignScale = .0015;

function COM(t) {
    var coms = new THREE.Vector3(0,0,0); //t.cube.position;
    var count = 0;
    for (var i = 0; i < n; i = i+1) {
        var other = boids[i];
        if (other === t) 
            continue;
        coms.add(other.cube.position);
        count += 1;
    }
    coms.divideScalar(count);
    return coms;
}
function separation(t) {
    var acc = new THREE.Vector3(0,0,0); //t.position;
    for (var i = 0; i < n; i++) {
        var other = boids[i];
        if (other === t) 
            continue;

        var diff = new THREE.Vector3(0,0,0);
        diff.subVectors(t.cube.position, other.cube.position);
        var mag = diff.length();
        if (mag < 5) {
          diff.setLength(1/(mag*mag));
          acc.add(diff);
        }
    }
    return acc;
}

function alignment(t) {
    var acc = new THREE.Vector3(0,0,0);
    var nearest = 999999;
    
    for (var i = 0; i < n; i++) {
        var other = boids[i];
        if (other === t) {
            continue;
        }
        var length = t.cube.position.distanceTo(other.cube.position);
        if (length < nearest) {
            nearest = length;
            acc = other.velocity;
            //var velocity = other.velocity.clone();
            //velocity.setLength(1/length);
            //acc.add(velocity);
            //exit on first superfriend
            //return acc;
        }
    }
    var velocity = acc.clone();
    velocity.setLength(1/(nearest*nearest));
    return velocity;
}

var Boid = function() {
    this.velocity = new THREE.Vector3(0,0,0);
    
    this.update = function() {
      this.velocity.clampScalar(-v_limit,v_limit);
      this.cube.position.add(this.velocity);
      var com = COM(this);
        
        com.sub(this.cube.position);
        com.clampScalar(-comScale, comScale);
        
        var sep = separation(this);
        sep.clampScalar(-sepScale,sepScale); 

        var align = alignment(this);
        align.clampScalar(-alignScale, alignScale);

        this.velocity.add(com);
        this.velocity.add(sep);
        this.velocity.add(align);
       
        //var rot = new THREE.Euler( 0, 0, 0);
        //rot.setFromVector3(this.velocity);
        var future = new THREE.Vector3(0,0,0);
        future.addVectors(this.cube.position, this.velocity);
        this.cube.lookAt(future); //.applyEuler(rot);
 
        if (this.cube.position.length() > 50) {
            //this.cube.position.set(0,0,0); // = new THREE.Vector3(0,0,0);
            var center = new THREE.Vector3(0,0,0);
            center.sub(this.cube.position);
            center.setLength(this.velocity.length());
            this.velocity = center;
            this.cube.material.color.r = 1;
            this.cube.material.color.g = 1;
            this.cube.material.color.b = 1;
        }   
    }
}

var boids = [];

function setup_boids(scene)
{
    for (var i = 0; i < n; i = i+1) {

      boids[i] = new Boid();

      var geometry = new THREE.BoxGeometry( 1, 1, 1 );
      var material = new THREE.MeshPhongMaterial( { color: 0x00ff00,specular: 0x009900, shininess: 30, shading: THREE.FlatShading  } );
      var cube = new THREE.Mesh( geometry, material );
      material.color.r = i/n;
      material.color.g = 1-i/n;
      material.color.b = Math.random();
      boids[i].cube = cube;
      scene.add(cube);      boids[i].cube.position.x = 100 - 50*Math.random();

      boids[i].cube.position.x = 5 - 10*Math.random();
      boids[i].cube.position.y = 5 - 10*Math.random();
      boids[i].cube.position.z = 5 - 10*Math.random();
    }
}

function updateBoids(){
    for (var i = 0; i < n; i++) {
        var b = boids[i];
        b.update();
    }
}

function init() {
    var scene = new THREE.Scene();
    //drawAxes(scene);
    var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );

    var renderer = new THREE.WebGLRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );
    document.body.appendChild( renderer.domElement );
    var controls = new THREE.TrackballControls( camera, renderer.domElement );

    var ambientLight = new THREE.AmbientLight( 0x000000 );
    scene.add( ambientLight );

    var light = new THREE.AmbientLight( 0x404040 ); // soft white light
    scene.add( light );

    var axisHelper = new THREE.AxisHelper( 5 );
    scene.add( axisHelper );

    var lights = [];
    lights[0] = new THREE.PointLight( 0xffffff, 1, 0 );
    lights[1] = new THREE.PointLight( 0xffffff, 1, 0 );
    lights[2] = new THREE.PointLight( 0xffffff, 1, 0 );
    
    lights[0].position.set( 0, 200, 0 );
    lights[1].position.set( 100, 200, 100 );
    lights[2].position.set( -100, -200, -100 );

    scene.add( lights[0] );
    scene.add( lights[1] );
    scene.add( lights[2] );

    setup_boids(scene);
    camera.position.x = 20;
    camera.position.y = 40;
    camera.position.z = 1;
    function render() {
        updateBoids();
        controls.update();
        renderer.render( scene, camera );
        requestAnimationFrame( render );
    }
    render();
};
