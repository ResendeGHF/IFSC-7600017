      PROGRAM MAIN
      REAL TIME(2)

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
      
      T = 0.0
      I = 0
      THETA = THETA_0
      OMEGA = OMEGA_0     

100   CONTINUE
      IF ( T .GE. TMAX ) GOTO 200
      OMEGA_OLD = OMEGA
      OMEGA = OMEGA - W_FREQ_SQ * THETA * DT
      THETA = THETA + OMEGA * DT

      I = I + 1
      T = I * DT

C     VERIFICA QUANTAS VEZES O PENDULO PASSOU POR Y=0
C     A FIM DE CONTAR UM PERIODO      
      IF ( OMEGA_OLD * OMEGA .LT. 0.0 ) THEN
              ICOUNT = ICOUNT + 1
              TIME(ICOUNT) = T
              IF ( ICOUNT .EQ. 2 ) THEN
                      PERIOD = 2.0 * (TIME(2) - TIME(1))
                      GOTO 200
              ENDIF
      ENDIF

      GOTO 100
200   CONTINUE

      PERIOD_ANALYTIC = F(ALENGHT,G,THETA_0)

45    FORMAT('PERIODO_ESTIMADO',',','PERIODO_ANALITICO')
55    FORMAT(F15.10,',',F15.10)
      OPEN(UNIT=10,FILE='./data/saida-4-b2-15457752.out',
     + STATUS='UNKNOWN')
      WRITE(10,45)
      WRITE(10,55) PERIOD, PERIOD_ANALYTIC
      CLOSE(10)

      END
      
      FUNCTION F(AL,G,THETA_0)
      PI = ACOS(-1.0)
      F = 2.0*PI*SQRT(AL/G)*(1+(THETA_0**2)/16)
      RETURN
      END
