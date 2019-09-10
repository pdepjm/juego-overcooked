import wollok.game.*
import items.*

object gameManager {

	// ToDo: lista jugadores
	var property height = 13
	var property width = 20

	method positionIsBetweenBounds(aPosition) {
		return aPosition.x() >= 0 && aPosition.x() < width && aPosition.y() >= 0 && aPosition.y() < height
	}

	method upperRightCorner() {
		return game.at(width - 1, height - 1)
	}
	
	method centerY()= height/2 

	method centerX()= width/2 
}

class Visual {

	var position = game.origin() // there are subclasses that don't use this atribute

	method position() = position

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

	method do(somePlayer) {
	}

	method interact(somePlayer) {
	}

}

//Jugadores
class Player inherits Visual {

	var property character
	var property facingDirection = up
	var property carriedItem = noItem

	// basic behaviour
	override method isPickable() = false

	override method image() = character + "_" + facingDirection.text() + ".png"

	override method canContain(item) = false

	method isPicking(item) {
		return carriedItem == item
	}

	// movement
	method move(direction) {
		var nextPosition = direction.move(position, 1) // position=original position
		if (self.positionIsWalkable(nextPosition)) {
			self.move(direction, 1)
		}
		self.faceTowards(direction)
		carriedItem.position(direction.move(position, 1)) // position=next position OR original position
		self.refresh()
	}

	method moveN(direction, n) {
		n.times({ x => self.move(direction)})
	}

	method faceTowards(direction) {
		facingDirection = direction
	}

	method refresh() {
		game.removeVisual(self)
		game.addVisual(self)
	}

	// pickup/drop
	method pickup(item) {
		item.player(self)
		carriedItem = item
	}

	method getFrontPickableItem() {
		return self.frontElements().findOrElse({ item => item.isPickable() }, { return noItem })
	}

	method frontElements() = facingDirection.move(position, 1).allElements()//.copyWithout(carriedItem)

	method action() {
		carriedItem.action(self)		
	}

	method drop() {
		if (self.canDropItem()) {			
			carriedItem.player(null)
			self.frontElements().forEach({ element => element.droppedOnTop(carriedItem)})
			carriedItem = noItem
		}
	}

	method canDropItem() {
		return game.colliders(carriedItem).all({ element => element.canContain(carriedItem) })
	}

	// interaction
	method interactWithFront() {
		if(self.hasSomethingInFront()) self.frontElements().last().interact(self)//forEach({ x => x.interact(self)})
		
	}
	
	method hasSomethingInFront()=not self.frontElements().isEmpty()

	// do
	method do() {
		var frontElements = self.frontElements()
		if (self.hasSomethingInFront()) self.frontElements().last().do(self) //maybe this should be a forEach or first()
	}

	// metodos que deberian ser de posicion pero no se como hacerlo
	method positionIsWalkable(aPosition) {
		return aPosition.allElements().all({ element => element.walkable() }) && gameManager.positionIsBetweenBounds(aPosition)
	}

}

//object player1 inherits Player {
//	
//}
//
//object player2 inherits Player {
//
//}
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

