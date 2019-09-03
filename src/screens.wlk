import wollok.game.*
import overcooked.*
import items.*
import tiles.*
import statusBar.*

object screenManager {

	var actualScreen = menu

	method switchScreen(newScreen) {
		game.clear()
		actualScreen = newScreen
		self.startScreen()
	}

	method startScreen() {
		game.boardGround(actualScreen.background()) // NO FUNCIONA
		actualScreen.show()
		actualScreen.setInputs()
	}

}

class LevelButton {

	var level
	var property selected = false

	method level() = level

	method image() = "LEVEL" + level + self.selectionText() + ".png"

	method selectionText() = if (selected) "H" else ""

	method compareLevel(otherLevel) = level == otherLevel

	method unselect() {
		selected = false
	}

	method select() {
		selected = true
	}

}

class Screen {

	method show()

	method setInputs()

	method background()

}

class Image {

	var property name

	method image() = name + ".png"

}

object menu inherits Screen {

	var character1Index = 0
	var character2Index = 1
	var character1 = new Image(name = "rasta")
	var character2 = new Image(name = "alf")
	var selectedButtonNumber = 0
	var property buttons = [ new LevelButton(level=1), new LevelButton(level=2) ]

	override method background() = "tiledWood.jpg"

	method selectedButton() = self.buttons().get(selectedButtonNumber)

	override method setInputs() {
		keyboard.enter().onPressDo{ var selectedLevelNumber = self.selectedButton().level() - 1
			screenManager.switchScreen(self.levels().get(selectedLevelNumber)) // levels list must be in order
		}
			// level
		keyboard.down().onPressDo{ self.selectChange(-1)}
		keyboard.s().onPressDo{ self.selectChange(-1)}
		keyboard.up().onPressDo{ self.selectChange(1)}
		keyboard.w().onPressDo{ self.selectChange(1)}
			// character
		keyboard.a().onPressDo{ self.character1SelectChange(-1)}
		keyboard.d().onPressDo{ self.character1SelectChange(1)}
		keyboard.left().onPressDo{ self.character2SelectChange(-1)}
		keyboard.right().onPressDo{ self.character2SelectChange(1)}
	}

	method character1SelectChange(delta) {
		character1Index = self.limitBetweenListSize(self.charactersNames(), character1Index + delta)
		character1.name(self.charactersNames().get(character1Index))
	}

	method character2SelectChange(delta) {
		character2Index = self.limitBetweenListSize(self.charactersNames(), character2Index + delta)
		character2.name(self.charactersNames().get(character2Index))
	}

	method limitBetweenListSize(list, number) {
		return number.limitBetween(0, list.size() - 1)
	}

	method charactersNames() = [ "rasta", "alf" ]

	method selectChange(delta) {
		self.selectButton(selectedButtonNumber + delta)
	}

	method selectButton(newSelection) {
		var oldButton = self.buttons().get(selectedButtonNumber)
		oldButton.unselect()
		selectedButtonNumber = self.limitBetweenListSize(self.buttons(), newSelection)
		var button = self.buttons().get(selectedButtonNumber)
		button.select()
	}

	method levels() = [ // parallel list with buttons (TODO: generate buttons list from this one)
	new Level(layout="TODO",posibleRecipes=[],ingredients=[],character1=character1.name(),character2=character2.name()), new Level(layout="TODO",posibleRecipes=[],ingredients=[],character1=character1.name(),character2=character2.name()) ]

	override method show() {
		game.addVisualIn(new Image(name = "title"), game.center().left(3).up(4))
		var nextPosition = game.center().left(3).down(7)
		self.buttons().forEach({ button =>
			game.addVisualIn(button, nextPosition)
			nextPosition = nextPosition.up(3)
		})
		self.showPickPlayer(game.at(1, game.height() / 2), character1, "pick-player1")
		self.showPickPlayer(game.at(game.width() - 8, game.height() / 2), character2, "pick-player2")
	}

	method showPickPlayer(characterPosition, character, pickPlayerImageName) {
		game.addVisualIn(character, characterPosition)
		game.addVisualIn(new Image(name = pickPlayerImageName), characterPosition.down(2))
	}

}

class Level inherits Screen {

	var layout
	var posibleRecipes
	var ingredients
	var character1
	var character2
	var player1 = new Player()
	var player2 = new Player()

	override method show() {
		player1.character(character1)
		player2.character(character2)
		console.println(player1.image())
			// TODO: parseo layout
		player1.position(game.origin())
		player2.position(game.at(10, 10))
		game.addVisual(status)
		game.addVisual(new DeliverSpot(position = game.at(gameManager.width() - 1, 10)))
		game.addVisual(new CuttingDesk(position = game.at(gameManager.width() - 2, 0)))
		game.addVisual(new Spawner(toSpawnIngredient = new Ingredient(name = "meat", position = game.at(0, 5), state = "new")))
		game.addVisual(new Spawner(toSpawnIngredient = new Ingredient(name = "tomato", position = game.at(0, 6), state = "new")))
		game.addVisual(new Spawner(toSpawnIngredient = new Ingredient(name = "lettuce", position = game.at(0, 7), state = "new")))
			// temporal
		gameManager.height().times({ index => game.addVisual(new Desk(position = game.at(9, index - 1)))})
			// cosas
		var cosas = [ new Plate(position=game.at(9,8)), new Plate(position=game.at(9,5)), new Plate(position=game.at(9,1)) // new Ingredient(name="meat",position=game.at(9,9)),
//	new Ingredient(name="meat",position=game.at(15,2)),
//	new Ingredient(name="lettuce",position=game.at(10,10)),
//	new Ingredient(name="tomato",position=game.at(10,11))
		]
		game.addVisual(player1)
		game.addVisual(player2)
	}

//	method initialize(character1, character2) {
//		// PLAYER		
//		player1 = new Player(position = gameManager.upperRightCorner(), character = "rasta")
//		player2 = new Player(position = game.origin(), character = "alf")
//	}
	override method background() = "tiledWood.jpg"

	override method setInputs() {
		// PLAYER 1
		keyboard.up().onPressDo{ player1.move(up)}
		keyboard.left().onPressDo{ player1.move(left)}
		keyboard.down().onPressDo{ player1.move(down)}
		keyboard.right().onPressDo{ player1.move(right)}
		keyboard.m().onPressDo{ player1.action()}
		keyboard.n().onPressDo{ player1.do()}
			// PLAYER 2
		keyboard.w().onPressDo{ player2.move(up)}
		keyboard.a().onPressDo{ player2.move(left)}
		keyboard.s().onPressDo{ player2.move(down)}
		keyboard.d().onPressDo{ player2.move(right)}
		keyboard.shift().onPressDo{ player2.action()}
		keyboard.alt().onPressDo{ player2.do()}
	}

}

