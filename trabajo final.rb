require 'csv'

class Mantenimiento
	attr_reader :codigo, :linea, :maquina, :detalle, :fecha, :duracion, :dificultad, :tecnicos, :insumos
	def initialize(codigo, linea, maquina, detalle, fecha, duracion, dificultad)
		@codigo = codigo
		@linea = linea
		@maquina = maquina
		@detalle = detalle
		@fecha = fecha
		@duracion = duracion
		@dificultad = dificultad
		@tecnicos = []
		@insumos = []
	end
	def obtenerCodigo
		return @codigo
	end		
	def obtenerDatos
		datos = [@codigo, @linea, @maquina, @detalle, @fecha, @duracion, @dificultad]
		return datos
	end
	def obtenerTecnicos
		return @tecnicos
	end
	def obtenerInsumos
		return @insumos
	end
	def obtenerTipo
	end

	def registrarTecnico(tecnico)
		if validarRegistro(tecnico.nombre) == nil
		@tecnicos.push(tecnico)
		return "Técnico #{tecnico.nombre} Registrado Exitosamente en Mantenimiento"
		end
	end

	def registrarInsumo(insumo)
		if validarIngreso(insumo.descripcion) == nil
		@insumos.push(insumo)
		return "Insumo Registrado Exitosamente en Mantenimiento"
		end
	end
	
	def validarRegistro(nombre)
		for tecnico in tecnicos
			if tecnico.nombre == nombre
				raise "Error: Tecnico: #{tecnico.nombre}, ya ha sido registrado para este Mantenimiento"
			end
		end
		return nil
	end

	def validarIngreso(descripcion)
		for insumo in insumos
			if insumo.descripcion == descripcion
				raise "Error: Insumo: #{insumo.descripcion}, ya ha sido registrado para este Mantenimiento"
			end
		end
		return nil
	end
	
	def calcularCostoManodeObra()
		costo = 0
		for tecnico in @tecnicos
			costo = costo + (tecnico.calcularTarifa * @duracion)
		end
		return costo
	end
	
	def calcularCostoInsumos()
		costo = 0
		for insumo in @insumos
			costo = costo + insumo.calcularCosto
		end
		return costo
	end
	
	def calcularCostoTotal()
		calcularCostoManodeObra + calcularCostoInsumos
	end
end

class Preventivo < Mantenimiento
	attr_reader :frecuencia

	def initialize(codigo, linea, maquina, detalle, fecha, duracion, dificultad, frecuencia)
		super(codigo, linea, maquina, detalle, fecha, duracion, dificultad)
		@frecuencia = frecuencia
	end
	def obtenerDatos
		datos = super + [frecuencia]
		return datos
	end
	def obtenerTipo
		"Preventivo"
	end
end

class Correctivo < Mantenimiento
	attr_reader :tipoFalla
	def initialize(codigo, linea, maquina, detalle, fecha, duracion, dificultad, tipoFalla)
		super(codigo, linea, maquina, detalle, fecha, duracion, dificultad)
		@tipoFalla = tipoFalla
	end
	def obtenerDatos
		datos = super + [tipoFalla]
		return datos
	end
	def obtenerTipo
		"Correctivo"
	end
end

NOMBRE_ARCHIVO2 = "tecnicos.csv"
class Tecnico
	attr_reader :nombre, :trabajo
	def initialize(nombre, trabajo)
		@nombre = nombre
		@trabajo = trabajo
	end
	def obtenerDatos
		datos = [@nombre, @trabajo]
		return datos
	end
	def obtenerTipo
	end
	def calcularTarifa
	end

end

class Interno < Tecnico
	attr_reader :sueldo
	def initialize(nombre, trabajo, sueldo)
		super(nombre, trabajo)
		@sueldo = sueldo
	end
	def calcularTarifa
		sueldo / 240 
	end
	def obtenerDatos
		datos = super + [sueldo]
		return datos
	end
	def obtenerTipo
		"Interno"
	end
end

class Externo < Tecnico
	attr_reader :tarifa, :certificacion
	def initialize(nombre, trabajo, tarifa, certificacion)
		super(nombre, trabajo)
		@tarifa = tarifa
		@certificacion = certificacion
	end
	
	def calcularTarifa
		tarifa
	end
	def obtenerDatos
		datos = super + [tarifa, certificacion]
		return datos
	end
	def obtenerTipo
		"Externo"
	end
end


class Insumo
	attr_reader :descripcion, :cantidad, :unidad, :precio

	def initialize(descripcion, cantidad, unidad, precio)
		@descripcion = descripcion
		@cantidad = cantidad
		@unidad = unidad
		@precio = precio
	end
	
	def calcularCosto()
	end
	def obtenerDatos
		datos = [@descripcion, @cantidad, @unidad, @precio]
		return datos
	end
	def obtenerTipo
	end
end

class Local < Insumo
	attr_reader :gastoTransporte
	def initialize(descripcion, cantidad, unidad, precio, gastoTransporte)
		super(descripcion, cantidad, unidad, precio)
		@gastoTransporte = gastoTransporte
		
	end
	def calcularCosto()
		cantidad * precio + gastoTransporte
	end
	def obtenerDatos
		datos = super + [gastoTransporte]
		return datos
	end
	def obtenerTipo
		"Local"
	end
end

class Importado < Insumo
	attr_reader :costoEnvio, :impuestos
	def initialize(descripcion, cantidad, unidad, precio, costoEnvio, impuestos)
		super(descripcion, cantidad, unidad, precio)
		@costoEnvio = costoEnvio
		@impuestos = impuestos
		
	end
	def calcularCosto
		(cantidad * precio) + costoEnvio + impuestos
	end
	def obtenerDatos
		datos = super + [costoEnvio, impuestos]
		return datos
	end
	def obtenerTipo
		"Importado"
	end

end

class Planner
	attr_reader :mantenimientos
	def initialize
		@mantenimientos = []
	end
	
	def obtenerMantenimientos
		return @mantenimientos
	end
	def registrarMantenimiento(mantenimiento)
		mantenimientoResultado = buscarMantenimiento(mantenimiento.obtenerCodigo)
		if mantenimientoResultado != nil
			raise "Error: Mantenimiento: #{mantenimiento.obtenerCodigo}, ya ha sido Registrado"
		end
		@mantenimientos.push(mantenimiento)
	end
	
	def registrarTecnicoEnMantenimiento(codigo, tecnico)
		mantenimiento = buscarMantenimiento(codigo)
		if mantenimiento == nil
			raise "Mantenimiento con código #{codigo} no encontrado."
		end
		mantenimiento.registrarTecnico(tecnico)
	end

	def registrarInsumoEnMantenimiento(codigo, insumo)
		mantenimiento = buscarMantenimiento(codigo)
		if mantenimiento == nil
			raise "Mantenimiento con código #{codigo} no encontrado."
		end
		mantenimiento.registrarInsumo(insumo)
	end

	def buscarMantenimiento(codigo)
		for mantenimiento in mantenimientos
			if mantenimiento.codigo == codigo
				return mantenimiento
			end
		end
		return nil
	end
	
	def buscarMantenimientosLinea(linea)
		arreglo = []
		for mantenimiento in mantenimientos
			if mantenimiento.linea == linea
				arreglo.push(mantenimiento)
			end
		end
		if arreglo.size > 0
			return arreglo
		else
			raise "ERROR. No se encontraron mantenimientos!... Ingrese un valor registado!"
		end
	end
	def buscarMantenimientosLineaMaquina(linea, maquina)
		arreglo = []
		for mantenimiento in mantenimientos
			if mantenimiento.linea == linea
				if mantenimiento.maquina == maquina
					arreglo.push(mantenimiento)
				end
			end
		end
		if arreglo.size > 0
			return arreglo
		else
			raise "ERROR. No se encontraron mantenimientos!... Ingrese valores registados!"
		end
	end
end

class FactoryMantenimiento
	def self.create(tipo, arg)
		case tipo
		when "p" , "P"
			Preventivo.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])
		when "c" , "C"
			Correctivo.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])
		end
	end
end
class FactoryTecnico
	def self.create(tipo, arg)
		case tipo
		when "i" , "I"
			Interno.new(arg[0], arg[1], arg[2])
		when "e" , "E"
			Externo.new(arg[0], arg[1], arg[2], arg[3])
		end
	end
end
class FactoryInsumo
	def self.create(tipo, arg)
		case tipo
		when "L" , "l"
			Local.new(arg[0], arg[1], arg[2], arg[3], arg[4])
		when "I" , "i"
			Importado.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5])
		end
	end
end

class VistaEntrada
	def mostrarMenuInicio
		seleccion = 0
		  system('cls')
		  puts "Sistema de Mantenimiento"
		  puts "========================"
		  puts "Opciones:"
		  puts "1. Generar Reporte"
		  puts "2. Buscar Reporte"
		  puts "3. Listar Reportes"
		  puts 
		  puts "9. Salir"
		  puts "Ingrese la opcion deseada:"

		  seleccion = gets.chomp.to_i
		  if seleccion != 1 && seleccion != 2 && seleccion != 3 && seleccion != 9
		  	raise "ERROR. Ingrese una opción válida"
		  end
		return seleccion
	end

	def mostrarMenuMantenimiento
		seleccion = 0
		  puts
		  puts "Generando Reporte de Mantenimiento ..."
		  puts "Ingrese la opcion deseada ..."
		  puts "Tipo de Mantenimiento Preventivo (P) o Correctivo (C)?. Para regresar (X)"
		  
		  seleccion = gets.chomp.to_s
		  if seleccion != "p" && seleccion != "P" && seleccion != "c" && seleccion != "C" && seleccion != "x" && seleccion != "X"
		  	raise "ERROR. Ingrese una opción válida"
		  end
		return seleccion
	end

	def mostrarFormularioMantenimiento
		datos = []
		print "Ingrese Código de Mantenimiento: "
		codigo = gets.chomp.to_s
		print "Ingrese Línea de Máquina : "
		linea = gets.chomp.to_s
		print "Ingrese Nombre de Máquina : "
		maquina = gets.chomp.to_s
		print "Ingrese Detalle de Mantenimiento : "
		detalle = gets.chomp.to_s
		print "Ingrese Fecha de Mantenimiento (dd/mm/yyyy) : "
		fecha = gets.chomp.to_s
		print "Ingrese Duración de Mantenimiento (en horas) : "
		duracion = gets.chomp.to_f
		print "Ingrese Dificultad del Mantenimiento (1 - 5) : "
		dificultad = gets.chomp.to_i
		datos.push(codigo, linea, maquina, detalle, fecha, duracion, dificultad)
		return datos
	end

	def mostrarFormularioPreventivo
	#(codigo, linea, maquina, detalle, fecha, duracion, dificultad, frecuencia)
		datos = mostrarFormularioMantenimiento
		print "Ingrese Frecuencia de Mantenimiento (en días) : "
		frecuencia = gets.chomp.to_i
		datos.push(frecuencia)
		return datos
	end

	def mostrarFormularioCorrectivo
		#(codigo, linea, maquina, detalle, fecha, duracion, dificultad, tipoFalla)
		datos = mostrarFormularioMantenimiento
		print "Ingrese Tipo de Falla (Mecánica / Eléctrica) : "
		tipoFalla = gets.chomp.to_s
		datos.push(tipoFalla)
		return datos
	end

	def mostrarMenuTecnico
		seleccion = 0
		 puts
		 puts "Ingrese la opcion deseada ..."
		 puts "Ingresa Técnico Interno (I) o Externo (E)?. Para registrar Insumos (X)"
			seleccion = gets.chomp.to_s
			if seleccion != "i" && seleccion != "I" && seleccion != "e" && seleccion != "E" && seleccion != "x" && seleccion != "X"
		  	raise "ERROR. Ingrese una opción válida"
		  end
		return seleccion
	end

	def mostrarFormularioTecnico
		datos = []
		print "Ingrese Nombre del Técnico : "
		nombre = gets.chomp.to_s
		print "Ingrese Trabajo realizado : "
		trabajo = gets.chomp.to_s
		datos.push(nombre, trabajo)
		return datos
	end

	def mostrarFormularioInterno
		datos = mostrarFormularioTecnico
		print "Ingrese Sueldo del Técnico (S/.) : "
		sueldo = gets.chomp.to_f
		datos.push(sueldo)
		return datos
	end
	def mostrarFormularioExterno
		datos = mostrarFormularioTecnico
		print "Ingrese Tarifa por hora (S/.) : "
		tarifa = gets.chomp.to_i
		print "Cuenta con certificacion? (Si / No) : "
		certificacion = gets.chomp.to_s
		datos.push(tarifa, certificacion)
		return datos
	end

	def mostrarMenuInsumo
		seleccion = " "
		puts
		puts "Ingresando Insumo(s) ..."
		puts "Ingrese la opcion deseada ..."
		puts "Insumo Local (L) o Importado (I)?. Para Finalizar (X)"
		seleccion = gets.chomp.to_s
		if seleccion != "l" && seleccion != "L" && seleccion != "i" && seleccion != "I" && seleccion != "x" && seleccion != "X"
			raise "ERROR. Ingrese una opción válida"
		end
		return seleccion
	end

	def mostrarFormularioInsumo
		datos = []
		print "Ingrese Descripción del insumo : "
		descripcion = gets.chomp.to_s
		print "Ingrese Cantidad : "
		cantidad = gets.chomp.to_f
		print "Ingrese Unidad : "
		unidad = gets.chomp.to_s
		print "Ingrese Precio Unitario (S/.): "
		precio = gets.chomp.to_f
		datos.push(descripcion, cantidad, unidad, precio)
		return datos
	end

	def mostrarFormularioLocal
		datos = mostrarFormularioInsumo
		print "Ingrese Gasto de transporte : "
		gastoTransporte = gets.chomp.to_f
		datos.push(gastoTransporte)
		return datos
	end
	def mostrarFormularioImportado
		#(descripcion, cantidad, unidad, precio, costoEnvio, impuestos)
		datos = mostrarFormularioInsumo
		print "Ingrese Costo de Envío : "
		costoEnvio = gets.chomp.to_f
		print "Ingrese Gasto de Impuestos : "
		impuestos = gets.chomp.to_f
		datos.push(costoEnvio, impuestos)
		return datos
	end

	def mostrarFormularioBuscarMantenimiento
		print "Ingrese Código de Mantenimiento : "
		codigo = gets.chomp.to_s
		return codigo
	end
	def mostrarMenuBuscarMantenimiento
		seleccion = 0
		  system('cls')
		  puts "Sistema de Mantenimiento"
		  puts "========================"
		  puts "Obteniendo Reporte ..."
		  puts "Ingrese la opcion deseada ..."
		  puts "Obtener Reporte de Mantenimiento (M) o Reporte de Costo (C)?. Para Regresar (X)"
		  

		  seleccion = gets.chomp.to_s
		  if seleccion != "m" && seleccion != "M" && seleccion != "c" && seleccion != "C" && seleccion != "x" && seleccion != "X"
		  	raise "ERROR. Ingrese una opción válida"
		  end
		
		return seleccion
	end
	def mostrarFormularioListarMantenimientos
		busqueda = []
		print "Ingrese Linea : " 
		linea = gets.chomp.to_s
		busqueda.push(linea)
		print "Ingrese Máquina o ingrese (all) para todas las Máquinas: "
		maquina = gets.chomp.to_s
		busqueda.push(maquina)
		return busqueda
	end
	def mostrarMenuListarMantenimientos
		seleccion = 0
		  system('cls')
		  puts "Sistema de Mantenimiento"
		  puts "========================"
		  puts "Listando Reportes ..."
		  puts "Ingrese la opcion deseada ..."
		  puts "Listar Reportes de Mantenimiento (M) o Reportes de Costo (C)?. Para Regresar (X)"

		  seleccion = gets.chomp.to_s
		  if seleccion != "m" && seleccion != "M" && seleccion != "c" && seleccion != "C" && seleccion != "x" && seleccion != "X"
		  	raise "ERROR. Ingrese una opción válida"
		  end
		return seleccion
	end
end
class VistaSalida
	def mostrarMensaje(mensaje)
      puts mensaje
    end
    def imprimirReporte(mantenimiento)
      datos = mantenimiento.obtenerDatos
      tecnicos = mantenimiento.obtenerTecnicos
      insumos = mantenimiento.obtenerInsumos
      tipoMantenimiento = mantenimiento.obtenerTipo
      puts "		************* Reporte de Mantenimiento **************"
      puts
      puts " Mantenimiento #{tipoMantenimiento}			Código: #{datos[0]}"
      puts " Línea : #{datos[1]}					Fecha : #{datos[4]}"
      puts " Máquina : #{datos[2]}				Dificultad : #{datos[6]}"
      puts " Duración :  #{datos[5]} horas"				
      if tipoMantenimiento == "Preventivo"
      	puts " Frecuencia : Cada #{datos[7]} días"
      elsif tipoMantenimiento == "Correctivo"
      	puts " Tipo de Falla : #{datos[7]}"
      end  
      puts
      puts "   Detalle :"
      puts "		#{datos[3]}"
      puts	"		" + "-" * 50
      puts "   Técnico(s) : "
      for tecnico in tecnicos
      	puts "		#{tecnico.nombre}"
      end
      puts "		" + "-" * 50
      puts "   Insumo(s) :"
      for insumo in insumos
      puts "		#{insumo.descripcion} : #{insumo.cantidad}#{insumo.unidad}"
      end
      puts "		" + "-" * 50 	                      
    end
    def imprimirCosto(mantenimiento)
    	datos = mantenimiento.obtenerDatos
    	tecnicos = mantenimiento.obtenerTecnicos
    	insumos = mantenimiento.obtenerInsumos
    	puts "		************* Reporte de Costos del Mantenimiento **************"
    	puts "Técnico(s)"
    	puts "=========="
	    for tecnico in tecnicos
	    	puts "Nombre : #{tecnico.nombre}"
	    	puts "Trabajo realizado : #{tecnico.trabajo}"
	    	if tecnico.obtenerTipo == "Externo"
	    		puts "Tarifa : #{tecnico.tarifa}"
	    		puts "Certificacion : #{tecnico.certificacion}"
	    	else
	    		puts "Sueldo : #{tecnico.sueldo}"
		    end
		    puts "Costo de trabajo : S/.#{tecnico.calcularTarifa * mantenimiento.duracion}"
		end
		puts "Costo Total de Mano de Obra : S/.#{mantenimiento.calcularCostoManodeObra}"
		puts
		puts "Insumo(s)"
    	puts "=========="
		for insumo in insumos
			puts "#{insumo.descripcion} : #{insumo.cantidad}#{insumo.unidad} ... Precio unit. : S/.#{insumo.precio}"
			if insumo.obtenerTipo == "Local"
				puts "Gasto de transporte : S/. #{insumo.gastoTransporte}"
			else
				puts "Costo de envío : #{insumo.costoEnvio}"
				puts "Impuestos : #{insumo.impuestos}"
			end
			puts "Costo de insumo : S/.#{insumo.calcularCosto}"
		end
		puts "Costo Total de Insumos : S/.#{mantenimiento.calcularCostoInsumos}"
		puts
		puts "**** Costo Total del Mantenimiento : S/.#{mantenimiento.calcularCostoTotal}"
	end
	def imprimirReportes(mantenimientos)
     	 puts "********** Listado de Reportes de Mantenimiento **********"
	     for mantenimiento in mantenimientos
	          imprimirReporte(mantenimiento)
	      end
    end
    def imprimirCostos(mantenimientos)
    	puts "********** Listado de Reportes de Costos de Mantenimiento **********"
    	for mantenimiento in mantenimientos
    		imprimirCosto(mantenimiento)
    	end
    end
end
class Controlador
	def initialize(vistaEntrada, vistaSalida, planner)
		@vistaEntrada = vistaEntrada
		@vistaSalida = vistaSalida
		@planner = planner
	end
	def ingresoMenuInicio
		while(eleccion != 9)

			begin
			eleccion = @vistaEntrada.mostrarMenuInicio
			rescue Exception => e
				@vistaSalida.mostrarMensaje(e.message)
				system('pause')
				return ingresoMenuInicio
			end
			
				case eleccion
				when 1
					mantenimiento = crearMantenimiento
					
					registrarTecnico(mantenimiento)
					registrarInsumo(mantenimiento)

					mensaje = @planner.registrarMantenimiento(mantenimiento)
					@vistaSalida.mostrarMensaje(mensaje)
									
				when 2
					codigo = @vistaEntrada.mostrarFormularioBuscarMantenimiento
					begin
						mantenimiento = @planner.buscarMantenimiento(codigo)
					rescue Exception => e
						@vistaSalida.mostrarMensaje(e.message)
					end
										
					imprimirMantenimiento(mantenimiento)
					
				
				when 3
					busqueda = @vistaEntrada.mostrarFormularioListarMantenimientos
					mantenimientos = filtrarMantenimientos(busqueda)
					imprimirMantenimientos(mantenimientos)
				end

		end
	end
	
			
	def crearMantenimiento
		begin
		tipo = @vistaEntrada.mostrarMenuMantenimiento
		rescue Exception => e
			@vistaSalida.mostrarMensaje(e.message)
			system('pause')
			return crearReporteMantenimiento	
		end
		case tipo
		when "P" , "p"
			datosMantenimiento = @vistaEntrada.mostrarFormularioPreventivo
			
			mantenimiento = FactoryMantenimiento.create(tipo, datosMantenimiento)
					
		when "C" , "c"
			datosMantenimiento = @vistaEntrada.mostrarFormularioCorrectivo
			
			mantenimiento = FactoryMantenimiento.create(tipo, datosMantenimiento)
			
		when "X" , "x"
			return ingresoMenuInicio
		end
		
		return mantenimiento

	end

	
	def registrarTecnico(mantenimiento)
		while(tipoTecnico != "x" && tipoTecnico != "X")
			begin
			tipoTecnico = @vistaEntrada.mostrarMenuTecnicos
			rescue Exception => e
				@vistaSalida.mostrarMensaje(e.message)
				system('pause')
				return registrarTecnico(mantenimiento) 	
			end
			
			case tipoTecnico
			when "I" , "i"
				datosTecnico = @vistaEntrada.mostrarFormularioInterno
				
				tecnico = FactoryTecnico.create(tipoTecnico, datosTecnico)
				mensaje = mantenimiento.registrarTecnico(tecnico)
				@vistaSalida.mostrarMensaje(mensaje)
				system('pause')
				return registrarTecnico(mantenimiento)
				
			when "E" , "e"
				datosTecnico = @vistaEntrada.mostrarFormularioExterno
				
				tecnico = FactoryTecnico.create(tipoTecnico, datosTecnico)
				mensaje = mantenimiento.registrarTecnico(tecnico)
				@vistaSalida.mostrarMensaje(mensaje)
				system('pause')
				return registrarTecnico(mantenimiento)
			end
		end
				
	end
	def registrarInsumo(mantenimiento)
		while (tipoInsumo != "x" && tipoInsumo != "X")
			begin
			tipoInsumo = @vistaEntrada.mostrarMenuInsumo
			rescue Exception => e
				@vistaSalida.mostrarMensaje(e.message)
				system('pause')
				return registrarInsumo(mantenimiento)	
			end

			case tipoInsumo
			when "L" , "l"
				datosInsumo = @vistaEntrada.mostrarFormularioLocal
				
				insumo = FactoryInsumo.create(tipoInsumo, datosInsumo)
				mensaje = mantenimiento.registrarInsumo(insumo)
				@vistaSalida.mostrarMensaje(mensaje)
				system('pause')
				return registrarInsumo(mantenimiento)
				
			when "I" , "i"
				datosInsumo = @vistaEntrada.mostrarFormularioImportado
				
				insumo = FactoryInsumo.create(tipoInsumo, datosInsumo)
				mensaje = mantenimiento.registrarInsumo(insumo)
				@vistaSalida.mostrarMensaje(mensaje)
				system('pause')
				return registrarInsumo(mantenimiento)
			end
		end
	end
	def imprimirMantenimiento(mantenimiento)
		begin
		opcion = @vistaEntrada.mostrarMenuBuscarMantenimiento
		rescue Exception => e
			@vistaSalida.mostrarMensaje(e.message)
			system('pause')
			return imprimirMantenimiento(codigo)
		end
		case opcion
		when "m" , "M"
			@vistaSalida.imprimirReporte(mantenimiento)
			system('pause')
			return ingresoMenuInicio
		when  "c" , "C"
			@vistaSalida.imprimirCosto(mantenimiento)
			system('pause')
			return ingresoMenuInicio
		when "x" , "X"
			return ingresoMenuInicio
		end
	end
	def filtrarMantenimientos(busqueda) 
		linea = busqueda[0]
		maquina = busqueda[1]
		if maquina =! "all"
			begin
			mantenimientos = @planner.buscarMantenimientosLineaMaquina(linea, maquina)
			rescue Exception => e
					@vistaSalida.mostrarMensaje(e.message)
					system('pause')
			return ingresoMenuInicio
			end
		elsif maquina == "all"
			begin
			mantenimientos = @planner.buscarMantenimientosLinea(linea)
			rescue Exception => e
				@vistaSalida.mostrarMensaje(e.message)
				system('pause')
			return ingresoMenuInicio
			end
		end
		return mantenimientos
	end
	def imprimirMantenimientos(mantenimientos)
		begin
		seleccion = @vistaEntrada.mostrarMenuListarMantenimientos
		rescue Exception => e
			@vistaSalida.mostrarMensaje(e.message)
			system('pause')
			return imprimirMantenimientos(mantenimientos)
		end
		case seleccion
		when "m" , "M"
			@vistaSalida.imprimirReportes(mantenimientos)
			system('pause')
			return ingresoMenuInicio
		when "c" , "C"
			@vistaSalida.imprimirCostos(mantenimientos)
			system('pause')
			return ingresoMenuInicio
		when "x" , "X"
			return ingresoMenuInicio
		end
	end
	
end

################## ####################

def guardar_archivo(nombre, informacion)
	  CSV.open(nombre, "ab") do |csv|
	    csv << informacion
	  end
end

def guardar(planner)
  guardar_mantenimientos(planner)
end

def guardar_mantenimientos(planner)
	
  for mantenimiento in planner.obtenerMantenimientos
    datosMantenimiento = mantenimiento.obtenerDatos()
    tipoMantenimiento = mantenimiento.obtenerTipo
    case tipoMantenimiento
    when "Preventivo"
    	guardar_archivo("mantenimientosPreventivos.csv", datosMantenimiento)
    when "Correctivo"
    	guardar_archivo("mantenimientosCorrectivos.csv", datosMantenimiento)
    end 	
    guardar_tecnicos(mantenimiento)
    guardar_insumos(mantenimiento)
  end
end

def guardar_tecnicos(mantenimiento)
  for tecnico in mantenimiento.obtenerTecnicos()
    datosTecnico = tecnico.obtenerDatos()
    tipoTecnico = tecnico.obtenerTipo()
    codigoMantenimiento = mantenimiento.codigo
    datos = [codigoMantenimiento] + datosTecnico
    case tipoTecnico
    when "Interno"
      guardar_archivo("tecnicosInternos.csv", datos)
    when "Externo"
      guardar_archivo("tecnicosExternos.csv", datos)
     end    
  end
end
def guardar_insumos(mantenimiento)
  for insumo in mantenimiento.obtenerInsumos()
    datosInsumo = insumo.obtenerDatos()
    tipoInsumo = insumo.obtenerTipo()
    codigoMantenimiento = mantenimiento.codigo
    datos = [codigoMantenimiento] + datosInsumo
    case tipoInsumo
    when "Local"
      guardar_archivo("insumosLocales.csv", datos)
    when "Importado"
      guardar_archivo("insumosImportados.csv", datos)
     end    
  end
end

def cargar(planner)
	  
  datos = CSV.read("mantenimientosPreventivos.csv")
  for preventivo in datos
    preventivo = Preventivo.new(preventivo[0], preventivo[1], preventivo[2], preventivo[3], preventivo[4], preventivo[5], preventivo[6], preventivo[7])
    begin
    	planner.registrarMantenimiento(preventivo)
    rescue Exception => e
    	puts e.message
    end
   
  end    
	  
  datos = CSV.read("mantenimientosCorrectivos.csv")
  for correctivo in datos
    correctivo = Correctivo.new(correctivo[0], correctivo[1], correctivo[2], correctivo[3], correctivo[4], correctivo[5], correctivo[6], correctivo[7])
    planner.registrarMantenimiento(correctivo)
  end

  datos = CSV.read("tecnicosInternos.csv")
  for interno in datos
    codigoMantenimiento = interno[0]
    interno = AutoCarrera.new(interno[1], interno[2], interno[3])
    planner.registrarTecnicoEnMantenimiento(codigoMantenimiento, interno)
  end

  datos = CSV.read("tecnicosExternos.csv")
  for externo in datos
    codigoMantenimiento = externo[0]
    externo = AutoCarrera.new(externo[1], externo[2], externo[3], externo[4])
    planner.registrarTecnicoEnMantenimiento(codigoMantenimiento, externo)
  end

  datos = CSV.read("insumosLocales.csv")
  for local in datos
    codigoMantenimiento = local[0]
    local = AutoTrabajo.new(local[1], local[2], local[3], local[4], local[5])
    planner.registrarInsumoEnMantenimiento(codigoMantenimiento, local)
  end
	  
  datos = CSV.read("insumosImportados.csv")
  for importado in datos
    codigoMantenimiento = importado[0]
    importado = AutoTrabajo.new(importado[1], importado[2], importado[3], importado[4], importado[5], importado[6])
    planner.registrarInsumoEnMantenimiento(codigoMantenimiento, importado)
  end
end
planner = Planner.new
vistaEntrada = VistaEntrada.new
vistaSalida = VistaSalida.new
controlador = Controlador.new(vistaEntrada, vistaSalida, planner)
cargar(planner)
controlador.ingresoMenuInicio
guardar(planner)



=begin
#### CREACION DE OBJETOS ######

planner 		= Planner.new

#PREVENTIVO (codigo, linea, maquina, detalle, fecha, duracion, dificultad, frecuencia)
#CORRECTIVO (codigo, linea, maquina, detalle, fecha, duracion, dificultad, tipoFalla)
mantenimiento1 		= FactoryMantenimiento.create("p",'001','B-26/1', 'Turbomezclador', 'Detalle de Mantenimiento', '14/09/20', 2, 2,4)
mantenimiento2		= FactoryMantenimiento.create("p",'002', 'B-19', 'Enfriadora', 'Detalle de Mantenimiento', '15/09/20', 2, 2,4)
mantenimiento3 		= FactoryMantenimiento.create("p",'003','B-26/2', 'Extrusora', 'Detalle de Mantenimiento', '16/09/20', 2, 2,4)
mantenimiento4 		= FactoryMantenimiento.create("c",'004','B-26/1', 'Transportador', 'Detalle de Mantenimiento', '17/09/20', 1, 2,3)
mantenimiento5 		= FactoryMantenimiento.create("c",'005','B-26/2', 'Zaranda', 'Detalle de Mantenimiento', '17/09/20', 1, 2,3)

mantenimientoERROR1 = FactoryMantenimiento.create("c",'005','B-26/2', 'Zaranda','Detalle de Mantenimiento', '17/09/20', 1, 2,3)

#INTERNO (nombre, trabajo, sueldo)
tecnico1 		= FactoryTecnico.create("i",'Jose Morales','Trabajo',30)
tecnicoERROR1 	= FactoryTecnico.create("i",'Jose Morales','T',10)

#LOCAL (descripcion, cantidad, unidad, precio, gastoTransporte)
insumo1 = FactoryInsumo.create("l",'Descripcion',3,2,12,34,56) 


### REGISTRO DE MANTENIMIENTOS(EXCEPCIONES PARA CAMPOS NULOS Y MANTENIMIENTOS YA REGISTRADOS)

# 1 --> REGISTRAR MANTENIMIENTOS 
begin
	puts planner.registrarMantenimiento(mantenimiento1)
rescue Exception => e
	puts e.message
end

begin
	puts planner.registrarMantenimiento(mantenimiento2)
rescue Exception => e
	puts e.message
end

begin
	puts planner.registrarMantenimiento(mantenimiento3)
rescue Exception => e
	puts e.message
end

begin
	puts planner.registrarMantenimiento(mantenimiento5)
rescue Exception => e
	puts e.message
end

begin
	puts planner.registrarMantenimiento(mantenimientoERROR1)
rescue Exception => e
	puts e.message
end

begin
	puts planner.registrarMantenimiento(mantenimiento4)
rescue Exception => e
	puts e.message
end


##### REGISTRO DE TÉCNICOS ####
# MANTENIMIENTO 1
puts
begin
	puts mantenimiento1.registrarTecnico(tecnico1)
rescue Exception => e
	puts e.message
end

begin
	puts mantenimiento1.registrarTecnico(tecnicoERROR1)
rescue Exception => e
	puts e.message
end


### REGISTRO INSUMOS ###
# MANTENIMIENTO 1
puts 
begin
	puts mantenimiento1.registrarInsumo(insumo1)
rescue Exception => e
	puts e.message
end
=end
