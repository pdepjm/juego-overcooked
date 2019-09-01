import wollok.game.*
import overcooked.*
import tiles.*
import items.*

object status inherits Visual {

	var recipes = []
	var score = 0
	var width = 3

	override method isPickable() = false

	override method image() = "status-bar.jpg"

	override method position() = game.at(gameManager.width(), 0)

	method width() = width

}

class Recipe{
	var ingredients	
	
} 