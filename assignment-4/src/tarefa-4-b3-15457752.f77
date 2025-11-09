      PROGRAM MAIN

C     PARAMETROS
      G = 9.8
      ALENGHT = 9.8
      M = 1.0
      DT = 1E-2
      TMAX = 25.0
      PI = ACOS(-1.0)
      W_FREQ_SQ = G / ALENGHT
      E_FACTOR = 0.5 * M * ALENGHT**2
      VGAMMA = 0.5
      EXT_FORCE = 0.0
      EXT_OMEGA = 0.0

C     CONDICOES INICIAIS
      THETA_0 = 1.0
      OMEGA_0 = 0.0

45    FORMAT(F15.10,',',F15.10,',',F15.10,',',F15.10)
55    FORMAT('Tempo(s)',',','Posição Ângular (rad)',','
     + ,'Velocidade Ângular (rad/s)',',','Energia (j)')

      OPEN(UNIT=10,FILE='./data/saida-4-b3-15457752.out',
     + STATUS='UNKNOWN')
      WRITE(10,55)

      T = 0.0
      THETA = THETA_0
      OMEGA = OMEGA_0

      I = 0
100   CONTINUE
      IF ( T .GE. TMAX ) GOTO 200

C     ENERGIA MECANICA (E = 0.5*m*l^2*omega^2 + m*g*l*(1-cos(theta)))
      ENERGY = E_FACTOR * OMEGA**2 + M * G * ALENGHT * 
     + (1.0 - COS(THETA))

      WRITE(10,45) T, THETA, OMEGA, ENERGY

      OMEGA = OMEGA - (W_FREQ_SQ * SIN(THETA) * DT) 
     + - (VGAMMA * OMEGA * DT) + EXT_FORCE * SIN(EXT_OMEGA*T) * DT
      THETA = THETA + OMEGA * DT

      I = I + 1
      T = I * DT      

      GOTO 100
200   CONTINUE
      CLOSE(10)
      
      END
