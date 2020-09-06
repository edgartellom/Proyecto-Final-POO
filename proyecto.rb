class Planner
	def initialize
		@maquinas = []
	end
	def registrarMaquina(maquina)
		@maquinas.push(maquina)
	end
	def crearReporteMantenimiento(mantenimiento)
	end
	def listarReportesMaquina(maquina)
	end
	def programarMantenimiento()
	end
	def crearReporteCosto(mantenimiento)
	end
	def listarReportesCosto(maquina)
	end
	def calcularCostoTotal()
	end
end

class Maquina
	def initialize(serie, nombre)
		@serie = serie
		@nombre = nombre
		@mantenimientos = []
	end
	def registrarMantenimiento(mantenimiento)
		@mantenimientos.push(mantenimiento)
	end
end

class Mantenimiento
	def initialize(codigo,detalle, fecha, duracion, dificultad)
		@codigo = codigo
		@detalle = detalle
		@fecha = fecha
		@duracion = duracion
		@dificultad = dificultad
		@tecnicos = []
		@insumos = []
	end
	def mostrarDatos
	end
	def registrarTecnico(tecnico)
		@tecnicos.push(tecnico)
	end
	def registrarInsumo(insumo)
		@insumos.push(insumo)
	end
	def calcularCostoManodeObra()
		costo = 0
		for tecnico in @tecnicos
			costo = costo + tecnico.calcularCostoManodeObra
		end
		return costo
	end
	def calcularCostoInsumos()
	end
	def calcularCosto()
	end
end

class Preventivo < Mantenimiento
	def initialize(detalle, fecha, duracion, dificultad, frecuencia)
		super(detalle, fecha, duracion, dificultad)
		@frecuencia = frecuencia
	end
	def mostrarDatos
	end
	def registrarTecnico
		super
	end
	def registrarInsumo
		super
	end
	def programarMantenimiento
	end
	def calcularCosto
	end
end

class Correctivo < Mantenimiento
	def initialize(detalle, fecha, duracion, dificultad, tipoFalla)
		super(detalle, fecha, duracion, dificultad)
		@tipoFalla = tipoFalla
	end
	def mostrarDatos
	end
	def registrarTecnico
		super
	end
	def registrarInsumo
		super
	end
	def calcularCosto
	end
end

class Tecnico
	def initialize(nombre, trabajo)
		@nombre = nombre
		@trabajo = trabajo
	end
	def calcularCostoManodeObra(mantenimiento)
	end
end

class Interno < Tecnico
	def initialize(nombre, trabajo, costoHora)
		super(nombre, trabajo)
		@costoHora = costoHora
	end
	def calcularCostoManodeObra(mantenimiento)
		@costoHora * mantenimiento.duracion
	end
end

class Externo < Tecnico
	def initialize(nombre, trabajo, tarifa, certificacion)
		super(nombre, trabajo)
		@tarifa = tarifa
		@certificacion = certificacion
	end
	def obtenerAdicional
		adicional = 0
		if @certificacion == true
			adicional = 0.25
		end
		return adicional
	end
	def obtenerSuplemento(mantenimiento)
		costoBase = @tarifa * mantenimiento.duracion
		case mantenimiento.dificultad
		when 5
			suplemento = costoBase * 1.0
		when 4
			suplemento = costoBase * 0.75
		when 3
			suplemento = costoBase * 0.5
		when 2
			suplemento = costoBase * 0.25
		when 1
			suplemento = 0
		end
		return suplemento
	end
	def calcularCostoManodeObra(mantenimiento)
		costoBase = @tarifa * mantenimiento.duracion
		costoFinal = (costoBase + obtenerSuplemento) * (1 + obtenerAdicional)
		return costoFinal
	end
end

class Insumo
	def initialize(descripcion, cantidad, unidad, precio)
		@descripcion = descripcion
		@cantidad = cantidad
		@unidad = unidad
		@precio = precio
	end
	def obtenerDescuento()
	end
	def calcularCosto()
	end
end

class Local < Insumo
	def initialize(descripcion, cantidad, unidad, precio, dimension, distanciaProveedor)
		super(descripcion, cantidad, precio)
		@dimension = dimension
		@distanciaProveedor
	end
	def obtenerDescuento
		descuento = 0
		case @unidad
		when "mt"
			if @cantidad >= 10 && @cantidad < 25
				descuento = @precio * 0.05
			elsif @cantidad >= 25 && @cantidad < 50
				descuento = @precio * 0.10
			elsif @cantidad >= 50 && @cantidad < 100
				descuento = @precio * 0.15
			elsif @cantidad >= 100
				descuento = @precio * 0.20
			end
		else
			if @cantidad >= 6 && @cantidad < 12
				descuento = @precio * 0.05
			elsif @cantidad >= 12 && @cantidad < 36
				descuento = @precio * 0.10
			elsif @cantidad >= 36 && @cantidad < 50
				descuento = @precio * 0.12
			elsif @cantidad >= 50 && @cantidad < 100
				descuento = @precio * 0.15
			elsif @cantidad >= 100
				descuento = @precio * 0.17
			end
		end
		return descuento		
	end
	def calcularGastoTransporte

	end
	def calcularCosto
	end
end

class Importado < Insumo
	def initialize(descripcion, cantidad, unidad, precio, procedencia, peso)
		super(descripcion, cantidad, precio)
		@procedencia = procedencia
		@peso = peso
	end
	def obtenerDescuento
		descuento = 0
		if @precio >= 100 && @precio < 500
			 descuento = @precio * 0.02
			@precio >= 500 && @precio < 1000
			 descuento = @precio * 0.05
			@precio >= 1000 && @precio < 10000
			 descuento = @precio * 0.08
			@precio >= 10000 && @precio < 100000
			 descuento = @precio * 0.12
			@precio > 100000
			 descuento = @precio * 0.15
		end
		return descuento
	end
	def calcularFlete
	end
	def calcularImpuesto
	end
	def calcularCosto
	end
end
