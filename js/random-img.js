// Random image genration

window.onload = choosePic;

var myPix = new
Array("./img/avatar.png", "./img/circos.png")

function choosePic() {
	randomNum = Math.floor((Math.random() * myPix.length));
	document.getElementById("myPicture").src = myPix[randomNum];
}