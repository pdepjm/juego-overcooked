import wollok.game.*
import overcooked.*


class Timer{
	var property remainingTime //ms
	var name
	var frecuency //hz
	var finishAction
	var onTickAction
	
	method start(){
		game.onTick(1000/frecuency, name, {self.onTick()})
	}
	
	method onTick(){
		remainingTime -= 1000/frecuency
		if(remainingTime<=0) {
			self.stop()
			finishAction.apply()
		}
		onTickAction.apply()
	} 
	
	method stop(){
		game.removeTickEvent(name)
	}
}

 

class ProgressBar inherits Visual{
	var id
	var totalTime
	var amountOfImages
	var recipe
	var  timer 
	
	
	
	override method isPickable()=false
	
	method start(){
		timer.start()
	}
	
	// NECESITO UN CONSTRUCTOR!!!!
	method createTimer()=new Timer(remainingTime = totalTime,name=id,frecuency=0.5,finishAction={self.finish()},onTickAction={})
	
	
	method imageNumber(){		
		var timeBetweenImages = totalTime/amountOfImages
		var decimalImageNumber= timer.remainingTime()/timeBetweenImages
		return (decimalImageNumber.truncate(0) - 1 ).max(0)
	}
	method finish(){
		console.println("finished progress bar")
		//recipe.timeout()
	}
	
	method image() = "progress" + self.imageNumber() +".png"
	
}