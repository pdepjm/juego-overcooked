import wollok.game.*
import overcooked.*
import tiles.*
import items.*

object status inherits Visual {

	var property recipes = []
	var score = 0
	var width = 3

	override method isPickable() = false

	override method image() = "status-bar.jpg"

	override method position() = game.at(gameManager.width(), 0)	

	method width() = width

	method addRecipe(recipe){
		recipes.add(recipe)
		recipe.show(recipes.size())
	}

	method recipeDelivered(recipe){
		recipes.remove(recipe) 
		recipe.clear()
		score+=25
	}
	
	method refreshVisuals(){
		self.clearVisuals()
		self.show()
	}
	
	method clearVisuals(){
		recipes.forEach({
			recipe=> recipe.clear()
		})
	}
	
	method show(){
		var recipeCount=0
		recipes.forEach({recipe=>
			recipe.show(recipeCount)
			recipeCount++
		})
	}
}

class Recipe{
	var ingredients	
	var name
	
	method height()=1
	
	method show(yCount){
		var ingCount=0
		ingredients.forEach({
			ingredient=>
			ingredient.position(game.at(gameManager.width()+ingCount,self.height()*yCount))
			game.addVisual(ingredient)
			ingCount++
		})		
	}
	
	method clear(){
		ingredients.forEach({
			ing=>game.removeVisual(ing)
		})
	}
	
	method plateMeetsRequierements(aPlate){
		var plateIngredients = aPlate.ingredients()		
		return self.allElementsInOtherList(ingredients,plateIngredients) && self.allElementsInOtherList(plateIngredients,ingredients)
	}
	
	method allElementsInOtherList(aList,otherList){
		return aList.all({firstElem=>otherList.any({elem=>elem.equals(firstElem)})})
	}
	
} 