#!/bin/bash
# Script para gerar todos os graficos usando (0,0) como referencia

echo "Gerando graficos com referencia ao centro de massa (0,0)..."

# Gerar grafico SVG do sistema solar completo
gnuplot plot_solar_system_cm_svg.gp
echo "SVG do sistema solar completo gerado"

# Gerar graficos de planetas internos e externos
gnuplot plot_inner_planets_cm.gp
gnuplot plot_outer_planets_cm.gp
echo "Graficos de grupos de planetas gerados"

# Gerar graficos individuais para cada planeta
PLANETS=("Sol:saida-a1-cm-15457752.out:2:3:0.000000" \
         "Mercurio:saida-a1-cm-15457752.out:5:6:0.126859" \
         "Venus:saida-a1-cm-15457752.out:9:10:0.066908" \
         "Terra:saida-a1-cm-15457752.out:13:14:0.046789" \
         "Marte:temp-cm-marte-15457752.out:17:18:0.029970" \
         "Jupiter:temp-cm-jupiter-15457752.out:21:22:0.005057" \
         "Saturno:temp-cm-saturno-15457752.out:25:26:0.001179" \
         "Urano:temp-cm-urano-15457752.out:29:30:0.000931" \
         "Netuno:temp-cm-netuno-15457752.out:33:34:0.000600" \
         "Plutao:temp-cm-plutao-15457752.out:37:38:0.000461")

for planet_info in "${PLANETS[@]}"; do
    IFS=':' read -r name input_file x_col y_col ecc <<< "$planet_info"
    output_file="plot-orbit-cm-${name,,}-a1-15457752.png"
    
    gnuplot -e "input_file='$input_file'; output_file='$output_file'; planet_name='$name'; x_col=$x_col; y_col=$y_col; eccentricity=$ecc" plot_orbits_individual_cm.gp
    echo "Gerado: $output_file"
done

echo "Todos os graficos foram gerados com referencia ao centro de massa!"

