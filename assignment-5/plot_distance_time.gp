# Script gnuplot para plotar distancia ao Sol ao longo do tempo

load 'spectral.pal'

set terminal pngcairo size 1200, 800 enhanced font "Helvetica,12"
set output "plot-distance-time-a1-15457752.png"

set grid
set key right top
set xlabel "Tempo (anos)"
set ylabel "Distancia ao Sol (UA)"
set title "Distancia dos Planetas ao Sol ao Longo do Tempo"
set datafile separator whitespace

# Calcular distancia ao Sol para cada planeta
# Sol está em (col 2, col 3)
# Planetas: Mercúrio (5,6), Vênus (9,10), Terra (13,14), etc.

plot "saida-a1-15457752.out" using 1:(sqrt(($5-$2)**2 + ($6-$3)**2)) with lines linestyle 1 title "Mercurio", \
     "saida-a1-15457752.out" using 1:(sqrt(($9-$2)**2 + ($10-$3)**2)) with lines linestyle 2 title "Venus", \
     "saida-a1-15457752.out" using 1:(sqrt(($13-$2)**2 + ($14-$3)**2)) with lines linestyle 3 title "Terra", \
     "saida-a1-15457752.out" using 1:(sqrt(($17-$2)**2 + ($18-$3)**2)) with lines linestyle 4 title "Marte", \
     "saida-a1-15457752.out" using 1:(sqrt(($21-$2)**2 + ($22-$3)**2)) with lines linestyle 5 title "Jupiter", \
     "saida-a1-15457752.out" using 1:(sqrt(($25-$2)**2 + ($26-$3)**2)) with lines linestyle 6 title "Saturno", \
     "saida-a1-15457752.out" using 1:(sqrt(($29-$2)**2 + ($30-$3)**2)) with lines linestyle 7 title "Urano", \
     "saida-a1-15457752.out" using 1:(sqrt(($33-$2)**2 + ($34-$3)**2)) with lines linestyle 8 title "Netuno", \
     "saida-a1-15457752.out" using 1:(sqrt(($37-$2)**2 + ($38-$3)**2)) with lines linestyle 9 title "Plutao"

