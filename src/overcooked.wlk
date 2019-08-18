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

	method image()

	method move(direction, n) {
		position = direction.move(position, n)
	}

}

//Jugadores
class Player inherits Visual {

	var carriedObject = null
	var facingDirection = up

	override method image() = "assets/cook_" + facingDirection.text() + ".png"

	method faceTowards(direction) {
		facingDirection = direction
	}

	method pickup(someObject) {
		if (position.distance(someObject.position()) < 1) carriedObject = someObject else game.say(self, "I can't pickup any object!!")
	}

	override method move(direction, n) {
		self.faceTowards(direction)
		super(direction, n)
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

