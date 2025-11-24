# --- 1. Obter Cabecalhos das Colunas e Contar ---
# Funcao auxiliar para obter o texto do cabecalho da coluna 'n'
get_col(n) = system(sprintf("head -n 1 %s | tr -d '#\"' | awk -F, '{print $%d}' | sed 's/^ *//;s/ *$//'", input_file, n))

# Obter o rotulo do eixo X (da coluna 1)
xlabel_text = get_col(1)

# Obter o numero total de colunas do cabecalho
total_cols = int(system(sprintf("head -n 1 %s | tr -d '#\"' | awk -F, '{print NF}'", input_file)))
y_cols = total_cols - 1

# --- 2. Carregar Paleta e Configurar Terminal ---
load 'spectral.pal'
# Tornar o grafico mais alto para acomodar (y_cols) graficos empilhados
set terminal pngcairo size 800, (y_cols * 300) enhanced font "Helvetica,10"
set output output_file

# --- 3. Configurar Layout Multiplot ---
# Isto cria um layout de 'y_cols' linhas e 1 coluna.
set multiplot layout y_cols, 1 title "Resultados para: ".input_file font ",14"
set datafile separator comma
set key right top
set grid

total_cols = total_cols + 1 
# --- 4. Loop Gnuplot (de i=2 ate total_cols) ---
do for [i=2:total_cols] {
    
    # Configurar o rotulo Y especifico para este grafico individual
    set ylabel get_col(i) 
    
    # Lidar com rotulo do eixo X e marcas
    if (i == total_cols) {
        # Este e o grafico INFERIOR, entao mostrar o rotulo X e as marcas
        set xlabel xlabel_text
        set xtics auto
        set format x "%g"
    } else {
        # Este nao e o grafico inferior, entao esconder o rotulo X e as marcas
        set xlabel ""
        unset xtics
        set format x ""
    }
    
    # Plotar coluna 1 vs coluna $i$, pulando o cabecalho ('every ::1')
    # Usar o texto do cabecalho para o titulo da legenda
  plot input_file using 1:i every ::1 with linespoints linestyle i-1 title get_col(i)
}

# --- 5. Finalizar Multiplot ---
unset multiplot
