import overcooked.*
import wollok.game.*

class Food inherits Visual{
	constructor(){
		position=game.at(0.randomUpTo(game.height()).roundUp(), 3)
		game.addVisual(self)
	}
	
}

class Meat inherits Food{	
	override method image()="assets/meat.png"
}