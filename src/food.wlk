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
		
	override method isPickable() {
		return player1.isPicking(self).negate() && player2.isPicking(self).negate() //TUUUURBIO
	}
	
	override method canContain() = false
}

object noItem {
	method move(no,importa){}
	method isPickable()=true
	
	method action(player){
		player.pickup()
	}
	method position(noimporta){}
	
	method canContain() = true
}

class Meat inherits Item{	
	override method image()="assets/meat.png"
}
