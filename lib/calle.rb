#enconding: UTF-8

module ModeloQytetet
  class Calle < Casilla
    attr_accessor :titulo
    
    def initialize(numercasilla, precio, titu )
      @titulo = titu
      super(numercasilla,precio, TipoCasilla::CALLE)
    end
    
    def propietarioEncarcelado()
        return  @titulo.propietarioEncarcelado()
    end
    
    def asignarPropietario(jugador)
      @titulo.propietario = jugador
      return @titulo
    end
    
    def pagarAlquiler()
        costeAlquiler = @titulo.pagarAlquiler()
        return costeAlquiler
    end
    
    def soyEdificable()
        return true
    end
    
    def tengoPropietario()
        return @titulo.tengoPropietario
    end
    
    def to_s()
        ret = "\tTipo: Calle \n"
        ret += super()
            
        return ret;
    end
  end
end