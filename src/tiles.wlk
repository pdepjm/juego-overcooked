import items.*
import overcooked.*
import wollok.game.*

class Tile inherits Visual {

	override method isPickable() = false

	override method walkable() = false

}

class DeliverSpot inherits Tile {

	override method image() = "exit.png"

	override method canContain(item) = item.isPlate()

	override method droppedOnTop(item) {
		if (item.isPlate()) self.deliver(item)
	}

	method deliver(plate) {
		// todo: check recipe
		console.println("Delivered " + plate)
		game.removeVisual(plate)
	}

}

class Desk inherits Tile {

	override method image() = "desk.png"

	override method canContain(item) = true

	override method droppedOnTop(item) {
	}

}

class Spawner inherits Tile {

	var toSpawnIngredient

	override method position() = toSpawnIngredient.position()

	override method canContain(item) = false

	override method interact(somePlayer) {
		var clonedIngredient = toSpawnIngredient.clone()
//		clonedIngridient.position(self.position())
		game.addVisual(clonedIngredient)
		somePlayer.pickup(clonedIngredient)
	}

	override method image() = toSpawnIngredient.spawnerImage()

}

