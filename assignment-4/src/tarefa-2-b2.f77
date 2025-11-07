      PROGRAM MAIN
      G = 9.8
      F_0 = 0.0
      EXT = 100
      DT = 1E-2
      AGAMMA = 0.0
      ALENGHT = 9.8
      OMEGA_0 = 0.0
      PI = ACOS(-1.0)
      THETA_0 = PI/32
      THETA = THETA_0
      
      I = 1

100   CONTINUE
      OMEGA = OMEGA - (G/ALENGHT)*(THETA*DT) - (AGAMMA*OMEGA*DT) + 
     + (F_0*SIN(EXT*T))*DT
      THETA = THETA + OMEGA * DT
      T = I * DT
      I = I + 1
      THETA = MOD(THETA,2*PI)
      IF ( THETA .GT. MOD(THETA_0,2.0*PI)) GOTO 200
      GOTO 100
200   CONTINUE

      WRITE(6,'(F15.10)') (T)

      T_ANALYTIC = F(ALENGHT,G,THETA_0)
      WRITE(6,'(F15.10)') T_ANALYTIC

      END
      
      FUNCTION F(AL,G,THETA_0)
      PI = ACOS(-1.0)
      F = 2.0*PI*SQRT(AL/G)*(1+(THETA_0**2)/16)
      RETURN
      END
