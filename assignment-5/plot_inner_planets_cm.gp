# Script gnuplot para plotar planetas internos usando (0,0) como referencia

load 'spectral.pal'

set terminal pngcairo size 1200, 1200 enhanced font "Helvetica,12"
set output "plot-inner-planets-cm-a1-15457752.png"

set grid
set key right top
set xlabel "Posicao X (UA) - Referencia: Centro de Massa (0,0)"
set ylabel "Posicao Y (UA) - Referencia: Centro de Massa (0,0)"
set title "Orbitas dos Planetas Internos ao Redor do Centro de Massa"
set datafile separator whitespace
set size square
set xrange [-2:2]
set yrange [-2:2]

plot 0 with points pointtype 7 pointsize 3 lc rgb "black" title "Centro de Massa (0,0)", \
     "saida-a1-cm-15457752.out" using 2:3 with lines linestyle 10 lw 1.5 lc rgb "yellow" title "Sol", \
     "saida-a1-cm-15457752.out" using 5:6 with lines linestyle 1 lw 1.5 title "Mercurio", \
     "saida-a1-cm-15457752.out" using 9:10 with lines linestyle 2 lw 1.5 title "Venus", \
     "saida-a1-cm-15457752.out" using 13:14 with lines linestyle 3 lw 1.5 title "Terra", \
     "temp-cm-marte-15457752.out" using 17:18 with lines linestyle 4 lw 1.5 title "Marte"

