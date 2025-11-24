      BLOCK DATA
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP
      INTEGER MAXBODY, MAXSTEP
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION MASS(50)
      INTEGER NBODY
      DATA BODY /1000000 * 0.0D0/
      DATA VEL /1000000 * 0.0D0/
C     MASSAS: SOL, TERRA, JUPITER (SERA MODIFICADO NO PROGRAMA)
      DATA MASS /1.989D30, 6.0D24, 1.9D27, 47 * 0.0D0/
      DATA NBODY /3/
      DATA MAXBODY /50/
      DATA MAXSTEP /10000/
      END BLOCK DATA

      PROGRAM MAIN
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION TIME(10000)
      DOUBLE PRECISION MASS(50)
      DOUBLE PRECISION DIST_YEARLY(100,3)
      DOUBLE PRECISION AVG_DIST(3)
      DOUBLE PRECISION MAX_DIST(3)
      DOUBLE PRECISION MASS_FACTOR(3)
      INTEGER ISIM
      CHARACTER*60 FNAME
      CHARACTER*60 FNAME_OUT
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

45    FORMAT(201(1X,E30.20))

C     UNIDADES: DISTANCIA EM UA, TEMPO EM ANOS, MASSA EM KG
      DT = 1.0D-3
      TMAX = 10.0D0
      PI = DACOS(-1.0D0)

C     FATORES DE MASSA: 1X, 100X, 1000X MASSA DE JUPITER
      MASS_FACTOR(1) = 1.0D0
      MASS_FACTOR(2) = 100.0D0
      MASS_FACTOR(3) = 1000.0D0

C     EXECUTAR SIMULACOES PARA CADA FATOR DE MASSA
      DO ISIM = 1, 3
      MFACT = MASS_FACTOR(ISIM)
      
C     DEFINIR MASSA DE JUPITER
      MASS(1) = 1.989D30
      MASS(2) = 6.0D24
      MASS(3) = 1.9D27 * MFACT
      G = 4.0D0 * PI**2 / MASS(1)

C     INICIALIZAR SOL NA ORIGEM
      BODY(1,1,1) = 0.0D0
      BODY(1,1,2) = 0.0D0
      VEL(1,1,1) = 0.0D0
      VEL(1,1,2) = 0.0D0
      BODY(1,2,1) = 0.0D0
      BODY(1,2,2) = 0.0D0
      VEL(1,2,1) = 0.0D0
      VEL(1,2,2) = 0.0D0

C     INICIALIZAR TERRA A 1 UA COM VELOCIDADE DE ORBITA CIRCULAR
      R_EARTH = 1.0D0
      V_EARTH = DSQRT(4.0D0 * PI**2 / R_EARTH)
      BODY(2,1,1) = R_EARTH
      BODY(2,1,2) = 0.0D0
      VEL(2,1,1) = 0.0D0
      VEL(2,1,2) = V_EARTH
      BODY(2,2,1) = R_EARTH
      BODY(2,2,2) = V_EARTH * DT
      VEL(2,2,1) = 0.0D0
      VEL(2,2,2) = V_EARTH

C     INICIALIZAR JUPITER A 5.2 UA COM VELOCIDADE DE ORBITA CIRCULAR
      R_JUPITER = 5.2D0
      V_JUPITER = DSQRT(4.0D0 * PI**2 / R_JUPITER)
      BODY(3,1,1) = R_JUPITER
      BODY(3,1,2) = 0.0D0
      VEL(3,1,1) = 0.0D0
      VEL(3,1,2) = V_JUPITER
      BODY(3,2,1) = R_JUPITER
      BODY(3,2,2) = V_JUPITER * DT
      VEL(3,2,1) = 0.0D0
      VEL(3,2,2) = V_JUPITER

      TIME(1) = 0.0D0
      TIME(2) = DT
      
      I = 3
100   CONTINUE
      TIME(I) = DT * ( I - 1 )
      IF ( TIME(I) .GE. TMAX ) GOTO 200
      DO J = 1, NBODY
      CALL RAC(J,(I-1),AX,AY)
      BODY(J,I,1) = 2.0D0*BODY(J,(I-1),1) - BODY(J,(I-2),1) 
     +              + AX*DT**2
      BODY(J,I,2) = 2.0D0*BODY(J,(I-1),2) - BODY(J,(I-2),2) 
     +              + AY*DT**2
      VEL(J,I,1) = (BODY(J,I,1) - BODY(J,(I-2),1)) 
     +             / (2.0D0 * DT)
      VEL(J,I,2) = (BODY(J,I,2) - BODY(J,(I-2),2)) 
     +             / (2.0D0 * DT)
      END DO
      I = I + 1
      IF ( I .GT. MAXSTEP ) GOTO 200
      GOTO 100
200   CONTINUE
      NSTEPS = I - 1

C     CALCULAR DISTANCIA DA POSICAO DO ANO ANTERIOR
      N_YEARS = INT(TMAX)
      IF ( N_YEARS .GT. 100 ) N_YEARS = 100
      X0_EARTH = BODY(2,1,1)
      Y0_EARTH = BODY(2,1,2)
      
      DO K = 1, N_YEARS
      T_YEAR = DBLE(K)
      I_CLOSEST = 1
      T_DIFF_MIN = DABS(TIME(1) - T_YEAR)
      DO I = 2, NSTEPS
      T_DIFF = DABS(TIME(I) - T_YEAR)
      IF ( T_DIFF .LT. T_DIFF_MIN ) THEN
      T_DIFF_MIN = T_DIFF
      I_CLOSEST = I
      END IF
      END DO
      
      IF ( K .GT. 1 ) THEN
      T_PREV = DBLE(K-1)
      I_PREV = 1
      T_DIFF_MIN_PREV = DABS(TIME(1) - T_PREV)
      DO I = 2, NSTEPS
      T_DIFF = DABS(TIME(I) - T_PREV)
      IF ( T_DIFF .LT. T_DIFF_MIN_PREV ) THEN
      T_DIFF_MIN_PREV = T_DIFF
      I_PREV = I
      END IF
      END DO
      X_CURR = BODY(2,I_CLOSEST,1)
      Y_CURR = BODY(2,I_CLOSEST,2)
      X_PREV = BODY(2,I_PREV,1)
      Y_PREV = BODY(2,I_PREV,2)
      DIST_YEARLY(K,ISIM) = DSQRT((X_CURR - X_PREV)**2 + 
     +                            (Y_CURR - Y_PREV)**2)
      ELSE
      DIST_YEARLY(K,ISIM) = 0.0D0
      END IF
      END DO

C     CALCULAR DISTANCIAS MEDIA E MAXIMA
      SUM_DIST = 0.0D0
      MAX_DIST(ISIM) = 0.0D0
      N_VALID = 0
      DO K = 2, N_YEARS
      IF ( DIST_YEARLY(K,ISIM) .GT. 0.0D0 ) THEN
      SUM_DIST = SUM_DIST + DIST_YEARLY(K,ISIM)
      N_VALID = N_VALID + 1
      IF ( DIST_YEARLY(K,ISIM) .GT. MAX_DIST(ISIM) ) THEN
      MAX_DIST(ISIM) = DIST_YEARLY(K,ISIM)
      END IF
      END IF
      END DO
      IF ( N_VALID .GT. 0 ) THEN
      AVG_DIST(ISIM) = SUM_DIST / DBLE(N_VALID)
      ELSE
      AVG_DIST(ISIM) = 0.0D0
      END IF

C     SAIDA DOS RESULTADOS PARA ESTA SIMULACAO
      IF ( ISIM .EQ. 1 ) THEN
      FNAME_OUT = "saida-b2-1x-15457752.out"
      ELSE IF ( ISIM .EQ. 2 ) THEN
      FNAME_OUT = "saida-b2-100x-15457752.out"
      ELSE
      FNAME_OUT = "saida-b2-1000x-15457752.out"
      END IF
      
      OPEN(UNIT=10,FILE=FNAME_OUT,STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10,45) TIME(I), (BODY(J,I,1), BODY(J,I,2), 
     *             VEL(J,I,1), VEL(J,I,2), J=1,NBODY)
      END DO
      CLOSE(10)

      END DO

C     ANALISE COMPARATIVA
      OPEN(UNIT=11,FILE="analysis-b2-15457752.out",STATUS="UNKNOWN")
      WRITE(11,*) "PROBLEMA DE TRES CORPOS: EFEITO DA MASSA DE"
      WRITE(11,*) "JUPITER"
      WRITE(11,*) "=========================================="
      WRITE(11,*) ""
      WRITE(11,*) "Esta simulacao compara a orbita da Terra com"
      WRITE(11,*) "diferentes massas de Jupiter para mostrar os"
      WRITE(11,*) "efeitos do aumento da perturbacao"
      WRITE(11,*) "gravitacional."
      WRITE(11,*) ""
      WRITE(11,*) "Parametros da Simulacao:"
      WRITE(11,50) "Raio da Terra:", R_EARTH, "UA"
      WRITE(11,50) "Raio de Jupiter:", R_JUPITER, "UA"
      WRITE(11,*) ""
      WRITE(11,*) "Comparacao dos Resultados:"
      WRITE(11,*) "-------------------------"
      WRITE(11,*) "Massa de     Dist Media/Ano    Dist Maxima"
      WRITE(11,*) "Jupiter         (UA)              (UA)"
      WRITE(11,*) "Fator"
      WRITE(11,*) "--------------------------------------------"
      DO ISIM = 1, 3
      WRITE(11,51) INT(MASS_FACTOR(ISIM)), AVG_DIST(ISIM), 
     +              MAX_DIST(ISIM)
      END DO
      WRITE(11,*) ""
      WRITE(11,*) "Distancia Ano a Ano da Posicao Anterior:"
      WRITE(11,*) "Ano    1x Massa   100x Massa  1000x Massa"
      WRITE(11,*) "      (UA)        (UA)        (UA)"
      WRITE(11,*) "--------------------------------------------"
      DO K = 2, N_YEARS
      IF ( DIST_YEARLY(K,1) .GT. 0.0D0 .OR. 
     +     DIST_YEARLY(K,2) .GT. 0.0D0 .OR.
     +     DIST_YEARLY(K,3) .GT. 0.0D0 ) THEN
      WRITE(11,52) K, DIST_YEARLY(K,1), DIST_YEARLY(K,2),
     +             DIST_YEARLY(K,3)
      END IF
      END DO
      WRITE(11,*) ""
      WRITE(11,*) "Analise:"
      WRITE(11,*) "A medida que a massa de Jupiter aumenta, a"
      WRITE(11,*) "perturbacao na orbita da Terra se torna mais"
      WRITE(11,*) "pronunciada. As distancias da posicao do ano"
      WRITE(11,*) "anterior aumentam significativamente, mostrando"
      WRITE(11,*) "que a orbita da Terra se torna menos estavel"
      WRITE(11,*) "e mais caotica."
50    FORMAT(A30,1X,E15.8,1X,A)
51    FORMAT(I10,5X,E15.8,5X,E15.8)
52    FORMAT(I4,3(5X,E12.5))
      CLOSE(11)

      END

      FUNCTION AC(AM2, CORD, DIST)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION MASS(50)
      PI = DACOS(-1.0D0)
      G = 4.0D0 * PI**2 / MASS(1)
      AC = (G * AM2 * CORD) / (DIST ** 3)
      END

      FUNCTION DIST(X1,Y1,X2,Y2)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIST = ( (X2-X1) ** 2 + (Y2-Y1) ** 2 ) 
     + ** ( 1.0D0/2.0D0 )
      END

      SUBROUTINE RAC(I,J,ACX,ACY)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION MASS(50)
      ACX = 0.0D0
      ACY = 0.0D0
      X2 = BODY(I,J,1)
      Y2 = BODY(I,J,2)
      DO K = 1, NBODY
      IF ( K .EQ. I ) GOTO 10
      X1 = BODY(K,J,1)
      Y1 = BODY(K,J,2)
      D = DIST(X1,Y1,X2,Y2)
      IF ( D .LT. 1.0D-10 ) GOTO 10
      DX = X1 - X2
      DY = Y1 - Y2
      ACX = ACX + AC(MASS(K),DX,D)
      ACY = ACY + AC(MASS(K),DY,D)
10    CONTINUE
      END DO
      END

