# Script gnuplot para plotar o sistema solar completo em SVG
# Formato do arquivo: tempo, (x,y,vx,vy) para cada corpo
# Corpos: 1=Sol, 2=Mercúrio, 3=Vênus, 4=Terra, 5=Marte, 6=Júpiter, 7=Saturno, 8=Urano, 9=Netuno, 10=Plutão

load 'spectral.pal'

# Configurar terminal SVG para zoom
set terminal svg size 1200,1200 enhanced font "Helvetica,12"
set output "plot-solar-system-a1-15457752.svg"

# Configurar grafico
set grid
set key outside right top
set xlabel "Posicao X (UA)"
set ylabel "Posicao Y (UA)"
set title "Sistema Solar - Orbitas dos Planetas ao Redor do Sol (1 ano)"
set datafile separator whitespace

# Ajustar escala para incluir todos os planetas
set xrange [-45:45]
set yrange [-45:45]
set size square

# Plotar Sol no centro
plot "saida-a1-15457752.out" using 2:3 with points pointtype 7 pointsize 2 lc rgb "yellow" title "Sol", \
     "saida-a1-15457752.out" using 5:6 with lines linestyle 1 title "Mercurio", \
     "saida-a1-15457752.out" using 9:10 with lines linestyle 2 title "Venus", \
     "saida-a1-15457752.out" using 13:14 with lines linestyle 3 title "Terra", \
     "saida-a1-15457752.out" using 17:18 with lines linestyle 4 title "Marte", \
     "saida-a1-15457752.out" using 21:22 with lines linestyle 5 title "Jupiter", \
     "saida-a1-15457752.out" using 25:26 with lines linestyle 6 title "Saturno", \
     "saida-a1-15457752.out" using 29:30 with lines linestyle 7 title "Urano", \
     "saida-a1-15457752.out" using 33:34 with lines linestyle 8 title "Netuno", \
     "saida-a1-15457752.out" using 37:38 with lines linestyle 9 title "Plutao"

