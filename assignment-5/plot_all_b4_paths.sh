#!/bin/bash
# Script para plotar todos os caminhos dos corpos vistos da Terra

BODIES=("sol" "mercurio" "venus" "terra" "marte" "jupiter" "saturno" "urano" "netuno" "plutao")

for body in "${BODIES[@]}"; do
    input_file="saida-b4-${body}-15457752.out"
    output_file="plot-b4-${body}-15457752.png"
    
    if [ -f "$input_file" ]; then
        gnuplot -e "input_file='$input_file'; output_file='$output_file'; body_name='${body^}'" plot_b4_paths.gp
        echo "Grafico gerado: $output_file"
    fi
done

