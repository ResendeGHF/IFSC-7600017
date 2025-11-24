#!/bin/bash
# Script para gerar todos os graficos de orbitas individuais

# Executar script Python para calcular excentricidades
python3 calc_eccentricity.py

# Gerar grafico SVG do sistema solar completo
gnuplot plot_solar_system_svg.gp

# Gerar grafico de excentricidades
gnuplot plot_eccentricity.gp

# Gerar graficos individuais para cada planeta
PLANETS=("Mercurio:5:6:0.206" "Venus:9:10:0.007" "Terra:13:14:0.017" "Marte:17:18:0.094" "Jupiter:21:22:0.049" "Saturno:25:26:0.057" "Urano:29:30:0.046" "Netuno:33:34:0.009" "Plutao:37:38:0.249")

for planet_info in "${PLANETS[@]}"; do
    IFS=':' read -r name x_col y_col ecc <<< "$planet_info"
    output_file="plot-orbit-${name,,}-a1-15457752.png"
    
    gnuplot -e "input_file='saida-a1-15457752.out'; output_file='$output_file'; planet_name='$name'; x_col=$x_col; y_col=$y_col; eccentricity=$ecc" plot_orbits_individual.gp
    echo "Gerado: $output_file"
done

echo "Todos os graficos foram gerados!"

