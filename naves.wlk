class Nave {

	var property velocidad = 0

	const maxVelocidad = 300000

	method propulsar() {
		velocidad = (velocidad + 20000).min(maxVelocidad)
	}

	method prepararParaViajar() {
		velocidad = (velocidad + 15000).min(maxVelocidad)
	}

	method recibirAmenaza() { /*subclass responsability*/ }
}


class NaveDeCarga inherits Nave {
	
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000

	override method recibirAmenaza() {
		carga = 0
	}

}


class NaveDeCargaRadioactiva inherits NaveDeCarga {
	
	var property sellado = false

	method sellar() {
		sellado = true
	}

	override method recibirAmenaza() {
		self.velocidad(0)
	}

	override method prepararParaViajar() {
		super()
		self.sellar()
	}
}


class NaveDePasajeros inherits Nave {
	
	var property alarma = false
	
	const cantidadDePasajeros = 0

	method tripulacion() = cantidadDePasajeros + 4

	method velocidadMaximaLegal() = 300000 / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}

}


class NaveDeCombate inherits Nave {
	
	var property modo = reposo
	
	const property mensajesEmitidos = []

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararParaViajar() {
		super()
		modo.prepararParaViaje(self)
	}
}


object reposo {

	method invisible() = false

	method recibirAmenaza(nave) {
		nave.emitirMensaje("¡RETIRADA!")
	}

	method prepararParaViaje(nave) {
		nave.emitirMensaje("Saliendo en misión")
		nave.modo(ataque)
	}
}

object ataque {

	method invisible() = true

	method recibirAmenaza(nave) {
		nave.emitirMensaje("Enemigo encontrado")
	}

	method prepararParaViaje(nave) {
		nave.emitirMensaje("Volviendo a la base")
	}
}
