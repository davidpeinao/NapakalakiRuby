#enconding: UTF-8

module ModeloQytetet
  
  module TipoSorpresa

    #DEFINIMOS EL TIPO DE DATO ENUMERADO
    PAGARCOBRAR = :Pagar_cobrar
    IRACASILLA = :Ir_a_casilla
    PORCASAHOTEL = :Por_casa_hotel
    PORJUGADOR = :Por_jugador
    SALIRCARCEL = :Salir_carcel
    CONVERTIRME = :Convertirme

  #Para su uso: TipoSorpresa::PAGARCOBRAR o TipoSorpresa.const_get(PAGARCOBRAR) 
  end
end