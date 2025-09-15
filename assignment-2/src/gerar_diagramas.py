import numpy as np
import matplotlib.pyplot as plt
import glob
import re
import math

arquivos_dat = sorted(glob.glob('pos_N*.dat'))

if not arquivos_dat:
    print("Nenhum arquivo de dados 'pos_N*.dat' encontrado.")
    print("Certifique-se de que o programa Fortran foi executado e gerou os arquivos.")
else:
    print(f"Encontrados {len(arquivos_dat)} arquivos de dados. Gerando diagramas...")

for arquivo in arquivos_dat:
    try:
        match = re.search(r'pos_N(\d+).dat', arquivo)
        N = int(match.group(1))
    except (AttributeError, IndexError):
        print(f"Não foi possível extrair o número N do arquivo: {arquivo}")
        continue
    
    posicoes = np.loadtxt(arquivo)
    x = posicoes[:, 0]
    y = posicoes[:, 1]
    
    fig, ax = plt.subplots(figsize=(8, 8))
    
    ax.scatter(x, y, s=5, alpha=0.6, edgecolors='none')
    
    ax.set_title(f'Diagrama de Posições após N = {N} passos', fontsize=16)
    ax.set_xlabel('Posição X', fontsize=12)
    ax.set_ylabel('Posição Y', fontsize=12)
    
    limite = math.ceil(1.5 * math.sqrt(N)) if N > 0 else 10
    
    ax.set_aspect('equal', adjustable='box')
    ax.grid(True, linestyle='--', alpha=0.6)
    
    nome_saida = f'diagrama_N_{N}.png'
    plt.savefig(nome_saida, dpi=150, bbox_inches='tight')
    plt.close(fig) # Fecha a figura para liberar memória
    
    print(f"-> Diagrama salvo como: {nome_saida}")

print("\nTodos os diagramas foram gerados.")
