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
      THETA = THETA + OMEGA*DT
      T = I * DT
      I = I + 1
      THETA = MOD(THETA,2*PI)
      IF ( THETA .GT. MOD(THETA_0,2.0*PI) ) GOTO 200
      GOTO 100
200   CONTINUE

      WRITE(6,*) (T)

      A = -THETA_0
      B = THETA_0
      N = 1000
      H = ((B-A)/N)
C     FUNCAO DEFINIDA NO ABERTO (A,B)
C     OUTS = F(A,B) + F(B,B)
      DO I = 2, N-1, 2
      OUTS = OUTS + 4*(F(A + I*H,B))
      END DO
      DO I = 3, N-2, 2
      OUTS = OUTS + 2*(F(A + I*H,B))
      END DO
      OUTS = OUTS * (H/3) * SQRT((2*ALENGHT)/G)
      
      WRITE(6,'(F15.10)') OUTS

      END
      
      FUNCTION F(X,X0)
      F = 1/(COS(X)-COS(X0))**(0.5)
      RETURN
      END
