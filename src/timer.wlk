import wollok.game.*

class Timer{
	var remainingTime //ms
	var name
	var frecuency //hz
	var finishAction
	
	method start(){
		game.onTick(1000/frecuency, name, {self.onTickAction()})
	}
	
	method onTickAction(){
		remainingTime -= 1000/frecuency
		if(remainingTime<=0) {
			self.stop()
			finishAction.apply()
		}
	} 
	
	method stop(){
		game.removeTickEvent(name)
	}
}