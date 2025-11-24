# Script gnuplot para plotar a evolucao das posicoes em instantes selecionados
# Versao simplificada usando arquivos temporarios

load 'spectral.pal'

set terminal pngcairo size 1600, 1200 enhanced font "Helvetica,12"
set output "plot-figure8-evolution-2-15457752.png"

set multiplot layout 3,4 title "Evolucao das Posicoes Instantaneas - Solucao Figure-8 de Moore" font "Helvetica,16"

set grid
set size ratio 1
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]
set datafile separator whitespace

# Plotar para cada instante
do for [i=0:10] {
    set title sprintf("t = %.1f", i) font "Helvetica,12"
    set xlabel ""
    set ylabel ""
    
    # Plotar orbita completa (fina, cinza)
    plot "saida-2-15457752.out" using 2:3 with lines lw 0.5 lc rgb "gray90" notitle, \
         "saida-2-15457752.out" using 6:7 with lines lw 0.5 lc rgb "gray90" notitle, \
         "saida-2-15457752.out" using 10:11 with lines lw 0.5 lc rgb "gray90" notitle, \
         "saida-2-t".i."-15457752.out" using 2:3 with points pt 7 ps 3 lc rgb "red" title (i==0 ? "P1" : ""), \
         "saida-2-t".i."-15457752.out" using 6:7 with points pt 7 ps 3 lc rgb "blue" title (i==0 ? "P2" : ""), \
         "saida-2-t".i."-15457752.out" using 10:11 with points pt 7 ps 3 lc rgb "green" title (i==0 ? "P3" : "")
}

unset multiplot

