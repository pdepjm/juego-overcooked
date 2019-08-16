import wollok.game.*

class Visual{
	var position
	method position(){
		return position
	}
	method position(newPosition){
		position=newPosition
	}
	method image()
	method move(newPosition){
		self.position(newPosition)
	}
}

class Player inherits Visual{
	var carriedObject
	var facing="up"
	
	override method image() = "assets/cook_"+facing+".png"
	
	method faceTowards(direction){
		facing=direction
	}
		
	method pickup(someObject){
		if(position.distance(someObject.position()) < 1) carriedObject = someObject
		else game.say(self,"I can't pickup any object!!")
	}
	
}

object player1 inherits Player{

}




class Food inherits Visual{
	constructor(){
		position=game.at(0.randomUpTo(game.height()).roundUp(), 3)
		game.addVisual(self)
	}
	
}

class Meat inherits Food{
	
	override method image()="assets/meat.png"
	
}