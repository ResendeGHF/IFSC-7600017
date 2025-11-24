# Script gnuplot para plotar planetas externos

load 'spectral.pal'

set terminal pngcairo size 1200, 1200 enhanced font "Helvetica,12"
set output "plot-outer-planets-a1-15457752.png"

set grid
set key right top
set xlabel "Posicao X (UA)"
set ylabel "Posicao Y (UA)"
set title "Orbitas dos Planetas Externos (Jupiter, Saturno, Urano, Netuno, Plutao)"
set datafile separator whitespace
set size square
set xrange [-45:45]
set yrange [-45:45]

plot "saida-a1-15457752.out" using 2:3 with points pointtype 7 pointsize 2 lc rgb "yellow" title "Sol", \
     "saida-a1-15457752.out" using 21:22 with lines linestyle 5 title "Jupiter", \
     "saida-a1-15457752.out" using 25:26 with lines linestyle 6 title "Saturno", \
     "saida-a1-15457752.out" using 29:30 with lines linestyle 7 title "Urano", \
     "saida-a1-15457752.out" using 33:34 with lines linestyle 8 title "Netuno", \
     "saida-a1-15457752.out" using 37:38 with lines linestyle 9 title "Plutao"

