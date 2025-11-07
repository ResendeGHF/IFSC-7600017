      PROGRAM MAIN
      CHARACTER FNAME*30
      
      G = 9.8
      F_0 = 0.0
      EXT = 100
      DT = 1E-2
      TMAX = 20.0
      AGAMMA = 0.5
      ALENGHT = 9.8
      OMEGA_0 = 0.0
      PI = ACOS(-1.0)
      THETA_0 = PI/32
      THETA = THETA_0
      
      I = 1

      FNAME = 'saida-tarefa-2b3-15457752.out'
      OPEN(UNIT=10,FILE=FNAME,STATUS='REPLACE')
45    FORMAT(F15.10,',',F15.10,',',F15.10)

100   CONTINUE
      OMEGA = OMEGA - (G/ALENGHT)*(THETA*DT) - (AGAMMA*OMEGA*DT) + 
     + (F_0*SIN(EXT*T))*DT
      THETA = THETA + OMEGA * DT
      T = I * DT
      I = I + 1
      THETA = MOD(THETA,2*PI)
      WRITE(10,45) T, THETA, OMEGA
      IF ( T .GE. TMAX ) GOTO 200
      GOTO 100
200   CONTINUE

      CLOSE(10)

      END
