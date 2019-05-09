#enconding: UTF-8

require_relative 'titulo_propiedad'

module ModeloQytetet

  class Casilla
    attr_reader:numeroCasilla
    attr_reader:coste
    attr_reader:tipo

    def initialize(numeroCasilla, precioCompra, tipo)
      @numeroCasilla = numeroCasilla
      @coste = precioCompra
      @tipo = tipo
    end

    def self.new2(numeroCasilla, tipo)
      self.new(numeroCasilla,400 , tipo)
    end

    def propietarioEncarcelado
      return nil
    end

    def soyEdificable
      return false
    end

    def tengoPropietario
      return nil
    end

    def to_s
      if (@tipo == TipoCasilla::CALLE)
        " Numero casilla: #{@numeroCasilla}\n  #{@titulo.to_s} \n"
      else
        " Numero casilla: #{@numeroCasilla}  Tipo: #{@tipo}" + (@tipo == TipoCasilla::IMPUESTO ? "  Coste: #{@coste}" : "\n")
      end
    end
  end

end