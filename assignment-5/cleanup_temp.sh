#!/bin/bash
# Script para limpar arquivos temporarios apos gerar os graficos

echo "Limpando arquivos temporarios..."

# Remover arquivos temporarios de dados estendidos
rm -f temp-*-15457752.out
rm -f saida-a1-extended-15457752.out

echo "Arquivos temporarios removidos!"
echo "Os graficos foram gerados e salvos."
echo "O codigo tarefa-a1-15457752.f77 continua simulando apenas 1 ano."

