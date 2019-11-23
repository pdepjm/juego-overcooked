import wollok.game.*
import overcooked.*
import items.*
import tiles.*
import statusBar.*
import timer.*

object screenManager {

	var property actualScreen = menu

	method switchScreen(newScreen) {
		game.clear()
		actualScreen = newScreen
		self.startScreen()
	}

	method startScreen() {
		background.image(actualScreen.background())
		game.addVisual(background)
		game.schedule(10, { actualScreen.setInputs()}) // the schedule stops the next screen from the detecting the last screen's keyPress	
		actualScreen.show()
		game.schedule(500, { game.sound("sounds/" + actualScreen.backgroundMusic())}) // Because it can't reproduce until game starts
	}

	method recipes() = actualScreen.recipes()

}

object background inherits Visual {

	var property image

	override method isPickable() = false

}

class LevelButton {

	var level
	var property selected = false

	method image() {
		return "LEVEL" + level.levelNumber() + self.selectionText() + ".png"
	}

	method levelNumber() = level.levelNumber()

	method selectionText() = if (menu.selectedButton().levelNumber() == level.levelNumber()) "H" else "" //no se porq pero no funciona comparar por identidad
	

	method startLevel() {
		screenManager.switchScreen(level)
	}

}

class Screen {

	method show()

	method setInputs()

	method background()

	method backgroundMusic()

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

	override method background() = "menu_background.png"

	override method backgroundMusic() = "backgroundMusic-menu-short.mp3"

	method selectedButton() = self.buttons().get(selectedButtonNumber)

	override method setInputs() {
		keyboard.backspace().onPressDo{ game.stop()}
		keyboard.enter().onPressDo{ self.selectedButton().startLevel()}
			// levels
		keyboard.down().onPressDo{ self.selectChange(-1)}
		keyboard.s().onPressDo{ self.selectChange(-1)}
		keyboard.up().onPressDo{ self.selectChange(1)}
		keyboard.w().onPressDo{ self.selectChange(1)}
			// characters
		keyboard.a().onPressDo{ self.character1SelectChange(-1)}
		keyboard.d().onPressDo{ self.character1SelectChange(1)}
		keyboard.left().onPressDo{ self.character2SelectChange(-1)}
		keyboard.right().onPressDo{ self.character2SelectChange(1)}
	}

	method circularNumberScroll(number, limit) {
		return number.rem(limit).abs()
	}

	method character1SelectChange(delta) {
		character1Index = self.circularNumberScroll(character1Index + delta, self.charactersNames().size())
		character1.name(self.charactersNames().get(character1Index))
	}

	method character2SelectChange(delta) {
		character2Index = self.circularNumberScroll(character2Index + delta, self.charactersNames().size())
		character2.name(self.charactersNames().get(character2Index))
	}

	method limitBetweenListSize(list, number) {
		return number.limitBetween(0, list.size() - 1)
	}

	method charactersNames() = [ "rasta", "alf" ]

	method selectChange(delta) {
		selectedButtonNumber = self.limitBetweenListSize(self.buttons(), selectedButtonNumber + delta)
	}

	method buttons() {
		var level2 = new Level(levelNumber = 2, levelCharacteristics = level2Characteristics, character1 = character1.name(), character2 = character2.name(), backgroundMusic = "backgroundMusic-level1.mp3")
		return [ new LevelButton(level = level2) ]
	}

	override method show() {
		game.addVisualIn(new Image(name = "title"), game.center().left(4).up(2))
		var nextPosition = game.center().left(3).down(7)
		self.buttons().forEach({ button =>
			game.addVisualIn(button, nextPosition)
			nextPosition = nextPosition.up(2)
		})
		self.showPickPlayer(game.at(2, game.height() / 2), character1, "pick-player1")
		self.showPickPlayer(game.at(game.width() - 9, game.height() / 2), character2, "pick-player2")
	}

	method showPickPlayer(characterPosition, character, pickPlayerImageName) {
		game.addVisualIn(character, characterPosition)
		game.addVisualIn(new Image(name = pickPlayerImageName), characterPosition.down(2).left(1))
	}

}

class Level inherits Screen {

	var property levelNumber
	var character1
	var character2
	var levelCharacteristics
	var player1 = new Player()
	var player2 = new Player()
	var property backgroundMusic

	override method show() {
		self.start()
		player1.position(game.center().right(5))
		player2.position(game.center().left(5))
		game.addVisual(status)
		levelCharacteristics.levelVisualObjects().forEach({ levelObject => game.addVisual(levelObject)})
		game.addVisual(player1)
		game.addVisual(player2)
	}

	method recipes() = levelCharacteristics.posibleRecipes()

	method addNDesks(basePosition, n, direction) {
		var desks = []
		n.times({ i => desks.add(new Desk(position = direction.move(basePosition, i - 1)))})
		return desks
	}

	method start() {
		player1.character(character1)
		player2.character(character2)
		status.start() // I shall not forget to keep this line when I implement the layout parser
		var timer = new Timer(totalTime = levelCharacteristics.levelLength(), frecuency = 1, user = self)
		var clockPosition = game.at(gameManager.centerX() - 1, gameManager.height() - 1)
		numberDisplayGenerator.generateDigits(levelCharacteristics.levelLength() / 1000, timer, clockPosition)
		timer.start()
	}

	method timerFinishedAction() {
		score.setStars(levelCharacteristics.starScores())
		screenManager.switchScreen(score) // score could be a wko
	}

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

class LevelCharacteristics {

	method addNDesks(basePosition, n, direction) {
		var desks = []
		n.times({ i => desks.add(new Desk(position = direction.move(basePosition, i - 1)))})
		return desks
	}

}

object level2Characteristics inherits LevelCharacteristics {

	method levelVisualObjects() {
		var middleCurvex1 = 9
		var middleCurvex2 = middleCurvex1 + 4
		var middleSectionHeightDown = 6
		var middleSectionHeightUp = middleSectionHeightDown - 1
		var levelObjects = [ // desks
		self.addNDesks(game.origin(), 6, up), self.addNDesks(game.at(0, game.height() - 1), 4, down), self.addNDesks(game.at(1, game.height() - 1), 9, right), self.addNDesks(game.at(1, 0), 1, right), self.addNDesks(game.at(3, 0), 7, right), // weird middle part
		self.addNDesks(game.at(middleCurvex1, 1), middleSectionHeightDown, up), self.addNDesks(game.at(middleCurvex1, game.height() - 2), middleSectionHeightUp, down), self.addNDesks(game.at(middleCurvex1 + 1, middleSectionHeightDown), middleCurvex2 - middleCurvex1 - 1, right), self.addNDesks(game.at(middleCurvex1 + 1, game.height() - 1 - middleSectionHeightUp), middleCurvex2 - middleCurvex1 - 1, right), self.addNDesks(game.at(middleCurvex2, middleSectionHeightDown), middleSectionHeightDown + 1, down), self.addNDesks(game.at(middleCurvex2, game.height() - 1), middleSectionHeightUp + 1, down), // end of weird middle part
		self.addNDesks(game.at(middleCurvex2, game.height() - 1), 5, right), self.addNDesks(game.at(middleCurvex2 + 6, game.height() - 1), 3, right), self.addNDesks(game.at(middleCurvex2 + 1, 0), 2, right), self.addNDesks(game.at(middleCurvex2 + 5, 0), 4, right), self.addNDesks(gameManager.upperRightCorner().down(1), 3, down), self.addNDesks(gameManager.bottomRightCorner().up(1), 8, up) ]
		levelObjects.add([ new DeliverSpot(position = game.at(gameManager.width() - 1, 9)), new ChoppingDesk(position = game.at(middleCurvex2 + 3, 0)), new ChoppingDesk(position = game.at(middleCurvex2 + 4, 0)), new Trash(position = game.at(middleCurvex2 + 5, game.height() - 1)), new Spawner(toSpawnIngredient = new Ingredient(name = "tomato", position = game.at(0, 6))), new Spawner(toSpawnIngredient = new Ingredient(name = "lettuce", position = game.at(0, 7))), new Spawner(toSpawnIngredient = new Ingredient(name = "meat", position = game.at(0, 8))), new Spawner(toSpawnIngredient = new Ingredient(name = "potato", position = game.at(0, 9))), new Spawner(toSpawnIngredient = new Plate(position = game.at(2, 0))), new Plate(position=game.at(3,0)), new Plate(position=game.at(4,0)) ])
		return levelObjects.flatten()
	}

	method starScores() = [ 50, 100, 200 ]

	method posibleRecipes() {
		var tomatoSalad = new Recipe(name = "tomatoSalad", ingredients = [ new Ingredient(name="tomato",state=chopped), new Ingredient(name="tomato",state=chopped) ])
		var salad = new Recipe(name = "salad", ingredients = [ new Ingredient(name="tomato",state=chopped), new Ingredient(name="lettuce",state=chopped) ])
		var potatoSalad = new Recipe(name = "potatoSalad", ingredients = [ new Ingredient(name="tomato",state=chopped), new Ingredient(name="lettuce",state=chopped), new Ingredient(name="potato",state=chopped) ])
		var meatAndPotato = new Recipe(name = "meatAndPotato", ingredients = [ new Ingredient(name="potato",state=chopped), new Ingredient(name="meat",state=chopped) ])
		return [ tomatoSalad, salad, potatoSalad, meatAndPotato ]
	}

	method levelLength() = 180000

}

object score inherits Screen {

	var starPosition = game.center().left(8).down(4)
	var stars = [ new Star(basePosition=starPosition,xOffset=0), new Star(basePosition=starPosition,xOffset=1), new Star(basePosition=starPosition,xOffset=2) ]

	override method setInputs() {
		keyboard.enter().onPressDo({ screenManager.switchScreen(menu)})
	}

	override method show() {
		numberDisplayGenerator.generateDigits(status.score(), status, game.center().up(2))
		stars.forEach({ star => game.addVisual(star)})
	}

	override method background() = "menu_background.png"

	method setStars(starScores) {
		stars.forEach({ star => star.numberList(starScores)})
	}

	override method backgroundMusic() = "backgroundMusic-menu-short.mp3"

}

class Star {

	var numberProvider = status
	var property numberList = null
	var xOffset
	var basePosition

	method position() {
		return basePosition.right(6 * xOffset)
	}

	method fillingStatus() {
		return if (numberList.get(xOffset) > numberProvider.starNumber()) "empty" else "full"
	}

	method image() = self.fillingStatus() + "-star.png"

}

