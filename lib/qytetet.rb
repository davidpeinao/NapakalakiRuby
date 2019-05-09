#enconding: utf-8

require_relative "dado"
require_relative "jugador"
require_relative "tablero"
require_relative "tipo_sorpresa"
require_relative "sorpresa"
require "singleton"

module ModeloQytetet
  class Qytetet
    
    include Singleton

    attr_accessor :mazo
    attr_reader :tablero
    attr_accessor :cartaActual
    attr_reader :dado
    attr_reader :jugadorActual
    attr_reader :jugadores
    attr_accessor :estadoJuego
    attr_reader :MAX_JUGADORES 
    
    @@MAX_JUGADORES = 4
    @@NUM_SORPRESAS = 10
    @@NUM_CASILLAS = 20
    @@PRECIO_LIBERTAD = 200
    @@SALDO_SALIDA = 1000
    
    def initialize
      @mazo = Array.new
      @tablero = nil
      @cartaActual = nil
      @dado = Dado.instance
      @jugadorActual = nil
      @jugadores = Array.new()
      @estadoJuego = nil
    end

    def inicializarCartasSorpresa

      # CARCEL: casilla nº5
      @mazo << Sorpresa.new("Te conviertes en especulador", 3000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("Te han pillado, al trullo", 5, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Descubres magicamente el teletransporte y apareces en la casilla 7", 7, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Hace mucho viento, tanto que te lleva hasta la casilla 19", 19, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Tienes suerte, con esta carta podras salir de la carcel" , 0, TipoSorpresa::SALIRCARCEL)
      @mazo << Sorpresa.new("Estas de suerte, te llevas 450e", 450, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Un etniano te ha pedido un leuro premoh, como no te has ido del lugar, te ha quitado el leuro y 299 mas", -300, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Te conviertes en Montoro, cada jugador te tiene que pagar 125e", 125, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Te conviertes en especulador", 5000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("Moroso, le debias 50e a cada jugador y no me lo has dicho, ahora pagas el doble", -100, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("El IBI ha subido, paga 20e por cada casa y hotel que tengas" , -20, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Tus propiedades se confunden con unas de la Iglesia, asi que no pagas IBI, recibe 15e por cada casa y hotel que tengas", 15, TipoSorpresa::PORCASAHOTEL)
      @mazo = @mazo.shuffle
    end

    #METODO INICIALIZADOR DE TABLERO
    def inicializarTablero
      @tablero = Tablero.new
    end
    
    def actuarSiEnCasillaEdificable()
      deboPagar = @jugadorActual.deboPagarAlquiler();
        
        if(deboPagar)
            @jugadorActual.pagarAlquiler()
            
            if(@jugadorActual.saldo() <= 0)
                @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
            end
        end
        
        casilla = obtenerCasillaJugadorActual()
        
        tengoPropietario = casilla.tengoPropietario()
        
        if(@estadoJuego != EstadoJuego::ALGUNJUGADORENBANCARROTA)
            if(tengoPropietario)
              @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
            else
                @estadoJuego = EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
            end
            
        end
    end
    
    def actuarSiEnCasillaNoEdificable()
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR;
      casillaActual = @jugadorActual.casillaActual
        
        if(casillaActual.tipo == TipoCasilla::IMPUESTO)
            @jugadorActual.pagarImpuesto()
        else
            if(casillaActual.tipo == TipoCasilla::JUEZ)
                encarcelarJugador()
            else
                if(casillaActual.tipo == TipoCasilla::SORPRESA)
                    @cartaActual = @mazo.shift
                    @estadoJuego = EstadoJuego::JA_CONSORPRESA
                end
            end
        end
    end
    
def aplicarSorpresa
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
        
      if (@cartaActual.tipo == TipoSorpresa::SALIRCARCEL)
          @jugadorActual.cartaLibertad = @cartaActual
      else
          @mazo << @cartaActual

          if (@cartaActual.tipo == TipoSorpresa::PAGARCOBRAR)
              @jugadorActual.modificarSaldo(@cartaActual.valor)
              if (@jugadorActual.saldo < 0)
                  @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
          else
              if (@cartaActual.tipo == TipoSorpresa::IRACASILLA)
                  valor = @cartaActual.valor
                  casillaCarcel = @tablero.esCasillaCarcel(valor)

                  if (casillaCarcel)
                      encarcelarJugador()
                  else
                      mover(valor)
                  end
              else
                  if (@cartaActual.tipo == TipoSorpresa::PORCASAHOTEL)
                      cantidad = @cartaActual.valor

                      numeroTotal = @jugadorActual.cuantasCasasHotelesTengo()
                      @jugadorActual.modificarSaldo(cantidad*numeroTotal)

                      if (@jugadorActual.saldo < 0)
                          @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
                      end
                  else
                      if (@cartaActual.tipo == TipoSorpresa::PORJUGADOR)
                          for j in @jugadores
                              if (j != @jugadorActual)
                                  j.modificarSaldo(-@cartaActual.valor)
                                  if (j.saldo < 0)
                                      @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
                                  end

                                  @jugadorActual.modificarSaldo(@cartaActual.valor)

                                  if (@jugadorActual.saldo < 0)
                                      @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
                                  end
                              end
                          end
                      else
                        if (@cartaActual.tipo == TipoSorpresa::CONVERTIRME)
                          especulador = @jugadorActual.convertirme(@cartaActual.valor)
                         
                          num = 0
                          i = 0
                                
                          for j in @jugadores
                              if (j == @jugadorActual)
                                  num = i
                              end
                              
                              i += 1
                          end

                          @jugadores[num] = especulador
                          @jugadorActual = especulador; 
                       end
                      end
                      
                  end
              end
          end
      end
    end
    
    def cancelarHipoteca(numeroCasilla)
      cancelada = @jugadorActual.cancelarHipoteca(@jugadorActual.casillaActual().titulo())
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR

      return cancelada
    end
    
    def comprarTituloPropiedad()
      comprado = @jugadorActual.comprarTituloPropiedad();

      if(comprado == true)
       @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR;
      end
        
        return comprado;
    end
    
    def edificarCasa(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo()
      
      edificada = @jugadorActual.edificarCasa(titulo)
        
      if(edificada == true)
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      return edificada
    end
    
    def edificarHotel(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo()

      edificada = @jugadorActual.edificarHotel(titulo)

      if (edificada)
         @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end

        return edificada
    end
    
    def encarcelarJugador()
      if(@jugadorActual.deboIrACarcel)
        casillaCarcel = @tablero.carcel
        @jugadorActual.irACarcel(casillaCarcel)
        @estadoJuego = EstadoJuego::JA_ENCARCELADO
      else
        carta = @jugadorActual.devolverCartaLibertad()
        @mazo << carta
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
    end
    
    def getValorDado()
      return @dado.valor
    end
    
    def hipotecarPropiedad(numeroCasilla)
        casilla = @tablero.obtenerCasillaNumero(numeroCasilla);
        titulo = casilla.titulo
        @jugadorActual.hipotecarPropiedad(titulo)
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
    end
    
    def inicializarJuego(nombres)
      inicializarJugadores(nombres)
      inicializarTablero
      inicializarCartasSorpresa
      salidaJugadores()
      @cartaActual = @mazo[0]
    end
    
    def inicializarJugadores(nombres)
      @jugadores = Array.new
      
      for nom in nombres
        @jugadores << Jugador.nuevo(nom)
      end
    end
    
    def intentarSalirCarcel(metodo)
      if(metodo == MetodoSalirCarcel::TIRANDODADO)
        resultado = tirarDado()
            
        if(resultado >= 5)
          @jugadorActual.encarcelado = false
        end
      else
        if(metodo == MetodoSalirCarcel::PAGANDOLIBERTAD)
          @jugadorActual.pagarLibertad(@@PRECIO_LIBERTAD)
        end
      end
      
      libre = @jugadorActual.encarcelado()
        
      if(libre)
        @estadoJuego = EstadoJuego::JA_ENCARCELADO
      else
        @estadoJuego = EstadoJuego::JA_PREPARADO
      end
      return !libre
    end
    
    def jugar()
      tirarDado
      cas = @tablero.obtenerCasillaFinal(@jugadorActual.casillaActual, @dado.valor)
      mover(cas.numeroCasilla)
    end
    
    def jugadorActualEnCalleLibre()
      #if (@jugadorActual.casillaActual.soyEdificable && !@jugadorActual.casillaActual.tengoPropietario)
      if( @jugadorActual.casillaActual.tipo == TipoCasilla::CALLE &&
            @jugadorActual.casillaActual.titulo.propietario == nil )
        return true
      else
        return false
      end
    end
    
    def jugadorActualEncarcelado
      return @jugadorActual.encarcelado
    end

    def mover(numCasillaDestino)
      casillaInicial = @jugadorActual.casillaActual
      casillaFinal = @tablero.obtenerCasillaNumero(numCasillaDestino)
    
      @jugadorActual.casillaActual = casillaFinal
        
      if(numCasillaDestino < casillaInicial.numeroCasilla)
        @jugadorActual.modificarSaldo(@@SALDO_SALIDA);
      end
        
      if(casillaFinal.soyEdificable())
            actuarSiEnCasillaEdificable()
        else
            actuarSiEnCasillaNoEdificable()
      end
    end
    
    def obtenerCasillaJugadorActual()
      return @jugadorActual.casillaActual
    end
    
    def obtenerCasillasTablero()
      return @tablero.casillas
    end
    
    def obtenerPropiedadesJugador()
      props = Array.new
      posiciones = Array.new
      
      props = @jugadorActual.propiedades
      
      for c in @tablero.casillas
        for p in props
          if (c.tipo == TipoCasilla::CALLE)
            if (c.titulo.nombre == p.nombre)
              posiciones << c.numeroCasilla
            end
          end
        end
      end
      
      return posiciones
    end
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoHipoteca)
      props = Array.new
      posiciones = Array.new
      
      props = @jugadorActual.propiedades
      
      for c in @tablero.casillas
        for p in props
          if (c.tipo == TipoCasilla::CALLE)
            if (c.titulo.nombre == p.nombre)
              if (p.hipotecada == estadoHipoteca)
                posiciones << c.numeroCasilla
              end
            end
          end
        end
      end
      
      return posiciones
    end
    
    def obtenerRanking()
      @jugadores = @jugadores.sort
    end
    
    def obtenerSaldoJugadorActual()
      return @jugadorActual.saldo
    end
    
    def salidaJugadores()
      for jug in @jugadores
        jug.casillaActual = @tablero.casillas[0]
      end
      
      tam = @jugadores.size - 1
      
      @jugadorActual = @jugadores[ rand( 0..tam ) ]
      @estadoJuego = EstadoJuego::JA_PREPARADO
    end
    
    def siguienteJugador()
      encontrado = false
      
      @jugadores.each_with_index do |jug,indice|
        if( jug == @jugadorActual && !encontrado)
          @jugadorActual = @jugadores[ (indice + 1) % @jugadores.length ]
          encontrado = true
        end
      end
      
      if (@jugadorActual.encarcelado)
        @estadoJuego = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        @estadoJuego = EstadoJuego::JA_PREPARADO
      end
    end
    
    def tirarDado()
      @dado.tirar
    end
    
    def venderPropiedad(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      @jugadorActual.venderPropiedad(casilla)
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
    end
    
    def to_s()
        ret = "Qytetet{ 
->MAX_JUGADORES: #{@@MAX_JUGADORES}, 
->NUM_SORPRESAS: #{@@NUM_SORPRESAS}, 
->NUM_CASILLAS:  #{@@NUM_CASILLAS}, 
->PRECIO_LIBERTAD: #{@@PRECIO_LIBERTAD}, 
->SALDO_SALIDA: #{@@SALDO_SALIDA}, 
->jugadorActual:  #{@jugadorActual.to_s()}, 
->cartaActual:  #{@cartaActual.to_s}, 
->dado:  #{@dado.to_s}, 
->tablero: #{@tablero.to_s} }";
    
        ret += "\n\n->Jugadores: "
        
        for jug in @jugadores
          ret +=jug.to_s
          ret += "\n"
        end
        
        ret += "->Mazo: "
        
        for car in mazo
          ret += car.to_s
          ret += "\n"
        end
        
      return ret
    end
    
    
    private:encarcelarJugador
    private:inicializarCartasSorpresa
    private:inicializarJugadores
    private:inicializarTablero
    private:salidaJugadores
    
    
  end
end