object inmobiliaria {
	var empleados
	method obtenerMejorEmpleadoSegun(criterio) = empleados.max({ unEmpleado => criterio.criterioAOrdenar(unEmpleado) })
}

object criterioComisiones{
	method criterioAOrdenar(empleado) = empleado.comisiones()
}
object criterioReservas{
	method criterioAOrdenar(empleado) = empleado.cantidadReservas().size()
}
object criterioOperaciones{
	method criterioAOrdenar(empleado) = empleado.comisiones().size()
}

class Empleado {
	var comisiones
	var reservas
	var operaciones
	
	method realizarOperacion(operacion, cliente) { 
		const inmueble = operacion.obtenerInmueble()
		if(inmueble.estaReservada() && inmueble.cliente() != cliente)
		self.error("Este inmueble esta reservado por otro cliente")
		comisiones += operacion.calcularComision()
		operaciones.add(operacion)
	}
	method realizarReserva(cliente, inmueble) { 
		inmueble.serReservada(cliente)
		operaciones.add(reservas)
		cliente.agregarAListaPropiedadesReservadas(inmueble)
	}
	method obtenerVariable(variable) = variable
	method comisiones() = comisiones
	method reservas() = reservas
	method operaciones() = operaciones
	method tieneProblemasCon(empleado) { }
	method cerroOperacionesEn(zona) = operaciones.any({ unaOperacion => unaOperacion.zona() == zona })
}

class Operacion {
	var tipoOperacion
	var inmueble
	
	method obtenerTipoOperacion() = tipoOperacion
	method calcularComision() = tipoOperacion.comision(inmueble)
	method obtenerInmueble() = inmueble
	method zona() = inmueble.zona()
}

object alquiler {
	var cantidadMeses
	
	method comision(inmueble) = (cantidadMeses * inmueble.obtenerValor()) / 50000
	
}

object venta {
	var porcentajeValor
	
	method comision(inmueble) { 
		if(not inmueble.puedeVenderse())
		self.error("Este inmueble no puede venderse")
		return (inmueble.obtenerValor() / 100) * porcentajeValor
	}
	method asignarPorcentaje(nuevoPorcentaje) { porcentajeValor = nuevoPorcentaje }
}

class Inmueble {
	var operacion
	var cliente	
	var estaReservada
	var zona
	
	method obtenerValor() = zona.valorZona()
	method setearCliente(nuevoCliente) { cliente = nuevoCliente }
	method serReservada(clienteQueReserva) {
		self.setearCliente(clienteQueReserva)
		estaReservada = true
	}
	method puedeVenderse() = true
}

class Zona {
	var valor
	method valorZona() = valor
	method cambiarValorZona(nuevoValor) { valor = nuevoValor }
	
}

class Casa inherits Inmueble {
	var valor
	override method obtenerValor() = super() + valor
	method setearValor(nuevoValor) { valor = nuevoValor }
}
class PH inherits Inmueble {
	var tamanioEnM2
	method valorSegunM2() = 14000 * tamanioEnM2
	override method obtenerValor() = super() + self.valorSegunM2().max(500000)
}
class Departamento inherits Inmueble {
	var cantidadAmbientes
	override method obtenerValor() = super() + 350000 * cantidadAmbientes
}

class Local inherits Casa { 
	override method puedeVenderse() = false
}

class Galpon inherits Local {
	override method obtenerValor() = super() / 2
}

class ALaCalle inherits Local {
	var montoFijo
	override method obtenerValor() = super() + montoFijo
}

class Cliente {
	var listaPropiedadesReservadas = []
	method solicitarReserva(inmueble, empleado) { empleado.realizarReserva(self, inmueble) }
	method solicitarOperacion(operacion, empleado) { empleado.realizarOperacion(operacion, self)}
	method agregarAListaPropiedadesReservadas(inmueble) { listaPropiedadesReservadas.add(inmueble) }
	}