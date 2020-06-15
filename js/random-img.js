// Random image generation

window.onload = choosePic;

var myPix = new Array(
	"img/avatar.svg", 
	"img/circos.svg", 
	"img/chaos_fractals.png",
	"img/mandelbrot_set_7000_com.png"
)

function choosePic() {
	var randomNum = Math.floor((Math.random() * myPix.length));
	var imgName = myPix[randomNum]
	document.getElementById("myPicture").src = imgName;
}
