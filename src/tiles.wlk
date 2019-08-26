import items.*
import overcooked.*
import wollok.game.*

class Deliver inherits Visual {

	override method image() = "assets/exit.png"

	override method isPickable() = false

	override method canContain(item) = item.isPlate()

	override method droppedOnTop(item) {
		if (item.isPlate()) self.deliver(item)
	}

	method deliver(plate) {
		// todo: check recipe
		console.println("Delivered")
		game.removeVisual(plate)
	}

}

