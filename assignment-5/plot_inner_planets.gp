# Script gnuplot para plotar planetas internos (zoom)

load 'spectral.pal'

set terminal pngcairo size 1000, 1000 enhanced font "Helvetica,12"
set output "plot-inner-planets-a1-15457752.png"

set grid
set key right top
set xlabel "Posicao X (UA)"
set ylabel "Posicao Y (UA)"
set title "Orbitas dos Planetas Internos (Mercurio, Venus, Terra, Marte)"
set datafile separator whitespace
set size square
set xrange [-2:2]
set yrange [-2:2]

plot "saida-a1-15457752.out" using 2:3 with points pointtype 7 pointsize 3 lc rgb "yellow" title "Sol", \
     "saida-a1-15457752.out" using 5:6 with lines linestyle 1 title "Mercurio", \
     "saida-a1-15457752.out" using 9:10 with lines linestyle 2 title "Venus", \
     "saida-a1-15457752.out" using 13:14 with lines linestyle 3 title "Terra", \
     "saida-a1-15457752.out" using 17:18 with lines linestyle 4 title "Marte"

