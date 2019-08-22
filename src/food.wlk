import wollok.game.*
import overcooked.*


class Item inherits Visual{
	constructor(initialPosition){
		position=initialPosition
		game.addVisual(self)
	}
	
	method action(player){
		player.drop()
	}
	
	override method isPickable() = true
	
}

//class NoItem inherits Item{
//	constructor(newPosition){
//		position=newPosition
//		game.addVisual(self)
//	}
//	override method d(){
//		game.removeVisual(self)
//	}
//	override method image()= "holas.png"//"assets/invisible.png"
//}

object noItem {
	method move(no,importa){}
	method isPickable()=true
	
	method action(player){
		player.pickup()
	}
	method position(noimporta){}
}

class Meat inherits Item{	
	override method image()="assets/meat.png"
}
