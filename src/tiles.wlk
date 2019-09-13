import items.*
import overcooked.*
import wollok.game.*
import statusBar.*

class Tile inherits Visual {

	override method isPickable() = false

	override method walkable() = false

}

class DeliverSpot inherits Tile {

	override method image() = "exit.png"

	override method canContain(item) = item.canDeliver()

	override method droppedOnTop(item) {
		self.deliver(item)
	}

	method deliver(plate) {
		var recipe = status.recipes().findOrElse({ recipe => recipe.plateMeetsRequierements(plate) }, { 
			game.error("Can't deliver!!")
			return null //break
		})
		status.recipeDelivered(recipe)
//		console.println("Delivered " + plate)
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

//cooking tiles
class ChoppingDesk inherits Tile {

	var placedIngredient = noItem
	var cuttingProgress = 0

	override method image() = "cuttingDesk.png"

	override method do(somePlayer) {
		if (placedIngredient != noItem) self.chop()
	}

	method chop() {
		game.sound("sounds/chop.mp3")
		cuttingProgress += 15.randomUpTo(26).truncate(0) //so that the player doesnt know how many chops it takes
		if (cuttingProgress >= 100) {//No se si el jugador deberia tener responsabilidad de esto
			placedIngredient.cut()
			game.addVisual(placedIngredient)	
			cuttingProgress = 0		
			placedIngredient=noItem		
		}
	}

	override method canContain(item) = item.isFood() && placedIngredient == noItem

	override method droppedOnTop(item) {
			placedIngredient = item
			game.removeVisual(placedIngredient)
	}

}

