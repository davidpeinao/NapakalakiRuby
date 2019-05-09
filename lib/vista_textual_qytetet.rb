#enconding: UTF-8

require_relative "controlador_qytetet"
require_relative "qytetet"
require_relative "opcion_menu"

module VistaTextualQytetet
  class VistaTextualQytetet
 
    @@controlador = ControladorQytetet::ControladorQytetet.instance
    
    def obtenerNombreJugadores
      n=0 
      loop do
        puts "Introduce el numero de jugadores: "
        n = gets.to_i
        break if (n >= 2 && n <= 4)
      end
      nombres = Array.new

      for i in 1..n
        puts "Introduce el nombre del jugador #{i} :\n"
        s = gets.chomp()
        nombres << s
      end

      return nombres
    end
    
    def elegirCasilla(opcionMenu)
      casillasValidas = @@controlador.obtenerCasillasValidas(opcionMenu)
       
      if (casillasValidas.size == 0)
        puts "No posee propiedades para realizar la accion\n"
        return -1
      else
        puts "Casillas Validas: \n"
            
            for i in casillasValidas
                puts "#{i}"
                puts ", "
            end
            
            stringValidos = Array.new
            
            for o in casillasValidas
                stringValidos << o.to_s;
            end
            
            
            valorCorrecto = leerValorCorrecto(stringValidos)
            return valorCorrecto.to_i
      end
    end
    
    def leerValorCorrecto(valoresCorrectos)
      pos = nil
        
      while pos == nil
            introducido = gets.to_i
            
            for i in 0..valoresCorrectos.size
              if (introducido == valoresCorrectos[i].to_i)
                pos = i
                break
              end  
            end
            
            if (pos == nil)
                puts "\nEl valor introducido no es correcto\n"
            end
      end
                
       return valoresCorrectos[pos]
    end
    
    def elegirOperacion()
        operacionesValidas = @@controlador.obtenerOperacionesJuegoValidas()
        stringValidos = Array.new()
        
        for o in operacionesValidas
            stringValidos << o.to_s
        end
        
       for i in stringValidos
        puts "#{i} #{ControladorQytetet::OpcionMenu[i.to_i]}"
       end
      
        valorCorrecto = leerValorCorrecto(stringValidos)
        
        
        return valorCorrecto.to_i
        
    end
    
def self.main
        ui = VistaTextualQytetet.new
        @@controlador.nombreJugadores = ui.obtenerNombreJugadores
        casillaElegida = 0;

        while (true)
            operacionElegida = ui.elegirOperacion
            necesitaElegirCasilla = @@controlador.necesitaElegirCasilla(operacionElegida)
            if (necesitaElegirCasilla)
                casillaElegida = ui.elegirCasilla(operacionElegida)
            end
            if (!necesitaElegirCasilla || casillaElegida >= 0)
                puts @@controlador.realizarOperacion(operacionElegida,casillaElegida)
            end
        end
end
  
VistaTextualQytetet.main
        
    
    
  end
end
