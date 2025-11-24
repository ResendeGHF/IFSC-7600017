# Script gnuplot para plotar orbitas individuais usando (0,0) como referencia

load 'spectral.pal'

set terminal pngcairo size 1000, 1000 enhanced font "Helvetica,12"
set output output_file

set grid
set key right top
set xlabel "Posicao X (UA) - Referencia: Centro de Massa (0,0)"
set ylabel "Posicao Y (UA) - Referencia: Centro de Massa (0,0)"
set title sprintf("Orbita de %s ao Redor do Centro de Massa (e=%.4f)", planet_name, eccentricity)
set datafile separator whitespace
set size square

# Ajustar range baseado no planeta
if (planet_name eq "Mercurio" || planet_name eq "Venus" || planet_name eq "Terra" || planet_name eq "Marte") {
    set xrange [-2:2]
    set yrange [-2:2]
} else {
    if (planet_name eq "Jupiter" || planet_name eq "Saturno") {
        set xrange [-12:12]
        set yrange [-12:12]
    } else {
        set xrange [-45:45]
        set yrange [-45:45]
    }
}

# Plotar origem, Sol e orbita do planeta
plot 0 with points pointtype 7 pointsize 3 lc rgb "black" title "Centro de Massa (0,0)", \
     input_file using 2:3 with lines linestyle 10 lw 1.5 lc rgb "yellow" title "Sol", \
     input_file using x_col:y_col with lines linestyle 1 lw 2 title planet_name

