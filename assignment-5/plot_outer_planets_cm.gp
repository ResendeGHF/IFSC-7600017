# Script gnuplot para plotar planetas externos usando (0,0) como referencia

load 'spectral.pal'

set terminal pngcairo size 1400, 1400 enhanced font "Helvetica,12"
set output "plot-outer-planets-cm-a1-15457752.png"

set grid
set key right top
set xlabel "Posicao X (UA) - Referencia: Centro de Massa (0,0)"
set ylabel "Posicao Y (UA) - Referencia: Centro de Massa (0,0)"
set title "Orbitas dos Planetas Externos ao Redor do Centro de Massa"
set datafile separator whitespace
set size square
set xrange [-45:45]
set yrange [-45:45]

plot 0 with points pointtype 7 pointsize 2 lc rgb "black" title "Centro de Massa (0,0)", \
     "temp-cm-jupiter-15457752.out" using 2:3 with lines linestyle 10 lw 1.5 lc rgb "yellow" title "Sol", \
     "temp-cm-jupiter-15457752.out" using 21:22 with lines linestyle 5 lw 1.5 title "Jupiter", \
     "temp-cm-saturno-15457752.out" using 25:26 with lines linestyle 6 lw 1.5 title "Saturno", \
     "temp-cm-urano-15457752.out" using 29:30 with lines linestyle 7 lw 1.5 title "Urano", \
     "temp-cm-netuno-15457752.out" using 33:34 with lines linestyle 8 lw 1.5 title "Netuno", \
     "temp-cm-plutao-15457752.out" using 37:38 with lines linestyle 9 lw 1.5 title "Plutao"

