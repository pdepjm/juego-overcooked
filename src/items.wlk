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
	
	method isFood()=false
	
	override method canContain(item) = false
}

class Food inherits Item{
	override method isFood()=true
}

object noItem {
	method isPlate()=false
	method move(no,importa){}
	method isPickable()=true
	method action(player){
		player.pickup()
	}
	method position(noimporta){}
	method canContain(item) = true
	method isFood()=false
}

class Meat inherits Food{	
	override method image()="meat.png"
}

class Plate inherits Item{
	var ingredients = []
	
	override method isPlate()=true
	override method canContain(item) = item.isPlate().negate()
	override method image() = "plate.png"
	
	
	
	method addIngredient(food){
		ingredients.add(food)
		game.removeVisual(food)
		console.println("Ingredient added, ingredients:"+ingredients.toString())
	}	
	override method droppedOnTop(item){
		if(item.isFood()) self.serve(item)
	}
	method serve(item) {
		self.addIngredient(item)
	}
}