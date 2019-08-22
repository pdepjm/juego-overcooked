import wollok.game.*
import food.*

class Visual {

	var position

	method position() {
		return position
	}

	method position(newPosition) {
		position = newPosition
	}

	method isPickable()

	method image()

	method move(direction, n) {
		position = direction.move(position, n)
	}

}

//Jugadores
class Player inherits Visual {

	var facingDirection = up
	var carriedItem = noItem

	override method isPickable() = false

	override method image() = "assets/cook_" + facingDirection.text() + ".png"

	method faceTowards(direction) {
		facingDirection = direction
	}

	override method move(direction, n) {
		super(direction, n)
		self.faceTowards(direction)
		carriedItem.move(direction, n)
	}
	method canPickup(item){
		return item == self.getCloseItem()
	}
	method getCloseItem() {
		var frontPosition = facingDirection.move(position, 1)
		var elementsInFront = frontPosition.allElements()
		
		return elementsInFront.findOrElse({ item =>	item.isPickable()},	{ return noItem	}
		)
	}
	method pickup(){
		carriedItem=self.getCloseItem()
	}

}

object player1 inherits Player {

}

//Direcciones
class Direction {

	method text()

	method move(position, n)

}

object up inherits Direction {

	override method text() = "up"

	override method move(position, n) = position.up(n)

}

object right inherits Direction {

	override method text() = "right"

	override method move(position, n) = position.right(n)

}

object down inherits Direction {

	override method text() = "down"

	override method move(position, n) = position.down(n)

}

object left inherits Direction {

	override method text() = "left"

	override method move(position, n) = position.left(n)

}

