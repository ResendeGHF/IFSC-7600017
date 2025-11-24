# Script gnuplot para plotar orbita eliptica da Terra (item a2)

load 'spectral.pal'

set terminal pngcairo size 1000, 1000 enhanced font "Helvetica,12"
set output "plot-elliptical-orbit-a2-15457752.png"

set grid
set key right top
set xlabel "Posicao X (UA)"
set ylabel "Posicao Y (UA)"
set title "Orbita Eliptica da Terra (e=0.360)"
set datafile separator whitespace
set size square
set xrange [-1.2:1.2]
set yrange [-1.2:1.2]

# Arquivo a2 tem formato: tempo, (x,y,vx,vy) para Sol e Terra
# Sol: col 2, 3
# Terra: col 5, 6

plot "saida-a2-15457752.out" using 2:3 with points pointtype 7 pointsize 3 lc rgb "yellow" title "Sol", \
     "saida-a2-15457752.out" using 5:6 with lines linestyle 3 lw 2 title "Terra (orbita eliptica)"

