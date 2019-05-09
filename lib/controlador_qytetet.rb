#enconding: UTF-8

require_relative "metodo_salir_carcel"
require_relative "estado_juego"
require_relative "qytetet"
require_relative "opcion_menu"
require "singleton"

module ControladorQytetet
  class ControladorQytetet
    include Singleton
    
    attr_accessor :nombreJugadores
       
    def initialize
      @nombreJugadores = Array.new
      @modelo = ModeloQytetet::Qytetet.instance
    end
    
    def obtenerOperacionesJuegoValidas()
      operacionesValidas = Array.new

      if(@modelo.jugadores.size == 0)
          operacionesValidas << (OpcionMenu.index(:INICIARJUEGO))
      else
        puts "----------------------------------------------------------------"
        puts "Jugador actual: #{@modelo.jugadorActual.nombre} \n"
          if(@modelo.estadoJuego == ModeloQytetet::EstadoJuego::ALGUNJUGADORENBANCARROTA)
              operacionesValidas << (OpcionMenu.index(:OBTENERRANKING))
          else
              if(@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_CONSORPRESA)
                  operacionesValidas << (OpcionMenu.index(:APLICARSORPRESA))
              else
                  if(@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_ENCARCELADO)
                      operacionesValidas << (OpcionMenu.index(:PASARTURNO))
                  else
                      if(@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD)
                          operacionesValidas << (OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD))
                          operacionesValidas << (OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO))
                      
                      else
                          if(@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_PREPARADO)
                              operacionesValidas << (OpcionMenu.index(:JUGAR))
                          else
                              if(@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_PUEDECOMPRAROGESTIONAR)
                                  operacionesValidas << (OpcionMenu.index(:PASARTURNO))
                                  operacionesValidas << (OpcionMenu.index(:COMPRARTITULOPROPIEDAD))
                                  operacionesValidas << (OpcionMenu.index(:VENDERPROPIEDAD))
                                  operacionesValidas << (OpcionMenu.index(:HIPOTECARPROPIEDAD))
                                  operacionesValidas << (OpcionMenu.index(:CANCELARHIPOTECA))
                                  operacionesValidas << (OpcionMenu.index(:EDIFICARCASA))
                                  operacionesValidas << (OpcionMenu.index(:EDIFICARHOTEL))      
                              
                              else
                                  if (@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_PUEDEGESTIONAR)
                                      operacionesValidas << (OpcionMenu.index(:PASARTURNO))
                                      operacionesValidas << (OpcionMenu.index(:VENDERPROPIEDAD))
                                      operacionesValidas << (OpcionMenu.index(:HIPOTECARPROPIEDAD))
                                      operacionesValidas << (OpcionMenu.index(:CANCELARHIPOTECA))
                                      operacionesValidas << (OpcionMenu.index(:EDIFICARCASA))
                                      operacionesValidas << (OpcionMenu.index(:EDIFICARHOTEL))
                                  end
                              end
                          end
                      end
                  end
              end
          end
          operacionesValidas << OpcionMenu.index(:TERMINARJUEGO)
          operacionesValidas << OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas << OpcionMenu.index(:MOSTRARTABLERO)
      end
      return operacionesValidas;
    end
    
    def necesitaElegirCasilla(opcionMenu)
      necesita = Array.new
      necesita << (OpcionMenu.index(:VENDERPROPIEDAD))
      necesita << (OpcionMenu.index(:HIPOTECARPROPIEDAD))
      necesita << (OpcionMenu.index(:CANCELARHIPOTECA))
      necesita << (OpcionMenu.index(:EDIFICARCASA))
      necesita << (OpcionMenu.index(:EDIFICARHOTEL))

      return necesita.include?(opcionMenu)
    end
    
    def obtenerCasillasValidas(opcionMenu)
      opcion = OpcionMenu[opcionMenu]
      casillasValidas = Array.new
      
      case opcion
      when :HIPOTECARPROPIEDAD
               casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
      when :CANCELARHIPOTECA
               casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true)
      when :EDIFICARCASA
               propiedades = @modelo.obtenerPropiedadesJugador()
               for i in propiedades
                   if (@modelo.jugadorActual.puedoEdificarCasa(@modelo.tablero.obtenerCasillaNumero(i).titulo))
                       casillasValidas << i
                   end
               end
      when :EDIFICARHOTEL
               propiedades = @modelo.obtenerPropiedadesJugador()
               for i in propiedades
                   if (@modelo.jugadorActual.puedoEdificarHotel(@modelo.tablero.obtenerCasillaNumero(i).titulo))
                       casillasValidas << i
                   end
               end
      when :VENDERPROPIEDAD
               casillasValidas = @modelo.obtenerPropiedadesJugador()
      end

      return casillasValidas
    end
    
    
    
    def realizarOperacion(opcionElegida, casillaElegida)
      opcion = OpcionMenu[opcionElegida]
      out = ""

        case opcion
          when :INICIARJUEGO
            @modelo.inicializarJuego(@nombreJugadores)
            out = "Juego iniciado" 
          when :APLICARSORPRESA
            out =@modelo.cartaActual.to_s
            @modelo.aplicarSorpresa()
          when :CANCELARHIPOTECA
            cancelada = @modelo.cancelarHipoteca(casillaElegida)
            if (cancelada)
              out = "Hipoteca cancelada"
            else
              out = "No se ha podido cancelar la hipoteca"
            end
          when :COMPRARTITULOPROPIEDAD
            comprado = @modelo.comprarTituloPropiedad()
              if (comprado)
                out = "Titulo comprado"
              else
                out = "No se ha podido comprar el titulo"
              end
          when :EDIFICARCASA
            casa_edificada = @modelo.edificarCasa(casillaElegida)
            if (casa_edificada)
              out = "Casa edificada"
            else 
              out = "Casa no edificada"
            end
          when :EDIFICARHOTEL
            hotel_edificado = @modelo.edificarHotel(casillaElegida)
            if (hotel_edificado)
              out = "Hotel edificado"
            else 
              out = "Hotel no edificado"
            end
          when :HIPOTECARPROPIEDAD
            if (@modelo.tablero.obtenerCasillaNumero(casillaElegida).titulo.hipotecada)
              out = "Propiedad ya estaba hipotecada"
            else 
              out = "Propiedad hipotecada"
              @modelo.hipotecarPropiedad(casillaElegida)
            end
          when :VENDERPROPIEDAD
            out = "Jugador actual ha vendido la propiedad: \n  #{@modelo.tablero.obtenerCasillaNumero(casillaElegida).to_s}"
            @modelo.venderPropiedad(casillaElegida)
          when :INTENTARSALIRCARCELPAGANDOLIBERTAD
            ha_salido = @modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::PAGANDOLIBERTAD)
            if (ha_salido)
              out = "Jugador actual ha salido de la carcel pagando su libertad"
            else 
              out = "Jugador actual no ha podido pagar su libertad"
            end
          when :INTENTARSALIRCARCELTIRANDODADO
            ha_salido_dado = @modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::TIRANDODADO)
            if (ha_salido_dado)
              out = "Jugador actual ha salido de la carcel tirando el dado"
            else 
              out = "Jugador actual no ha podido salir de la carcel tirando el dado"
             end
          when :JUGAR
            @modelo.jugar()
            out = "Jugador actual juega, ha caido en la casilla: #{@modelo.obtenerCasillaJugadorActual.to_s}\n"
          when :OBTENERRANKING
            puts "Ranking: "
            @modelo.obtenerRanking()
          when :PASARTURNO
            @modelo.siguienteJugador()
            out = "Se ha pasado el turno al siguiente jugador"
          when :TERMINARJUEGO
            puts "SE ACABA EL JUEGO"
            exit
          when :MOSTRARJUGADORACTUAL
            puts "Jugador actual: "
            puts @modelo.jugadorActual.to_s
          when :MOSTRARJUGADORES
            for j in @modelo.jugadores
              puts j.to_s
            end
          when :MOSTRARTABLERO
            puts "Tablero: "
            puts @modelo.tablero.to_s
        
        end

        return out;        
    end
    
    
    
    
  end
end
