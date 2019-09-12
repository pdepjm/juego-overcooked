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
	
	method getClock(position){
		return new Clock(timer=self,position=position)
	}
	
	method remainingSeconds()=(self.remainingTime()/1000).truncate(0)
	
}

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
	override method image() = "progress" + self.imageNumber() +".png"
	
}

class Clock{
	var position
	var timer
	var digits=[]
	method refreshVisuals(){
		self.clear()
		self.show()
	}
	method clear(){
		digits.forEach({digit=>game.removeVisual(digit)})
	}
	method start(){
		timer.start()//repite, necesito una supraclase solo por esto?
	}	
	method show(){
		digits=self.getTimerDigits()
		var xOffset = 0
		digits.forEach({digit=>
			digit.position(position.right(xOffset))
			game.addVisual(digit)
			xOffset++	
		})
	}
	
	method getTimerDigits()=self.mapLetters(timer.remainingSeconds().toString(),{n=>new Digit(digit=n)})
	
	method mapLetters(string,closure){//funcional te extranio
		var newString=[]		
		string.length().times({i=>
			var mappedLetter = closure.apply(string.charAt(i-1))
			newString.add(mappedLetter)
		})
		return newString
	}
		
}


class Digit inherits Visual{
	var property digit
	override method image() = "numbers/"+digit+".png"
	override method isPickable()=false
	override method canContain(item)=false
}