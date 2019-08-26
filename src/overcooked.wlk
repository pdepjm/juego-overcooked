import wollok.game.*
import items.*

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

	method walkable() = true

	method move(direction, n) {
		position = direction.move(position, n)
	}

	method canContain(item) = true

	method isPlate() = false

	method droppedOnTop(item) {
	}

}

//Jugadores
class Player inherits Visual {

	var property facingDirection = up
	var carriedItem = noItem

	// basic behaviour
	override method isPickable() = false

	override method image() = "assets/cook_" + facingDirection.text() + ".png"

	override method canContain(item) = false

	method isPicking(item) {
		return carriedItem == item
	}

	// movement
	method move(direction){
		
		var nextPosition = direction.move(position, 1)//position=original position
		if (self.positionIsWalkable(nextPosition)) {
			self.move(direction,1)
		}
		self.faceTowards(direction)
		carriedItem.position(direction.move(position, 1))//position=next position OR original position
	}
	
	method moveN(direction,n){
		
		n.times({x=>self.move(direction)})
	}

	method faceTowards(direction) {
		facingDirection = direction
	}

	method positionIsWalkable(aPosition) {
		return aPosition.allElements().all({ element => element.walkable() })
	}

	// pickup/drop
	method pickup() {
		carriedItem = self.getFrontPickableItem()
	}

	method getFrontPickableItem() {
		return self.frontItems().findOrElse({ item => item.isPickable() }, { return noItem })
	}

	method canPickup(item) {
		return item == self.getFrontPickableItem()
	}

	method frontItems() = facingDirection.move(position, 1).allElements()

	method action() {
		carriedItem.action(self)
	}

	method drop() {
		if (self.canDropItem()) {
			self.frontItems().forEach({ element => element.droppedOnTop(carriedItem)})
			carriedItem = noItem
		}
	}

	method canDropItem() {
		return game.colliders(carriedItem).all({ element => element.canContain(carriedItem) })
	}

}

object player1 inherits Player {

}

object player2 inherits Player {

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

