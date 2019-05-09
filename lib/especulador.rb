#enconding: UTF-8

module ModeloQytetet
  
  class Jugador
    
  end
  
  
  class Especulador < Jugador
    attr_accessor:fianza
    
    def self.copia(unJugador,fianza)
      especulador = super(unJugador)
      especulador.fianza = fianza
      
      return especulador
    end
    
    def pagarImpuesto
        modificarSaldo(-@casillaActual.coste/2)
    end
   
    def convertirme(fianza)
        @fianza = fianza
        return self
    end
    
    def deboIrACarcel
        return (super && !pagarFianza);
    end
    
    def pagarFianza
        pagada = false
        if (@fianza < saldo)
            pagada = true
            modificarSaldo(-@fianza)
        end
        
        return pagada;
            
    end
    

    def puedoEdificarCasa(titulo)
        return titulo.numCasas < 8
    end
    
  
    def puedoEdificarHotel(titulo)
        return titulo.numCasas >= 4 && titulo.numHoteles < 8
    end

    def to_s
        a_devolver = "Especulador: fianza = #{@fianza} "
        a_devolver += super;
        return a_devolver;
    end
    
    protected :deboIrACarcel

    private :pagarFianza
  end
end
