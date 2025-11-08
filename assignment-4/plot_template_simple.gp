# --- 1. Load the "Gnuplotting" palette ---
# This command sets the color palette AND defines
# a series of pre-configured line styles (ls 1, ls 2, etc.)
load 'spectral.pal'

# --- 2. Set terminal and output (from variables) ---
set terminal pngcairo size 800,600 enhanced font "Helvetica,10"
set output output_file

# --- 3. Set plot properties ---
# We can use the title variable from the Python script
# set title "Results for: ".input_file
set xlabel "Tempo (s)"
set ylabel "Posição Angular (rad)"
set grid
set datafile separator comma
set key autotitle columnhead

# --- 4. Plot the data ---
# We now use 'ls 1' (line style 1) from the loaded palette.
# Gnuplot will automatically cycle through ls 1, ls 2, etc.
# if you add more 'plot' commands.
plot input_file using 1:2 with linespoints linestyle 1 title 'Sensor 1'
