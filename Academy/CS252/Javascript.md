**Tags:** #javascript #json 

```javascript

var x=42, y = 7;
function add (a,b){
	return a+b;
}
var y = add(9,10)
console.log(y)

function applyToX(f){
	f(x)
}
applyToX(console.log)
var getNextInt = function (){
	var nextInt = 0;
	return function (){
	return nextInt++
	}
}();
```

# Json

```json
var complex={real:3, imaginary:1};
console.log(complex.rea)
console.log(complex['imaginary'])

var Dog-prototype = {
	speak: function (){ console.log('bark');}
}
var rex {name: 'Rex', __proto__: Dog-prototype};
rex.speak();
rex.favoriteToy = "squeaky ball";
rex.speak = function (){ console.log('grr');}
rex.speak(); // grr

var fifi = {name: 'fifi', bread:'poodle', __proto__: Dog_prototype}
fif.speak();//bark
delete rex.speak;
delete rex.__proto__.speak;
fifi.speak()//Error
```

```json
function Cat(name, breed){
	this.name = name;
	this.breed = breed;
	this.speak = function(){console.log("meow");};
}

Cat.prototpye.makeAngryNoise = function(){console.log('hiss');}
Cat.prototpye.speak = function(){ console.log('I love lasanga');}//generally better
var garfield = Cat('Garfield', 'Orange Tabby');
garfield.speak();//meow
garfield.makeAngryNoise()//hiss

```