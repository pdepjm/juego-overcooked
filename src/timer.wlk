import wollok.game.*
import overcooked.*


class Timer{
	var totalTime //ms
	var frecuency //hz
	var property user
	var tickCounter = 0
	
	method tickSpacing()=1000/frecuency //ms
	
	method remainingTime()=totalTime-self.tickSpacing()*tickCounter //ms
	
	method start(){
		game.onTick(1000/frecuency, self.identity().toString(), {self.onTick()})
	}
	
	method clone(){
		return new Timer(totalTime=totalTime,frecuency=frecuency,user=user,tickCounter=tickCounter)
	}
	
	method onTick(){
		tickCounter++
		if(self.remainingTime()<=0) {
			self.stop()
			user.timerFinishedAction()
		}
		user.timerOnTickAction()
	} 
	
	 
	
	method stop(){
		game.removeTickEvent(self.identity().toString())
	}
	
	method getProgressBar(amountOfImages,recipe){
		return new ProgressBar(amountOfImages=amountOfImages,totalTime=totalTime,timer=self)
	}
	
}

//object noTimer{
//	method remainingTime(timerUser)=timerUser.totalTime()
//}

 

class ProgressBar inherits Visual{
	var property totalTime
	var amountOfImages
	var timer
		
	override method isPickable()=false
	
	method start(){
		timer.start()
	}
	
	method imageNumber(){		
		var timeBetweenImages = totalTime/amountOfImages
		var decimalImageNumber= timer.remainingTime()/timeBetweenImages
		return (decimalImageNumber.truncate(0) - 1 ).max(0)
	}
	method image() = "progress" + self.imageNumber() +".png"
	
}