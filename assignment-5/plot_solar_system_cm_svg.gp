# Script gnuplot para plotar o sistema solar completo em SVG
# Usando (0,0) como referencia (centro de massa)
# Formato do arquivo: tempo, (x,y,vx,vy) para cada corpo
# Corpos: 1=Sol, 2=Mercúrio, 3=Vênus, 4=Terra, 5=Marte, 6=Júpiter, 7=Saturno, 8=Urano, 9=Netuno, 10=Plutão

load 'spectral.pal'

# Configurar terminal SVG para zoom
set terminal svg size 1600,1600 enhanced font "Helvetica,12"
set output "plot-solar-system-cm-a1-15457752.svg"

# Configurar grafico
set grid
set key outside right top
set xlabel "Posicao X (UA) - Referencia: Centro de Massa (0,0)"
set ylabel "Posicao Y (UA) - Referencia: Centro de Massa (0,0)"
set title "Sistema Solar - Orbitas ao Redor do Centro de Massa"
set datafile separator whitespace

# Ajustar escala para incluir todos os planetas
set xrange [-45:45]
set yrange [-45:45]
set size square

# Plotar origem (centro de massa) e orbitas
plot 0 with points pointtype 7 pointsize 3 lc rgb "black" title "Centro de Massa (0,0)", \
     "saida-a1-cm-15457752.out" using 2:3 with lines linestyle 10 lw 1.5 lc rgb "yellow" title "Sol", \
     "saida-a1-cm-15457752.out" using 5:6 with lines linestyle 1 lw 1.5 title "Mercurio", \
     "saida-a1-cm-15457752.out" using 9:10 with lines linestyle 2 lw 1.5 title "Venus", \
     "saida-a1-cm-15457752.out" using 13:14 with lines linestyle 3 lw 1.5 title "Terra", \
     "temp-cm-marte-15457752.out" using 17:18 with lines linestyle 4 lw 1.5 title "Marte", \
     "temp-cm-jupiter-15457752.out" using 21:22 with lines linestyle 5 lw 1.5 title "Jupiter", \
     "temp-cm-saturno-15457752.out" using 25:26 with lines linestyle 6 lw 1.5 title "Saturno", \
     "temp-cm-urano-15457752.out" using 29:30 with lines linestyle 7 lw 1.5 title "Urano", \
     "temp-cm-netuno-15457752.out" using 33:34 with lines linestyle 8 lw 1.5 title "Netuno", \
     "temp-cm-plutao-15457752.out" using 37:38 with lines linestyle 9 lw 1.5 title "Plutao"

