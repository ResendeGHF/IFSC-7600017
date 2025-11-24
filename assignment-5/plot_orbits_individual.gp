# Script gnuplot para plotar orbitas individuais de cada planeta
# Mostra cada planeta separadamente com sua excentricidade

load 'spectral.pal'

set terminal pngcairo size 800, 800 enhanced font "Helvetica,12"
set output output_file

set grid
set key right top
set xlabel "Posicao X (UA)"
set ylabel "Posicao Y (UA)"
set title sprintf("Orbita de %s (e=%.4f)", planet_name, eccentricity)
set datafile separator whitespace
set size square

# Plotar Sol no centro e orbita do planeta
plot "saida-a1-15457752.out" using 2:3 with points pointtype 7 pointsize 3 lc rgb "yellow" title "Sol", \
     input_file using x_col:y_col with lines linestyle 1 title planet_name

