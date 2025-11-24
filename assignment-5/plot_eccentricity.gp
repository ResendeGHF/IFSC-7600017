# Script gnuplot para plotar excentricidades dos planetas
# Calcula excentricidade ao longo do tempo para cada planeta

load 'spectral.pal'

# Funcao para calcular excentricidade a partir de distancia minima e maxima
# Para cada planeta, precisamos calcular r_min e r_max ao longo do tempo

set terminal pngcairo size 1200, 800 enhanced font "Helvetica,12"
set output "plot-eccentricity-a1-15457752.png"

set grid
set key right top
set xlabel "Tempo (anos)"
set ylabel "Excentricidade"
set title "Excentricidade das Orbitas Planetarias ao Longo do Tempo"
set datafile separator whitespace

# Excentricidades calculadas (do script Python)
e_mercurio = 0.126859
e_venus = 0.066908
e_terra = 0.046789
e_marte = 0.029970
e_jupiter = 0.005057
e_saturno = 0.001179
e_urano = 0.000931
e_netuno = 0.000600
e_plutao = 0.000461

# Plotar excentricidades calculadas (precisaremos calcular antes)
# Por enquanto, vou criar um script que calcula e plota

plot "eccentricity-calc-a1-15457752.dat" using 1:2 with lines linestyle 1 title sprintf("Mercurio (e=%.3f)", e_mercurio), \
     "eccentricity-calc-a1-15457752.dat" using 1:3 with lines linestyle 2 title sprintf("Venus (e=%.3f)", e_venus), \
     "eccentricity-calc-a1-15457752.dat" using 1:4 with lines linestyle 3 title sprintf("Terra (e=%.3f)", e_terra), \
     "eccentricity-calc-a1-15457752.dat" using 1:5 with lines linestyle 4 title sprintf("Marte (e=%.3f)", e_marte), \
     "eccentricity-calc-a1-15457752.dat" using 1:6 with lines linestyle 5 title sprintf("Jupiter (e=%.3f)", e_jupiter), \
     "eccentricity-calc-a1-15457752.dat" using 1:7 with lines linestyle 6 title sprintf("Saturno (e=%.3f)", e_saturno), \
     "eccentricity-calc-a1-15457752.dat" using 1:8 with lines linestyle 7 title sprintf("Urano (e=%.3f)", e_urano), \
     "eccentricity-calc-a1-15457752.dat" using 1:9 with lines linestyle 8 title sprintf("Netuno (e=%.3f)", e_netuno), \
     "eccentricity-calc-a1-15457752.dat" using 1:10 with lines linestyle 9 title sprintf("Plutao (e=%.3f)", e_plutao)

