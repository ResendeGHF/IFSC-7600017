import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def gaussian(x, A, mu, sigma):
    """Define a função Gaussiana para o ajuste."""
    return A * np.exp(-(x - mu)**2 / (2 * sigma**2))

try:
    x_data, y_data = np.loadtxt('histogram.dat', unpack=True)
except IOError:
    print("Erro: O arquivo 'histogram.dat' não foi encontrado.")
    print("Certifique-se de que o arquivo está no mesmo diretório que o script.")
    exit()

# Fornece estimativas iniciais para os parâmetros de ajuste para ajudar o algoritmo.
# A (Amplitude): O valor máximo das contagens.
# mu (Média): A posição x correspondente à contagem máxima.
# sigma (Desvio Padrão): Estimativa inicial baseada na largura da distribuição.
initial_guesses = [np.max(y_data), x_data[np.argmax(y_data)], 20]

popt, pcov = curve_fit(gaussian, x_data, y_data, p0=initial_guesses)

x_fit = np.linspace(x_data.min(), x_data.max(), 500)
y_fit = gaussian(x_fit, *popt)

plt.figure(figsize=(10, 6))

plt.bar(x_data, y_data, width=2.0, label='Data from Simulation', color='steelblue', alpha=0.7)

plt.plot(x_fit, y_fit, 'r-', linewidth=2, label='Best Gaussian Fit')

plt.title('Histogram of Final Positions and Gaussian Fit', fontsize=16)
plt.xlabel('Final Position (x)', fontsize=12)
plt.ylabel('Number of Walkers n(x)', fontsize=12)
plt.legend(fontsize=10)
plt.grid(True, linestyle='--', alpha=0.6)
plt.xlim(min(x_data)-10, max(x_data)+10)

print("Parâmetros Ótimos da Curva Gaussiana Ajustada:")
print(f"  Amplitude (A) = {popt[0]:.2f}")
print(f"  Média (μ) = {popt[1]:.2f} (Teórico: 0)")
print(f"  Desvio Padrão (σ) = {popt[2]:.2f} (Teórico: ~31.62)")

plt.savefig('histogram_fit.png')
plt.show()
