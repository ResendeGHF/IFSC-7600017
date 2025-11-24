import glob
import os
import subprocess

if __name__ == "__main__":
    data_files = glob.glob('./data/*.out')
    output_dir = './plots/'
    os.makedirs(output_dir, exist_ok=True)
    
    for input_path in data_files:
        filename = os.path.basename(input_path)
        output_name = f"plot_{filename.replace('.out', '.png')}"
        output_path = os.path.join(output_dir, output_name)
        
        try:
            # This command is unchanged and works with the new template
            subprocess.run([
                'gnuplot',
                '-e', f"input_file='{input_path}'",
                '-e', f"output_file='{output_path}'",
                'plot_template_simple.gp'
            ], check=True)
            
            print(f"Generated plot: {output_path}")
            
        except Exception as e:
            print(f"Could not plot {input_path} with Gnuplot: {e}")
