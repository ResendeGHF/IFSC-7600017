#!/bin/bash
# Script para gerar dados estendidos para planetas que nao completam orbita em 1 ano

# Periodos dos planetas (em anos) - baseado em kepler-a1-15457752.out
# Mercurio: 0.244 anos (completa em 1 ano)
# Venus: 0.611 anos (completa em 1 ano)
# Terra: 1.000 anos (completa em 1 ano)
# Marte: 1.874 anos (precisa ~2 anos)
# Jupiter: 11.858 anos (precisa ~12 anos)
# Saturno: 28.087 anos (precisa ~29 anos)
# Urano: 84.065 anos (precisa ~85 anos)
# Netuno: 164.810 anos (precisa ~165 anos)
# Plutao: 248.537 anos (precisa ~249 anos)

echo "Gerando dados estendidos para planetas externos..."

# Marte: ~2 anos
./build/tarefa-a1-extended-15457752.exe 2.0
mv saida-a1-extended-15457752.out temp-marte-15457752.out
echo "Marte: 2 anos completados"

# Jupiter: ~12 anos
./build/tarefa-a1-extended-15457752.exe 12.0
mv saida-a1-extended-15457752.out temp-jupiter-15457752.out
echo "Jupiter: 12 anos completados"

# Saturno: ~29 anos
./build/tarefa-a1-extended-15457752.exe 29.0
mv saida-a1-extended-15457752.out temp-saturno-15457752.out
echo "Saturno: 29 anos completados"

# Urano: ~85 anos
./build/tarefa-a1-extended-15457752.exe 85.0
mv saida-a1-extended-15457752.out temp-urano-15457752.out
echo "Urano: 85 anos completados"

# Netuno: ~165 anos
./build/tarefa-a1-extended-15457752.exe 165.0
mv saida-a1-extended-15457752.out temp-netuno-15457752.out
echo "Netuno: 165 anos completados"

# Plutao: ~249 anos
./build/tarefa-a1-extended-15457752.exe 249.0
mv saida-a1-extended-15457752.out temp-plutao-15457752.out
echo "Plutao: 249 anos completados"

echo "Todos os dados estendidos foram gerados!"

