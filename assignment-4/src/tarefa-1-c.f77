      PROGRAM MAIN
      G = 9.8
      DT = 1E-2
      TMAX = 60
      F_0 = 0.3
      EXT = 100
      F_0 = 0.3
      EXT = 100
      AGAMMA = 0.5
      ALENGHT = 9.8
      OMEGA_0 = 0.0
      PI = ACOS(-1.0)
      THETA_0 = SQRT(G/ALENGHT)

45    FORMAT(F15.10,',',F15.10,',',F15.10)

      OPEN(UNIT=10,FILE='EULER-C.OUT',STATUS='UNKNOWN')

      THETA = THETA_0
      I = 1
100   CONTINUE
      IF ( T .GE. TMAX ) THEN
              GOTO 200
      END IF
      
      OMEGA = OMEGA - (G/ALENGHT)*(THETA*DT) - (AGAMMA*OMEGA*DT) + 
     + (F_0*SIN(EXT*T))*DT
      
      THETA = THETA + OMEGA * DT
      T = I * DT
      I = I + 1

      WRITE(10,45) T , MOD(THETA,2*PI), OMEGA

      GOTO 100
200   CONTINUE

      CLOSE(10)
      
      END
