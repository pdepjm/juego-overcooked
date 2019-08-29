import wollok.game.*
import overcooked.*


class Item inherits Visual{
	var property player = null
	constructor(initialPosition){
		position=initialPosition
		game.addVisual(self)
	}
	
	method action(somePlayer){
		somePlayer.drop()
	}
		
	override method isPickable() {
		return player == null
	}
	
	method isFood()=false
	
	override method interact(somePlayer){
		somePlayer.pickup(self)
	}
	
	override method canContain(item) = false
}

class Food inherits Item{
	override method isFood()=true
}

object noItem {
	var property player = null
	method isPlate()=false
	method move(no,importa){}
	method isPickable()=true
	method action(somePlayer){
		somePlayer.interactWithFront()
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