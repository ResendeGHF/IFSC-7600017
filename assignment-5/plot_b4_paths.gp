# Script gnuplot para plotar caminhos vistos da Terra
# Carrega paleta espectral
load 'spectral.pal'

# Configura terminal
set terminal pngcairo size 800, 600 enhanced font "Helvetica,12"
set output output_file

# Configura grafico
set grid
set key right top
set xlabel "Posicao X (UA) - Visto da Terra"
set ylabel "Posicao Y (UA) - Visto da Terra"
set title "Caminho de ".body_name." visto da Terra (1 ano)"
set datafile separator whitespace

# Plota o caminho
plot input_file using 2:3 with linespoints linestyle 1 title body_name

