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

	override method canContain(item) = item.isPlate()

	override method droppedOnTop(item) {
		if (item.isPlate()) self.deliver(item)
	}

	method deliver(plate) {
		var recipe = status.recipes().findOrElse({ recipe => recipe.plateMeetsRequierements(plate) }, { 
			game.error("Can't deliver!!")
			return null //break
		})
		status.recipeDelivered(recipe)
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

//cooking tiles
class CuttingDesk inherits Tile {

	var placedIngredient = noItem
	var cuttingProgress = 0

	override method image() = "todo.png"

	override method do(somePlayer) {
		if (placedIngredient != noItem) game.onTick(500, "cutting", { self.cut() })
	}

	method cut() {
		game.sound("sounds/chop.mp3")
		cuttingProgress += 25
		if (cuttingProgress >= 100) {//No se si el jugador deberia tener responsabilidad de esto
			game.removeTickEvent("cutting")
			placedIngredient.cut()
			game.addVisual(placedIngredient)	
			cuttingProgress = 0		
		}
	}

	override method canContain(item) = true

	override method droppedOnTop(item) {
		if (item.isFood()) {
			placedIngredient = item
			game.removeVisual(placedIngredient)
		}
	}

	override method interact(somePlayer) {
		if(cuttingProgress>0 && cuttingProgress<99){
			game.say(self,"Wait!!")
		}
		else {
			somePlayer.pickup(placedIngredient)
			placedIngredient=noItem			
		}
	}

}

