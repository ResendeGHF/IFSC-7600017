      PROGRAM MAIN

C     ARRAY DE FORCAS E VARIAVEIS DE LOOP
      REAL FORCES_F0(3)
      DATA FORCES_F0 / 0.0, 0.5, 1.2 /
      CHARACTER*60 FILENAME
      IFORCES = 3

C     PARAMETROS
      G = 9.8
      ALENGHT = 9.8
      M = 1.0
      DT = 1E-2
      TMAX = 30.0
      PI = ACOS(-1.0)
      W_FREQ_SQ = G / ALENGHT
      E_FACTOR = 0.5 * M * ALENGHT**2
      VGAMMA = 0.05
      EXT_OMEGA = 1.0

C     CONDICOES INICIAIS (CONSTANTES)
      THETA_0 = 1.0
      OMEGA_0 = 0.0

45    FORMAT(F15.10,',',F15.10,',',F15.10,',',F15.10)
55    FORMAT('Tempo(s)',',','Posição Ângular (rad)',','
     + ,'Velocidade Ângular (rad/s)',',','Energia (j)')
65    FORMAT(A, F5.3, A)

      DO K = 1, IFORCES
          EXT_FORCE = FORCES_F0(K)

C         GERA NOME DE ARQUIVO DINAMICO
          WRITE(FILENAME, 65) './data/saida-b4-F0-', EXT_FORCE, 
     + '-15457752.out'
          
          OPEN(UNIT=10, FILE=FILENAME, STATUS='UNKNOWN')
          WRITE(10, 55)

C         RESETA CONDICOES INICIAIS
          T = 0.0
          THETA = THETA_0
          OMEGA = OMEGA_0
          I = 0

100       CONTINUE
          IF ( T .GE. TMAX ) GOTO 200

          ENERGY = E_FACTOR * OMEGA**2 + M * G * ALENGHT 
     +           * (1.0 - COS(THETA))

          WRITE(10,45) T, THETA, OMEGA, ENERGY

          OMEGA = OMEGA - W_FREQ_SQ * SIN(THETA) * DT
     +            - VGAMMA * OMEGA * DT
     +            + EXT_FORCE * SIN(EXT_OMEGA*T) * DT
          THETA = THETA + OMEGA * DT

          I = I + 1
          T = I * DT      

          GOTO 100
200       CONTINUE
          CLOSE(10)

      END DO
      
      END
