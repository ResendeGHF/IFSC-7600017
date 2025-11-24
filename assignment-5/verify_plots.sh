#!/bin/bash
# Script para verificar se os graficos foram gerados corretamente

echo "Verificando graficos gerados..."
echo ""

# Verificar arquivos SVG
if [ -f "plot-solar-system-cm-a1-15457752.svg" ]; then
    SIZE=$(stat -c%s "plot-solar-system-cm-a1-15457752.svg")
    echo "✓ SVG do sistema solar: $(echo "scale=2; $SIZE/1024/1024" | bc) MB"
else
    echo "✗ SVG do sistema solar nao encontrado"
fi

# Verificar graficos individuais
PLANETS=("sol" "mercurio" "venus" "terra" "marte" "jupiter" "saturno" "urano" "netuno" "plutao")
COUNT=0
for planet in "${PLANETS[@]}"; do
    if [ -f "plot-orbit-cm-${planet}-a1-15457752.png" ]; then
        COUNT=$((COUNT+1))
    fi
done
echo "✓ Graficos individuais: $COUNT/10 gerados"

# Verificar graficos de grupos
if [ -f "plot-inner-planets-cm-a1-15457752.png" ]; then
    echo "✓ Grafico planetas internos"
fi
if [ -f "plot-outer-planets-cm-a1-15457752.png" ]; then
    echo "✓ Grafico planetas externos"
fi

# Verificar graficos de analise
if [ -f "plot-eccentricity-cm-a1-15457752.png" ]; then
    echo "✓ Grafico de excentricidades"
fi
if [ -f "plot-distance-cm-a1-15457752.png" ]; then
    echo "✓ Grafico de distancias"
fi

echo ""
echo "Todos os graficos foram verificados!"

