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
	
	method canContain() = true

}

//Jugadores
class Player inherits Visual {

	var property facingDirection = up
	var carriedItem = noItem

	override method isPickable() = false

	override method image() = "assets/cook_" + facingDirection.text() + ".png"

	method faceTowards(direction) {
		facingDirection = direction
	}

	override method move(direction, n) {
		super(direction, n)
		self.faceTowards(direction)
		carriedItem.position(direction.move(position,1))
	}
	method canPickup(item){
		return item == self.getCloseItem()
	}
	method getCloseItem() {		
		return self.frontItems().findOrElse({ item =>	item.isPickable()},	{ return noItem	}
		)
	}
	
	method pickup(){
		carriedItem = self.getCloseItem()
	}
	
	method frontItems() = facingDirection.move(position, 1).allElements()
	
	method drop(){
		
		if(self.canDropItem())
		{
			carriedItem = noItem//todo:plato
		}
	}
	
	method canDropItem(){
		console.println(carriedItem.toString())
		console.println(game.colliders(carriedItem).toString())
		return game.colliders(carriedItem).all({element => element.canContain()})
	}
	
	method action(){
		carriedItem.action(self)
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

