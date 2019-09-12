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
		game.boardGround(actualScreen.background()) // DOESNT WORK
		actualScreen.setInputs()
		actualScreen.show()
		game.schedule(500, {game.sound("sounds/" + actualScreen.backgroundMusic())}) // Because it can't reproduce until game starts
	}
	
	method recipes()=actualScreen.recipes()
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
	var property buttons = [ new LevelButton(level=1), new LevelButton(level=2) ]

	override method background() = "tiledWood.jpg"
	
	override method backgroundMusic() = "backgroundMusic-menu-short.mp3"

	method selectedButton() = self.buttons().get(selectedButtonNumber)

	override method setInputs() {
		keyboard.backspace().onPressDo{game.stop()}
		
		keyboard.enter().onPressDo{ 
			var selectedLevelNumber = self.selectedButton().level() - 1
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

	method circularNumberScroll(number, limit){
		return number.rem(limit).abs()
	}

	method character1SelectChange(delta) {		
		character1Index =self.circularNumberScroll(character1Index+delta,self.charactersNames().size())
		character1.name(self.charactersNames().get(character1Index))
	}

	method character2SelectChange(delta) {
		character2Index =self.circularNumberScroll(character2Index+delta,self.charactersNames().size())
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

	method levels() {
		var tomatoSalad = new Recipe(name = "tomatoSalad", ingredients = [new Ingredient(name="tomato",state="cut"), new Ingredient(name="tomato",state="cut")])
		var salad = new Recipe(name = "salad", ingredients = [ new Ingredient(name="tomato",state="cut"), new Ingredient(name="lettuce",state="cut") ])
		var level1 = new Level(levelLength=15000,layout = "TODO", posibleRecipes = [ salad,tomatoSalad ], ingredients = [], character1 = character1.name(), character2 = character2.name(), backgroundMusic = "backgroundMusic-level1.mp3")
		
		return [ // parallel list with buttons (TODO: generate buttons list from this one)	
		level1, new Level(levelLength=99000,layout="TODO",posibleRecipes=[],ingredients=[],character1=character1.name(),character2=character2.name(), backgroundMusic="backgroundMusic-level2.mp3") ]
	}

	override method show() {
		game.addVisualIn(new Image(name = "title"), game.center().left(4).up(4))
		var nextPosition = game.center().left(4).down(7)
		self.buttons().forEach({ button =>
			game.addVisualIn(button, nextPosition)
			nextPosition = nextPosition.up(3)
		})
		self.showPickPlayer(game.at(1, game.height() / 2), character1, "pick-player1")
		self.showPickPlayer(game.at(game.width() - 9, game.height() / 2), character2, "pick-player2")
	}

	method showPickPlayer(characterPosition, character, pickPlayerImageName) {
		game.addVisualIn(character, characterPosition)
		game.addVisualIn(new Image(name = pickPlayerImageName), characterPosition.down(2))
	}

}

class Level inherits Screen {

	var layout
	var posibleRecipes
	var levelLength //ms
	var ingredients
	var clock = null
	var character1
	var character2
	var player1 = new Player()
	var player2 = new Player()
	var property backgroundMusic


	method recipes()=posibleRecipes

	override method show() {
		self.start()
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
		var cosas = [ new Plate(position=game.at(9,8)), new Plate(position=game.at(9,5)), new Plate(position=game.at(9,1))]
		cosas.forEach({ cosa => game.addVisual(cosa) })
		game.addVisual(player1)
		game.addVisual(player2)
		
		
	}
	
//	method mapLetters(string,closure){//funcional te extranio
//		var newString=[]		
//		string.length().times({i=>
//			var mappedLetter = closure.apply(string.charAt(i-1))
//			newString.add(mappedLetter)
//		})
//		return newString
//	}
	
	
	
	method start(){
		player1.character(character1)
		player2.character(character2)
		status.start() //I shall not forget to keep this line when I implement the layout parser
		game.onTick(100, "status refresh", { status.refreshVisuals() })
		var timer= new Timer(totalTime= levelLength,frecuency=1,user=self)
		var clockPosition=game.at(gameManager.centerX(),gameManager.height()-1)
		numberDisplayGenerator.generateDigits(levelLength/1000,timer,clockPosition)
		
		timer.start()
	}
	
	method timerFinishedAction(){
		screenManager.switchScreen(score) //score could be a wko
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


object score inherits Screen{
	override method setInputs(){
		keyboard.enter().onPressDo{screenManager.switchScreen(menu)}		
	}
	override method show(){
		numberDisplayGenerator.generateDigits(status.score(),status,game.center())
	}
	
	override method background()="scoreBackground.jpg"
	
	
	override method backgroundMusic()="backgroundMusic-menu-short.mp3"
}



