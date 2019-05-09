#enconding: UTF-8

require_relative "calle"

module ModeloQytetet
  class Tablero
    
    attr_reader :casillas
    attr_reader :carcel
    
    def initialize
       inicializar()
       
    end
    
    def inicializar 
      @casillas = Array.new
      
      @casillas << Casilla.new2(0, TipoCasilla::SALIDA)
      @casillas << Calle.new(1,500,TituloPropiedad.new("Calle Java", 500, 50, -0.2, 150, 250))
      @casillas << Calle.new(2,500,TituloPropiedad.new("Calle Python", 500, 55, -0.15, 200, 250))
      @casillas << Casilla.new2(3, TipoCasilla::SORPRESA)
      @casillas << Calle.new(4,550,TituloPropiedad.new("Calle C", 550, 60, -0.10, 250, 300))
      
      @carcel = Casilla.new2(5, TipoCasilla::CARCEL)
      
      @casillas << @carcel
      @casillas << Calle.new(6,600,TituloPropiedad.new("Calle C++", 600, 65, -0.05, 350, 350))      
      @casillas << Casilla.new(7, 250, TipoCasilla::IMPUESTO)      
      @casillas << Calle.new(8,650,TituloPropiedad.new("Calle Ruby", 650, 70,  0.0, 450, 400))      
      @casillas << Calle.new(9,700,TituloPropiedad.new("Calle JavaScript", 700, 75,  0.0, 550, 450))      
      @casillas << Casilla.new2(10, TipoCasilla::PARKING)      
      @casillas << Calle.new(11,750,TituloPropiedad.new("Calle XML", 750, 80, 0.0, 600, 500))      
      @casillas << Casilla.new2(12, TipoCasilla::SORPRESA)      
      @casillas << Calle.new(13,800,TituloPropiedad.new("Calle PHP", 800, 85, 0.05, 650, 550))     
      @casillas << Calle.new(14,850,TituloPropiedad.new("Calle SQL", 850, 90, 0.10, 750, 600))     
      @casillas << Casilla.new2(15, TipoCasilla::JUEZ)      
      @casillas << Calle.new(16,900,TituloPropiedad.new("Calle MATLAB", 900, 95,0.15, 850, 650))     
      @casillas << Calle.new(17,950,TituloPropiedad.new("Calle R", 950, 95,0.2, 950, 700))
      @casillas << Casilla.new2(18, TipoCasilla::SORPRESA)     
      @casillas << Calle.new(19,1000,TituloPropiedad.new("Calle Ensamblador", 1000, 100,0.2, 1000, 750))
    end  
      
    def   esCasillaCarcel(numeroCasilla)
      if (numeroCasilla == @carcel.numeroCasilla)
        return true
      else
        return false
      end
      
    end
    
    def obtenerCasillaFinal(casilla, desplazamiento)
      return @casillas[ ((casilla.numeroCasilla + desplazamiento) % 20) ]
    end
    
    def obtenerCasillaNumero(numeroCasilla)
      return @casillas[numeroCasilla]
    end
      
     
      
      def to_s
        #"Tablero: \n Casillas: #{@casillas} \n Carcel: #{@carcel}"  
        for casilla in @casillas
          puts "\n #{casilla.to_s}"
        end
      end
      
      
      private:inicializar
      
    
  end

end