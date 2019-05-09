#enconding: UTF-8

module ModeloQytetet
  class TituloPropiedad
    
    attr_reader :nombre
    attr_accessor :hipotecada
    attr_reader :precioCompra
    attr_reader :alquilerBase
    attr_reader :factorRevalorizacion
    attr_reader :hipotecaBase
    attr_reader :precioEdificar
    attr_reader :numHoteles
    attr_reader :numCasas
    attr_accessor :propietario
    
    
    def initialize(nombr,precioCompr, alquilerBas, factorRevalorizacio, 
                    hipotecaBas, precioEdifica)
      @nombre = nombr
      @hipotecada = false
      @precioCompra = precioCompr
      @alquilerBase = alquilerBas
      @factorRevalorizacion = factorRevalorizacio
      @hipotecaBase = hipotecaBas
      @precioEdificar = precioEdifica
      @numHoteles = 0
      @numCasas = 0
      @propietario = nil
    end
    
    def calcularCosteCancelar()
      coste = calcularCosteHipotecar()
        
      coste += (coste*0.1)
        
        return coste
    end
    
    def calcularCosteHipotecar()
     costeHipoteca = @hipotecaBase + @numCasas * 0.5 * @hipotecaBase
                            + @numHoteles * @hipotecaBase
        return costeHipoteca;
    end
    
    def calcularImporteAlquiler()
      costeAlquiler = (@alquilerBase + @precioEdificar * (@numCasas * 0.5 + @numHoteles*2))

        return costeAlquiler;
    end
    
    def calcularPrecioVenta()
        precioVenta = @precioCompra + (@numCasas + @numHoteles)*@precioEdificar *@factorRevalorizacion
        return precioVenta
    end
    
    def cancelarHipoteca()
      @hipotecada = false;
    end
    
    def cobrarAlquiler(coste)
      @propietario.modificarSaldo(-coste)
    end
    
    def edificarCasa()
      @numCasas +=1
    end
    
    def edificarHotel()
            @numHoteles +=1
            @numCasas -= 4
    end

    def hipotecar()
      @hipotecada = true
      costeHipoteca = calcularCosteHipotecar()
      return costeHipoteca;
    end
    
    def pagarAlquiler()
      costeAlquiler = calcularImporteAlquiler()
      @propietario.modificarSaldo(costeAlquiler)
        
      return costeAlquiler
    end
    
    def propietarioEncarcelado()
      return @propietario.encarcelado
    end
    
    def tengoPropietario()
      if( @propietario != nil)
        return true
      else
        return false
      end
    end
    
    def to_s
      if(tengoPropietario)
        return "Nombre: #{@nombre}  Propietario:  #{@propietario.nombre}  Hipotecada: #{@hipotecada}  Precio Compra: #{@precioCompra}  Num Casas #{@numCasas}  Num Hoteles #{@numHoteles} Alquiler Base: #{@alquilerBase}  Factor Revalorizacion: #{@factorRevalorizacion}  Hipoteca Base: #{@hipotecaBase}  Precio Edificar: #{@precioEdificar} \n"  
      else
        return "Nombre: #{@nombre}  Propietario:  #{@propietario}  Hipotecada: #{@hipotecada}  Precio Compra: #{@precioCompra}  Num Casas #{@numCasas}  Num Hoteles #{@numHoteles} Alquiler Base: #{@alquilerBase}  Factor Revalorizacion: #{@factorRevalorizacion}  Hipoteca Base: #{@hipotecaBase}  Precio Edificar: #{@precioEdificar} \n"  
      end
    end
  end
end