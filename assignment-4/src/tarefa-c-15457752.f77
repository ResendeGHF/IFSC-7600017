      PROGRAM MAIN
      CHARACTER FNAME*34
      PARAMETER(DT = 0.04, TMAX = 6000.0, NO=2)
      REAL OUTS((NO*2)+1,INT(TMAX/DT))

      G = 9.8
      F_0 = 1.2
      EXT = 2.0/3.0
      AGAMMA = 0.05
      ALENGHT = 9.8
      PI = ACOS(-1.0)
      OMEGA_0 = 0.0
      THETA_0 = PI/32
      OMEGA = OMEGA_0
      THETA = THETA_0 

      DO I=1, INT(TMAX/DT)
         OUTS(1,I) = I * DT
      END DO

      DO J = 2, 4, 2
         I = 1
         T = 0
         IF ( J .GE. 3 ) THEN
            THETA = THETA_0 + 1.5
            OMEGA = OMEGA_0
         END IF
100      CONTINUE
         OMEGA = OMEGA - (G/ALENGHT)*(THETA*DT) - (AGAMMA*OMEGA*DT) + 
     + (F_0*SIN(EXT*T))*DT
         THETA = THETA + OMEGA*DT
         T = I * DT
         I = I + 1
         OUTS(J,I) = MOD(THETA,2*PI)
         OUTS(J+1,I) = OMEGA
         IF ( T .GE. TMAX ) GOTO 200
         GOTO 100
200      CONTINUE
      END DO

      FNAME = 'saida-tarefa-c-all-15457752.out'
      OPEN(UNIT=10,FILE=FNAME,STATUS='REPLACE')
45    FORMAT(F15.10,',',F15.10,',',F15.10,',',F15.10,',',F15.10)
      WRITE(10,45) OUTS
      CLOSE(10)

      FNAME = 'saida-tarefa-c-theta-15457752.out'
      OPEN(UNIT=20,FILE=FNAME,STATUS='REPLACE')
55    FORMAT(F15.10,',',F15.10)
      DO I=1, INT(TMAX/DT)
         WRITE(20,55) OUTS(2,I), OUTS(4,I)
      END DO
      CLOSE(20)

      FNAME = 'saida-tarefa-c-omega-15457752.out'
      OPEN(UNIT=30,FILE=FNAME,STATUS='REPLACE')
      DO I=1, INT(TMAX/DT)
         WRITE(30,55) OUTS(3,I), OUTS(5,I)
      END DO
      CLOSE(30)

      FNAME = 'saida-tarefa-c-dtheta-15457752.out'
      OPEN(UNIT=40,FILE=FNAME,STATUS='REPLACE')
      DO I=1, INT(TMAX/DT)
         WRITE(40,55) OUTS(1,I), (OUTS(4,I)-OUTS(2,I))
      END DO
      CLOSE(40)

      END
