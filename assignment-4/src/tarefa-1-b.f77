      PROGRAM MAIN
      G = 9.8
      DT = 1E-2
      TMAX = 60
      PI = ACOS(-1.0)
      ALENGHT = 9.8
      THETA_0 = SQRT(G/ALENGHT)

45    FORMAT(F15.10,F15.10,F15.10)

      OPEN(UNIT=10,FILE='EULER-B.OUT',STATUS='UNKNOWN')

      THETA = THETA_0
      I = 1
100   CONTINUE
      IF ( T .GE. TMAX ) THEN
              GOTO 200
      END IF
     
      OMEGA = OMEGA - (G/ALENGHT)*(THETA * DT)
      THETA = THETA + OMEGA * DT
      T = I * DT
      I = I + 1

      WRITE(10,45) T , MOD(THETA,2*PI), OMEGA

      GOTO 100
200   CONTINUE

      CLOSE(10)
      
      END
