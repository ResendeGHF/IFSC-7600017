# Script gnuplot para plotar posicoes instantaneas em tempos selecionados
# Mostra a evolucao das posicoes das tres particulas em instantes especificos

load 'spectral.pal'

set terminal pngcairo size 1400, 1000 enhanced font "Helvetica,12"
set output "plot-figure8-instants-2-15457752.png"

set grid
set key top right
set xlabel "Posicao X"
set ylabel "Posicao Y"
set title "Evolucao das Posicoes Instantaneas - Solucao Figure-8 de Moore"
set datafile separator whitespace
set size ratio 1
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]

# Instantes de tempo selecionados: t = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
# Vamos criar um arquivo temporario com apenas esses instantes
# Primeiro, vamos extrair os dados nos instantes selecionados

# Plotar a orbita completa (linha fina cinza)
plot "saida-2-15457752.out" using 2:3 with lines linestyle 1 lw 1 lc rgb "gray80" title "Orbita Particula 1", \
     "saida-2-15457752.out" using 6:7 with lines linestyle 2 lw 1 lc rgb "gray80" title "Orbita Particula 2", \
     "saida-2-15457752.out" using 10:11 with lines linestyle 3 lw 1 lc rgb "gray80" title "Orbita Particula 3", \
     "saida-2-instants-15457752.out" using 2:3 with points pt 7 ps 2.5 lc rgb "red" title "Particula 1 (instantes)", \
     "saida-2-instants-15457752.out" using 6:7 with points pt 7 ps 2.5 lc rgb "blue" title "Particula 2 (instantes)", \
     "saida-2-instants-15457752.out" using 10:11 with points pt 7 ps 2.5 lc rgb "green" title "Particula 3 (instantes)"

