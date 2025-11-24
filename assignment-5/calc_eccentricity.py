#!/usr/bin/env python3
# Script para calcular excentricidades dos planetas a partir dos dados de saida-a1

import numpy as np

# Ler arquivo de saida
data = np.loadtxt('saida-a1-15457752.out')

# Colunas: tempo, (x,y,vx,vy) para cada corpo
# Corpos: 1=Sol, 2=Mercúrio, 3=Vênus, 4=Terra, 5=Marte, 6=Júpiter, 7=Saturno, 8=Urano, 9=Netuno, 10=Plutão

# Indices das colunas para cada planeta (x, y)
# Sol: col 2, 3
# Mercúrio: col 5, 6
# Vênus: col 9, 10
# Terra: col 13, 14
# Marte: col 17, 18
# Júpiter: col 21, 22
# Saturno: col 25, 26
# Urano: col 29, 30
# Netuno: col 33, 34
# Plutão: col 37, 38

planet_cols = {
    'Mercurio': (5, 6),
    'Venus': (9, 10),
    'Terra': (13, 14),
    'Marte': (17, 18),
    'Jupiter': (21, 22),
    'Saturno': (25, 26),
    'Urano': (29, 30),
    'Netuno': (33, 34),
    'Plutao': (37, 38)
}

# Sol está na origem (col 2, 3)
sun_x_col = 2
sun_y_col = 3

# Calcular distância de cada planeta ao Sol ao longo do tempo
time = data[:, 0]
sun_x = data[:, sun_x_col]
sun_y = data[:, sun_y_col]

# Arquivo de saída
output = open('eccentricity-calc-a1-15457752.dat', 'w')

# Para cada planeta, calcular distância ao Sol e depois excentricidade
eccentricities = {}

for planet_name, (x_col, y_col) in planet_cols.items():
    planet_x = data[:, x_col]
    planet_y = data[:, y_col]
    
    # Distância ao Sol
    dist = np.sqrt((planet_x - sun_x)**2 + (planet_y - sun_y)**2)
    
    # Calcular r_min e r_max
    r_min = np.min(dist)
    r_max = np.max(dist)
    
    # Semi-eixo maior: a = (r_min + r_max) / 2
    a = (r_min + r_max) / 2.0
    
    # Semi-eixo menor: b = sqrt(r_min * r_max)
    b = np.sqrt(r_min * r_max)
    
    # Excentricidade: e = sqrt(1 - (b/a)^2)
    if a > 0:
        e = np.sqrt(1 - (b/a)**2)
    else:
        e = 0.0
    
    eccentricities[planet_name] = e
    
    # Calcular excentricidade instantânea (aproximação)
    # e_inst = sqrt(1 - (r_min*r_max)/(a^2)) onde a é calculado localmente
    # Para simplificar, vamos usar a excentricidade média calculada
    e_inst = np.full_like(time, e)
    
    print(f"{planet_name}: e = {e:.6f}, r_min = {r_min:.6f}, r_max = {r_max:.6f}, a = {a:.6f}")

# Escrever arquivo de saída
output.write("# Tempo")
for planet_name in planet_cols.keys():
    output.write(f" {planet_name}")
output.write("\n")

for i, t in enumerate(time):
    output.write(f"{t:.10e}")
    for planet_name in planet_cols.keys():
        e = eccentricities[planet_name]
        output.write(f" {e:.10e}")
    output.write("\n")

output.close()

print("\nArquivo 'eccentricity-calc-a1-15457752.dat' criado com sucesso!")

