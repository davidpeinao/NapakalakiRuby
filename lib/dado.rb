#enconding: UTF-8

require "singleton"

module ModeloQytetet
  
  class Dado
    include Singleton
    attr_reader :valor

      
    def initialize
      @valor = -1
    end
    
    
    def tirar
      #rand(5)+1
      @valor = rand(1..6)
      return @valor
    end
    
    def to_s
      return "Dado{Valor: #{@valor} }"
    end
    
  end
end
