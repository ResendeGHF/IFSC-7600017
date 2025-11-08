      PROGRAM MAIN

C     PARAMETROS
      G = 9.8
      ALENGHT = 9.8
      M = 1.0
      DT = 1E-2
      TMAX = 60.0
      PI = ACOS(-1.0)
      W_FREQ_SQ = G / ALENGHT
      E_FACTOR = 0.5 * M * ALENGHT**2

C     CONDICOES INICIAIS
      THETA_0 = 0.0
      OMEGA_0 = SQRT(G/ALENGHT)

45    FORMAT(F15.10,F15.10,F15.10,F15.10)
55    FORMAT(A,',',A,',',A,',',A)

      OPEN(UNIT=10,FILE='saida-4-a-15457752.out',STATUS='UNKNOWN')
      WRITE(10,55) 'Tempo(s)','Posição Ângular (rad)'
     + ,'Velocidade Ângular (rad/s)','Energia (j)'

      T = 0.0
      THETA = THETA_0
      OMEGA = OMEGA_0

      I = 0
100   CONTINUE
      IF ( T .GE. TMAX ) GOTO 200

C     ENERGIA (E = 0.5*m*l^2 * (omega^2 + (g/l)*theta^2))
      ENERGY = E_FACTOR * (OMEGA**2 + W_FREQ_SQ * THETA**2)

      WRITE(10,45) T, THETA, OMEGA, ENERGY

      OMEGA_NEW = OMEGA - W_FREQ_SQ * THETA * DT
      THETA_NEW = THETA + OMEGA * DT

      OMEGA = OMEGA_NEW
      THETA = THETA_NEW

      I = I + 1
      T = I * DT      

      GOTO 100
200   CONTINUE
      CLOSE(10)
      
      END
