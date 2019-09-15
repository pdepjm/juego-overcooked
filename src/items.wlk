import wollok.game.*
import overcooked.*

class Item inherits Visual {


	var property owner= null

	override method position(){
			if(owner != null)return owner.itemPosition()
			else return position
	}

	method action(somePlayer) {
		somePlayer.drop()
	}
	
	override method isPickable() {
		return owner == null
	}

	method canDeliver()

	method isFood() = false

	override method interact(somePlayer) {
		if (self.isPickable()) somePlayer.pickup(self)
	}

	override method canContain(item) = false
	
	override method walkable()=true
	
	method spawnerImage()

	override method canInteract()=self.isPickable()
}

object noItem {

	var property owner = null

	method cut() {
	}
	
	method name()="noItem"

	method move(no, importa) {
	}

	method isPickable() = true

	method action(somePlayer) {
		somePlayer.interactWithFront()
	}
	
	method canInteract()=false
	
	method canDeliver()=false

	method position(noimporta) {
	}

	method canContain(item) = true

	method isFood() = false

}

class Ingredient inherits Item {

	var property name
	var property state = fresh

	method clone() = new Ingredient(name = name, owner = owner, position = position, state = state)

	override method canDeliver()=false

	override method isFood() = true

	override method image() = name + ".png"

	override method equals(otherIngredient) {
		return name == otherIngredient.name() && state == otherIngredient.state()
	}
	
	override method ==(otherIngredient){
		return self.equals(otherIngredient)
	}

	method choppable()=state.choppable()

	override method spawnerImage() = name + "-spawner.png"

	method chop() {
		state = chopped
	}
}
//State objects
object fresh{
	method name()="new"
	method choppable() = true
}

object chopped{
	method name()="chopped"
	method choppable()=false
}

//var meat = new Ingredient(name="meat")
//
//var lettuce = new Ingredient (name="lettuce")
//
//var tomato =  new Ingredient (name="tomato")
class Plate inherits Item {

	var property ingredients = []

	override method canContain(item) = item.isFood()

	override method image() = "plate.png"

	method addIngredient(food) {
		ingredients.add(food)
		food.owner(self)
//		console.println("Ingredient added, ingredients:" + ingredients)
	}

	override method droppedOnTop(item) {
		if (item.isFood()) self.addIngredient(item)
	}	
	override method canDeliver()= true
	
	method clone() = new Plate(ingredients=ingredients,position=position)

	override method spawnerImage() = "plate-spawner.png"

	method itemPosition()=self.position()
}

