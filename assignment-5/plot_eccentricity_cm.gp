# Script gnuplot para plotar excentricidades dos planetas
# Usando dados convertidos para centro de massa

load 'spectral.pal'

set terminal pngcairo size 1400, 900 enhanced font "Helvetica,12"
set output "plot-eccentricity-cm-a1-15457752.png"

set grid
set key right top
set xlabel "Tempo (anos)"
set ylabel "Excentricidade"
set title "Excentricidade das Orbitas Planetarias (Referencia: Centro de Massa)"
set datafile separator whitespace

# Excentricidades calculadas
e_mercurio = 0.126859
e_venus = 0.066908
e_terra = 0.046789
e_marte = 0.029970
e_jupiter = 0.005057
e_saturno = 0.001179
e_urano = 0.000931
e_netuno = 0.000600
e_plutao = 0.000461

# Plotar excentricidades (constantes ao longo do tempo para orbitas circulares)
plot "eccentricity-calc-a1-15457752.dat" using 1:2 with lines linestyle 1 lw 2 title sprintf("Mercurio (e=%.4f)", e_mercurio), \
     "eccentricity-calc-a1-15457752.dat" using 1:3 with lines linestyle 2 lw 2 title sprintf("Venus (e=%.4f)", e_venus), \
     "eccentricity-calc-a1-15457752.dat" using 1:4 with lines linestyle 3 lw 2 title sprintf("Terra (e=%.4f)", e_terra), \
     "eccentricity-calc-a1-15457752.dat" using 1:5 with lines linestyle 4 lw 2 title sprintf("Marte (e=%.4f)", e_marte), \
     "eccentricity-calc-a1-15457752.dat" using 1:6 with lines linestyle 5 lw 2 title sprintf("Jupiter (e=%.4f)", e_jupiter), \
     "eccentricity-calc-a1-15457752.dat" using 1:7 with lines linestyle 6 lw 2 title sprintf("Saturno (e=%.4f)", e_saturno), \
     "eccentricity-calc-a1-15457752.dat" using 1:8 with lines linestyle 7 lw 2 title sprintf("Urano (e=%.4f)", e_urano), \
     "eccentricity-calc-a1-15457752.dat" using 1:9 with lines linestyle 8 lw 2 title sprintf("Netuno (e=%.4f)", e_netuno), \
     "eccentricity-calc-a1-15457752.dat" using 1:10 with lines linestyle 9 lw 2 title sprintf("Plutao (e=%.4f)", e_plutao)

