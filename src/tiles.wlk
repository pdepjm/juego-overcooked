import items.*
import overcooked.*
import wollok.game.*


class Deliver inherits Visual{
	override method image()="assets/exit.png"
	override method isPickable()=false
	override method canContain(item)= item.isPlate()
	
}
