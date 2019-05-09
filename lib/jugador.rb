#enconding: UTF-8

require_relative "titulo_propiedad"
require_relative "casilla"
require_relative "tipo_casilla"
require_relative "especulador"


module ModeloQytetet
  class Jugador
    
    attr_accessor :cartaLibertad
    attr_accessor :casillaActual
    attr_accessor :encarcelado
    attr_reader :nombre
    attr_reader :propiedades
    attr_reader :saldo
    
    
    def initialize(encarcelado, nombre, saldo, carta, propiedades, casilla)
      @encarcelado=encarcelado
      @nombre=nombre
      @saldo=saldo
      @cartaLibertad=carta
      @propiedades=propiedades
      @casillaActual=casilla
    end
    
    def self.nuevo(nombre)
      self.new(false, nombre, 7500, nil, Array.new, Casilla.new2(0,TipoCasilla::SALIDA))
    end
 
    
    def self.copia(jugador)
      self.new(jugador.encarcelado, jugador.nombre, jugador.saldo, jugador.cartaLibertad, jugador.propiedades, jugador.casillaActual)
    end
    
    
    def convertirme(fianza)
      especulador = Especulador.copia(self,fianza)
      return especulador
    end
    
    def puedoEdificarCasa(titulo)
      return titulo.numCasas < 4
    end
    
    def puedoEdificarHotel(titulo)
      return titulo.numCasas == 4 && titulo.numHoteles < 4
    end
    
    def cancelarHipoteca(titulo)
      cancelada = false;

      if (@saldo >= titulo.calcularCosteCancelar())
        cancelada = true;
        @saldo -= titulo.calcularCosteCancelar()
        titulo.cancelarHipoteca()
      end

        return cancelada
    end
    
 def comprarTituloPropiedad
      comprado = false
      costeCompra = @casillaActual.coste

      if (costeCompra < @saldo)
          titulo = @casillaActual.asignarPropietario(self)
          comprado = true
          @propiedades << titulo
          modificarSaldo(-costeCompra)
      end

      return comprado
    end
     
    
    def cuantasCasasHotelesTengo
      numeroconstrucciones = 0
      
      for prop in @propiedades
          numeroconstrucciones += (prop.numCasas + prop.numHoteles)

      end
      
      return numeroconstrucciones
    end
    
    def deboPagarAlquiler
      esDeMiPropiedad = esDeMiPropiedad(@casillaActual.titulo)
      tienePropietario = false
      estaHipotecada = false
           
      if(!esDeMiPropiedad)
        tienePropietario = @casillaActual.tengoPropietario(); 
      end
      if(!esDeMiPropiedad && @casillaActual.tengoPropietario())
        @encarcelado = @casillaActual.propietarioEncarcelado();
      end
      if(!esDeMiPropiedad && tienePropietario && !@encarcelado)
        estaHipotecada = @casillaActual.titulo().hipotecada();
      end
            
      deboPagar = !esDeMiPropiedad & tienePropietario & !@encarcelado &
                  !estaHipotecada;
            
      return deboPagar;
    end
    
    def deboIrACarcel
      return !tengoCartaLibertad
    end
    
    
    def devolverCartaLibertad
      cLibertad = @cartaLibertad
      @cartaLibertad = nil
      return cLibertad
    end
    
    def edificarCasa(titulo)
      numCasas = titulo.numCasas
      edificada = false
            
      if(puedoEdificarCasa(titulo))
        costeEdificarCasa = titulo.precioEdificar
        tengoSaldo = tengoSaldo(costeEdificarCasa)

        if (tengoSaldo)
          titulo.edificarCasa
          
          modificarSaldo(-costeEdificarCasa)
          edificada = true
        end
      end
      return edificada
    end
    
    def edificarHotel(titulo)
      numHoteles = titulo.numHoteles()
      numCasas = titulo.numCasas()
      edificada = false

      if (puedoEdificarHotel(titulo))
        costeEdificarHotel = titulo.precioEdificar

        tengoSaldo = tengoSaldo(costeEdificarHotel)

        if (tengoSaldo)
          titulo.edificarHotel()
          modificarSaldo(-costeEdificarHotel)
          edificada = true
        end

        end

        return edificada;
    end
    
    def eliminarDeMisPropiedades(titulo)
      @propiedades.delete(titulo)
      titulo.propietario = nil
    end
    
    def esDeMiPropiedad(titulo)
      esdemipropiedad = false
      
      for prop in @propiedades
        if( prop.nombre == titulo.nombre )
          esdemipropiedad = true
        end
      end
      
      return esdemipropiedad
    end
    
    def estoyEnCalleLibre
      return !@casillaActual.tengoPropietario();
    end
    
    def hipotecarPropiedad(titulo)
      coste_hipoteca = titulo.hipotecar
      modificarSaldo(-coste_hipoteca)
    end
    
    def irACarcel(casilla)
      @casillaActual = casilla
      @encarcelado = true
    end
    
    def modificarSaldo(cantidad)
      @saldo += cantidad
      return @saldo
    end
    
    def obtenerCapital()
      cap = @saldo
        for propiedad in propiedades
          cap += propiedad.precioCompra + (propiedad.numCasas+propiedad.numHoteles)*propiedad.precioEdificar
          if(propiedad.hipotecada)
                    cap -= propiedad.hipotecaBase;
          end
        end
            return cap;
    end
    
    def obtenerPropiedades(hipotecada)
      hipotec =  Array.new
            
      for  titu in @propiedades
        if (titu.hipotecada == hipotecada)
          hipotec << titu
        end
      end         
      return hipotec
    end
    
    def pagarAlquiler
      costeAlquiler = @casillaActual.pagarAlquiler()
      modificarSaldo(-costeAlquiler)
    end
    
    def pagarImpuesto
        modificarSaldo(-@casillaActual.coste)
    end
    
    def pagarLibertad(cantidad)
      tengoSaldo = tengoSaldo(cantidad);
        if(tengoSaldo)
          @encarcelado = false;
          modificarSaldo(-cantidad);
        end
    end
    
    def tengoCartaLibertad()
      if( @cartaLibertad != nil )
        return true
      else
        return false
      end
    end
    
    def tengoSaldo(cantidad)
      if( @saldo >= cantidad )
        return true
      else
        return false
      end
    end
    
    def venderPropiedad(casilla)
      titulo = casilla.titulo
      eliminarDeMisPropiedades(titulo);
      precioVenta = titulo.calcularPrecioVenta();
      modificarSaldo(precioVenta);
      
    end
    
    def <=>(otroJugador)
      otroCapital= otroJugador.obtenerCapital
      miCapital=obtenerCapital
      if (otroCapital>miCapital) 
        return 1
      end
      if (otroCapital<miCapital) 
        return -1
      end
      return 0
    end

    
    
    def to_s
      out = "\n Nombre: #{@nombre} - Encarcelado: #{@encarcelado} - Saldo: #{@saldo} - Carta Liberdad: #{@carta_libertad}  - Casilla actual: #{@casillaActual.to_s}\n Propiedades: \n} "
      for p in propiedades
        out += p.to_s 
        out += "\n"
      end
      return out
    end
    
    private:eliminarDeMisPropiedades,
           :esDeMiPropiedad,
           :tengoSaldo

    protected :tengoSaldo
  end
end
