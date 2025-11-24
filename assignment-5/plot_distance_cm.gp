# Script gnuplot para plotar distancia ao centro de massa ao longo do tempo

load 'spectral.pal'

set terminal pngcairo size 1400, 900 enhanced font "Helvetica,12"
set output "plot-distance-cm-a1-15457752.png"

set grid
set key right top
set xlabel "Tempo (anos)"
set ylabel "Distancia ao Centro de Massa (UA)"
set title "Distancia dos Planetas ao Centro de Massa ao Longo do Tempo"
set datafile separator whitespace

# Calcular distancia ao CM para cada planeta
plot "saida-a1-cm-15457752.out" using 1:(sqrt(($5)**2 + ($6)**2)) with lines linestyle 1 lw 1.5 title "Mercurio", \
     "saida-a1-cm-15457752.out" using 1:(sqrt(($9)**2 + ($10)**2)) with lines linestyle 2 lw 1.5 title "Venus", \
     "saida-a1-cm-15457752.out" using 1:(sqrt(($13)**2 + ($14)**2)) with lines linestyle 3 lw 1.5 title "Terra", \
     "temp-cm-marte-15457752.out" using 1:(sqrt(($17)**2 + ($18)**2)) with lines linestyle 4 lw 1.5 title "Marte", \
     "temp-cm-jupiter-15457752.out" using 1:(sqrt(($21)**2 + ($22)**2)) with lines linestyle 5 lw 1.5 title "Jupiter", \
     "temp-cm-saturno-15457752.out" using 1:(sqrt(($25)**2 + ($26)**2)) with lines linestyle 6 lw 1.5 title "Saturno", \
     "temp-cm-urano-15457752.out" using 1:(sqrt(($29)**2 + ($30)**2)) with lines linestyle 7 lw 1.5 title "Urano", \
     "temp-cm-netuno-15457752.out" using 1:(sqrt(($33)**2 + ($34)**2)) with lines linestyle 8 lw 1.5 title "Netuno", \
     "temp-cm-plutao-15457752.out" using 1:(sqrt(($37)**2 + ($38)**2)) with lines linestyle 9 lw 1.5 title "Plutao"

