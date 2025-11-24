# Script gnuplot para plotar a evolucao das posicoes em instantes selecionados
# Mostra como cada particula se move em diferentes momentos

load 'spectral.pal'

set terminal pngcairo size 1600, 1200 enhanced font "Helvetica,12"
set output "plot-figure8-evolution-2-15457752.png"

set multiplot layout 3,4 title "Evolucao das Posicoes Instantaneas - Solucao Figure-8 de Moore" font "Helvetica,16"

set grid
set size ratio 1
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]
set datafile separator whitespace

# Instantes: t = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
times = "0 1 2 3 4 5 6 7 8 9 10"

do for [i=0:10] {
    t = i
    # Encontrar linha correspondente ao tempo t
    # DT = 0.001, entao linha = t/DT + 1 = t*1000 + 1
    line = t*1000 + 1
    
    set title sprintf("t = %.1f", t) font "Helvetica,12"
    set xlabel ""
    set ylabel ""
    
    # Plotar orbita completa (fina, cinza)
    plot "saida-2-15457752.out" using 2:3 with lines lw 0.5 lc rgb "gray90" notitle, \
         "saida-2-15457752.out" using 6:7 with lines lw 0.5 lc rgb "gray90" notitle, \
         "saida-2-15457752.out" using 10:11 with lines lw 0.5 lc rgb "gray90" notitle, \
         "< awk 'NR==".line."' saida-2-15457752.out" using 2:3 with points pt 7 ps 3 lc rgb "red" title "P1", \
         "< awk 'NR==".line."' saida-2-15457752.out" using 6:7 with points pt 7 ps 3 lc rgb "blue" title "P2", \
         "< awk 'NR==".line."' saida-2-15457752.out" using 10:11 with points pt 7 ps 3 lc rgb "green" title "P3"
}

unset multiplot

