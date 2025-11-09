# --- 1. Get Column Headers and Count ---
# Helper function to get the header text for column 'n'
get_col(n) = system(sprintf("head -n 1 %s | tr -d '#\"' | awk -F, '{print $%d}' | sed 's/^ *//;s/ *$//'", input_file, n))

# Get the xlabel (from column 1)
xlabel_text = get_col(1)

# Get the total number of columns from the header
total_cols = int(system(sprintf("head -n 1 %s | tr -d '#\"' | awk -F, '{print NF}'", input_file)))
y_cols = total_cols - 1

# --- 2. Load Palette & Set Terminal ---
load 'spectral.pal'
# Make the plot taller to accommodate (y_cols) stacked plots
set terminal pngcairo size 800, (y_cols * 300) enhanced font "Helvetica,10"
set output output_file

# --- 3. Set Multiplot Layout ---
# This creates a layout of 'y_cols' rows and 1 column.
set multiplot layout y_cols, 1 title "Resultados para: ".input_file font ",14"
set datafile separator comma
set key right top
set grid

total_cols = total_cols + 1 
# --- 4. Gnuplot Loop (from i=2 to total_cols) ---
do for [i=2:total_cols] {
    
    # Set the specific Y label for this individual plot
    set ylabel get_col(i) 
    
    # Handle X-axis label & tics
    if (i == total_cols) {
        # This is the BOTTOM plot, so show the xlabel and tics
        set xlabel xlabel_text
        set xtics auto
        set format x "%g"
    } else {
        # This is not the bottom plot, so hide the xlabel and tics
        set xlabel ""
        unset xtics
        set format x ""
    }
    
    # Plot column 1 vs column $i$, skipping the header ('every ::1')
    # Use the header text for the legend title
  plot input_file using 1:i every ::1 with linespoints linestyle i-1 title get_col(i)
}

# --- 5. End Multiplot ---
unset multiplot
