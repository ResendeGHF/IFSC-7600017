#!/usr/bin/env python3
# Script para converter dados de simulacao para referencia ao centro de massa (0,0)

import numpy as np
import sys

def convert_to_cm(input_file, output_file):
    """
    Converte dados de simulacao para referencia ao centro de massa.
    Calcula CM em cada instante e subtrai de todas as posicoes.
    """
    # Ler dados
    data = np.loadtxt(input_file)
    
    # Massas dos corpos (em kg)
    # Sol, Mercúrio, Vênus, Terra, Marte, Júpiter, Saturno, Urano, Netuno, Plutão
    masses = np.array([
        1.989e30,  # Sol
        2.4e23,    # Mercúrio
        4.9e24,    # Vênus
        6.0e24,    # Terra
        6.6e23,    # Marte
        1.9e27,    # Júpiter
        5.7e26,    # Saturno
        8.8e25,    # Urano
        1.03e26,   # Netuno
        6.0e24     # Plutão
    ])
    
    total_mass = np.sum(masses)
    
    # Colunas: tempo, (x,y,vx,vy) para cada corpo
    # Corpos: 1=Sol (col 2,3,4,5), 2=Mercúrio (col 5,6,7,8), etc.
    n_bodies = 10
    n_cols_per_body = 4
    
    # Criar array de saída
    n_rows = len(data)
    n_cols = 1 + n_bodies * n_cols_per_body  # tempo + 10 corpos * 4
    output_data = np.zeros((n_rows, n_cols))
    
    output_data[:, 0] = data[:, 0]  # Tempo
    
    # Para cada instante de tempo
    for i in range(len(data)):
        # Calcular centro de massa
        cm_x = 0.0
        cm_y = 0.0
        cm_vx = 0.0
        cm_vy = 0.0
        
        for j in range(n_bodies):
            x_col = 1 + j * n_cols_per_body + 0
            y_col = 1 + j * n_cols_per_body + 1
            vx_col = 1 + j * n_cols_per_body + 2
            vy_col = 1 + j * n_cols_per_body + 3
            
            cm_x += masses[j] * data[i, x_col]
            cm_y += masses[j] * data[i, y_col]
            cm_vx += masses[j] * data[i, vx_col]
            cm_vy += masses[j] * data[i, vy_col]
        
        cm_x /= total_mass
        cm_y /= total_mass
        cm_vx /= total_mass
        cm_vy /= total_mass
        
        # Subtrair centro de massa de todas as posições e velocidades
        for j in range(n_bodies):
            x_col = 1 + j * n_cols_per_body + 0
            y_col = 1 + j * n_cols_per_body + 1
            vx_col = 1 + j * n_cols_per_body + 2
            vy_col = 1 + j * n_cols_per_body + 3
            
            output_data[i, x_col] = data[i, x_col] - cm_x
            output_data[i, y_col] = data[i, y_col] - cm_y
            output_data[i, vx_col] = data[i, vx_col] - cm_vx
            output_data[i, vy_col] = data[i, vy_col] - cm_vy
    
    # Salvar arquivo
    np.savetxt(output_file, output_data, fmt='%.20e')
    print(f"Arquivo convertido: {output_file}")
    print(f"  Centro de massa agora em (0,0) em todos os instantes")

if __name__ == "__main__":
    # Converter arquivo principal
    convert_to_cm('saida-a1-15457752.out', 'saida-a1-cm-15457752.out')
    
    # Converter arquivos temporários
    temp_files = [
        'temp-marte-15457752.out',
        'temp-jupiter-15457752.out',
        'temp-saturno-15457752.out',
        'temp-urano-15457752.out',
        'temp-netuno-15457752.out',
        'temp-plutao-15457752.out'
    ]
    
    for temp_file in temp_files:
        try:
            output_file = temp_file.replace('temp-', 'temp-cm-')
            convert_to_cm(temp_file, output_file)
        except FileNotFoundError:
            print(f"Arquivo {temp_file} nao encontrado, pulando...")
        except Exception as e:
            print(f"Erro ao processar {temp_file}: {e}")
