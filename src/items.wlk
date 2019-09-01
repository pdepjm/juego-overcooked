import wollok.game.*
import overcooked.*

class Item inherits Visual {

	var property player = null

	method action(somePlayer) {
		somePlayer.drop()
	}

	override method isPickable() {
		return player == null
	}

	method isFood() = false

	override method interact(somePlayer) {
		if (self.isPickable()) somePlayer.pickup(self)
	}

	override method canContain(item) = false

}

object noItem {

	var property player = null

	method isPlate() = false

	method move(no, importa) {
	}

	method isPickable() = true

	method action(somePlayer) {
		somePlayer.interactWithFront()
	}

	method position(noimporta) {
	}

	method canContain(item) = true

	method isFood() = false

}

class Ingredient inherits Item {

	var name

	method clone() = new Ingredient(name = name, position = position)

	override method isFood() = true

	override method image() = name + ".png"

	method spawnerImage() = name + "-spawner.png"

}

//var meat = new Ingredient(name="meat")
//
//var lettuce = new Ingredient (name="lettuce")
//
//var tomato =  new Ingredient (name="tomato")
class Plate inherits Item {

	var ingredients = []

	override method isPlate() = true

	override method canContain(item) = item.isPlate().negate()

	override method image() = "plate.png"

	method addIngredient(food) {
		ingredients.add(food)
		game.removeVisual(food)
		console.println("Ingredient added, ingredients:" + ingredients)
	}

	override method droppedOnTop(item) {
		if (item.isFood()) self.serve(item)
	}

	method serve(item) {
		self.addIngredient(item)
	}

}

