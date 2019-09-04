import overcooked.*
import tiles.*
import items.*
import screens.*
import wollok.game.*

object status inherits Visual {

	var property recipes = []
	var score = 0
	var width = 3

	override method isPickable() = false

	override method image() = "status-bar.jpg"

	override method position() = game.at(gameManager.width(), 0)

	method width() = width

	method addRecipe(recipe) {
		recipes.add(recipe)
		recipe.show(recipes.size())
	}

	method recipeDelivered(recipe) {
		recipes.remove(recipe)
		recipe.clear()
		score += 25
	}

	method refreshVisuals() {
		self.clearVisuals()
		self.show()
	}

	method clearVisuals() {
		recipes.forEach({ recipe => recipe.clear()})
	}

	method show() {
		var recipeCount = 0
		recipes.forEach({ recipe =>
			recipe.show(recipeCount)
			recipeCount++
		})
	}
	
	method addRandomRecipe(levelRecipes){
			var newRecipeProbability = 5 //%
			var randomNumber=0.randomUpTo(100)
			
			if (randomNumber>newRecipeProbability){
				var totalRecipesSize= levelRecipes.size()
				var randomRecipeIndex = 0.randomUpTo(totalRecipesSize)
				self.addRecipe(levelRecipes.get(randomRecipeIndex).clone())
			}
	}
	
	method start(){
		recipes.clear()
		score=0
		self.addRandomRecipe(screenManager.recipes())//first recipe is instant
		game.onTick(8000, "random recipe", {self.addRandomRecipe(screenManager.recipes())})
	}

}

class Recipe {

	var ingredients
	var name

	method height() = 1

	method show(yCount) {
		var ingCount = 0
		ingredients.forEach({ ingredient =>
			ingredient.position(game.at(gameManager.width() + ingCount, self.height() * yCount))
			game.addVisual(ingredient)
			ingCount++
		})
	}

	method clear() {
		ingredients.forEach({ ing => game.removeVisual(ing)})
	}

	method plateMeetsRequierements(aPlate) {
//		console.println(ingredients.copy())
//		console.println(aPlate.ingredients().copy())
//		console.println(self.allElementsInOtherList(ingredients.copy(), aPlate.ingredients().copy()))
//		console.println(self.allElementsInOtherList(aPlate.ingredients().copy(), ingredients.copy()))
	
		return self.allElementsInOtherList(ingredients.copy(), aPlate.ingredients().copy()) && self.allElementsInOtherList(aPlate.ingredients().copy(), ingredients.copy())
		
	}

	method allElementsInOtherList(aList, otherList) {
		return aList.all({elem=>self.containsThenRemove(otherList,elem)})		
	}
	
	method containsThenRemove(list,elem){//consulta y accion :(
		if(list.any({e=>e.equals(elem)})){
				list.remove(elem)
				return true
		}else return false
	}
	
	method clone(){
	
		return new Recipe(ingredients=ingredients.map({ing=>ing.clone()}),name=name)
	}

}

