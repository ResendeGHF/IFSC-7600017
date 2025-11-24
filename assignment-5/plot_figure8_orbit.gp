# Script gnuplot para plotar a orbita Figure-8 de Moore
# Mostra o caminho completo das tres particulas

load 'spectral.pal'

set terminal pngcairo size 1200, 1200 enhanced font "Helvetica,14"
set output "plot-figure8-orbit-2-15457752.png"

set grid
set key top right
set xlabel "Posicao X"
set ylabel "Posicao Y"
set title "Orbita 'O Oito' (Figure-8) de Moore (1993)"
set datafile separator whitespace
set size ratio 1
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]

# Plotar as tres orbitas
plot "saida-2-15457752.out" using 2:3 with lines linestyle 1 lw 2 title "Particula 1", \
     "saida-2-15457752.out" using 6:7 with lines linestyle 2 lw 2 title "Particula 2", \
     "saida-2-15457752.out" using 10:11 with lines linestyle 3 lw 2 title "Particula 3"

