#enconding: UTF-8

module ModeloQytetet
  class Sorpresa


    attr_accessor :texto
    attr_accessor :valor
    attr_accessor :tipo


    def initialize(text, value, type)
      @texto = text
      @valor = value
      @tipo = type
    end

    def to_s
      return "Texto: #{@texto} \n Valor: #{@valor} \n Tipo: #{@tipo}"
    end 


  end
end