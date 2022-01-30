// Random image generation

window.onload = choosePic;

var myPix = new Array(
	"img/front/avatar.svg",
	"img/front/cellular_automata_101.png",
	"img/front/chaos_game_fractal_01.png",
	"img/front/clifford_attractor.png",
	"img/front/mandelbrot_set_7000_comp.png"
)

function choosePic() {
	var randomNum = Math.floor((Math.random() * myPix.length));
	var imgName = myPix[randomNum]
	document.getElementById("myPicture").src = imgName;
}
