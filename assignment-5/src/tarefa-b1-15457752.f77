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
C     MASSAS: SOL, TERRA, JUPITER
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
      DOUBLE PRECISION DIST_EARTH(10000)
      DOUBLE PRECISION DIST_YEARLY(100)
      DOUBLE PRECISION MIN_DIST, PERIOD
      CHARACTER*60 FNAME
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

      FNAME = "saida-b1-15457752.out"
45    FORMAT(201(1X,E30.20))

C     UNIDADES: DISTANCIA EM UA, TEMPO EM ANOS, MASSA EM KG
C     CONSTANTE GRAVITACIONAL: PARA ORBITA CIRCULAR A 1 UA COM PERIODO 1 ANO
      DT = 1.0D-3
      TMAX = 20.0D0
      PI = DACOS(-1.0D0)
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
C     (COMO SE FOSSE UM PROBLEMA DE 2 CORPOS COM O SOL)
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

C     CALCULAR DISTANCIA DA TERRA DA POSICAO INICIAL A CADA PASSO DE TEMPO
      X0_EARTH = BODY(2,1,1)
      Y0_EARTH = BODY(2,1,2)
      DO I = 1, NSTEPS
      X = BODY(2,I,1)
      Y = BODY(2,I,2)
      DIST_EARTH(I) = DSQRT((X - X0_EARTH)**2 + (Y - Y0_EARTH)**2)
      END DO

C     CALCULAR DISTANCIA DA POSICAO DO ANO ANTERIOR
C     ENCONTRAR POSICAO DA TERRA A CADA ANO (t = 1, 2, 3, ...)
      N_YEARS = INT(TMAX)
      IF ( N_YEARS .GT. 100 ) N_YEARS = 100
      DO K = 1, N_YEARS
      T_YEAR = DBLE(K)
C     ENCONTRAR PASSO DE TEMPO MAIS PROXIMO DE T_YEAR
      I_CLOSEST = 1
      T_DIFF_MIN = DABS(TIME(1) - T_YEAR)
      DO I = 2, NSTEPS
      T_DIFF = DABS(TIME(I) - T_YEAR)
      IF ( T_DIFF .LT. T_DIFF_MIN ) THEN
      T_DIFF_MIN = T_DIFF
      I_CLOSEST = I
      END IF
      END DO
C     AGORA ENCONTRAR POSICAO NO ANO ANTERIOR
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
C     CALCULAR DISTANCIA DO ANO ANTERIOR
      X_CURR = BODY(2,I_CLOSEST,1)
      Y_CURR = BODY(2,I_CLOSEST,2)
      X_PREV = BODY(2,I_PREV,1)
      Y_PREV = BODY(2,I_PREV,2)
      DIST_YEARLY(K) = DSQRT((X_CURR - X_PREV)**2 + 
     +                       (Y_CURR - Y_PREV)**2)
      ELSE
      DIST_YEARLY(K) = 0.0D0
      END IF
      END DO

C     VERIFICAR SE ORBITA DA TERRA E PERIODICA
C     PROCURAR RETORNO A POSICAO INICIAL DENTRO DA TOLERANCIA
C     NO PROBLEMA DE 3 CORPOS, ORBITA NAO DEVE SER EXATAMENTE PERIODICA
      PERIOD = 0.0D0
      MIN_DIST = 1.0D10
      Y_PREV = BODY(2,1,2)
      DO I = 2, NSTEPS
      X = BODY(2,I,1)
      Y = BODY(2,I,2)
      DIST = DSQRT((X - X0_EARTH)**2 + (Y - Y0_EARTH)**2)
      IF ( DIST .LT. MIN_DIST ) MIN_DIST = DIST
C     VERIFICAR RETORNO APROXIMADO (DENTRO DE 1% DO RAIO DA ORBITA)
      IF ( DIST .LT. 0.01D0 * R_EARTH .AND. Y .GT. 0.0D0 .AND.
     +     TIME(I) .GT. 0.5D0 ) THEN
      PERIOD = TIME(I)
      GOTO 300
      END IF
      Y_PREV = Y
      END DO
300   CONTINUE

C     SAIDA DOS RESULTADOS
      OPEN(UNIT=10,FILE=FNAME,STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10,45) TIME(I), (BODY(J,I,1), BODY(J,I,2), 
     *             VEL(J,I,1), VEL(J,I,2), J=1,NBODY)
      END DO
      CLOSE(10)

C     ANALISE DOS RESULTADOS
      OPEN(UNIT=11,FILE="analysis-b1-15457752.out",STATUS="UNKNOWN")
      WRITE(11,*) "PROBLEMA DE TRES CORPOS: SOL, TERRA, JUPITER"
      WRITE(11,*) "============================================"
      WRITE(11,*) ""
      WRITE(11,*) "Condicoes Iniciais:"
      WRITE(11,50) "Raio da Terra:", R_EARTH, "UA"
      WRITE(11,50) "Velocidade da Terra:", V_EARTH, "UA/ano"
      WRITE(11,50) "Raio de Jupiter:", R_JUPITER, "UA"
      WRITE(11,50) "Velocidade de Jupiter:", V_JUPITER, "UA/ano"
      WRITE(11,*) ""
      WRITE(11,*) "Analise da Orbita:"
      IF ( PERIOD .GT. 0.0D0 .AND. PERIOD .LT. TMAX ) THEN
      WRITE(11,50) "Periodo Aproximado:", PERIOD, "anos"
      WRITE(11,*) "Nota: Isto e apenas aproximado. A orbita NAO"
      WRITE(11,*) "e exatamente periodica devido a perturbacao"
      WRITE(11,*) "de Jupiter."
      ELSE
      WRITE(11,*) "Status da Orbita: NAO-PERIODICA"
      WRITE(11,50) "Distancia minima a posicao inicial:", 
     +             MIN_DIST, "UA"
      END IF
      WRITE(11,*) ""
      WRITE(11,*) "Isto confirma que a orbita da Terra NAO e"
      WRITE(11,*) "exatamente periodica no problema de 3 corpos,"
      WRITE(11,*) "diferente do caso de 2 corpos. As distancias"
      WRITE(11,*) "da posicao do ano anterior (abaixo) mostram"
      WRITE(11,*) "a deriva orbital devido a influencia de"
      WRITE(11,*) "Jupiter."
      WRITE(11,*) ""
      WRITE(11,*) "Distancia da posicao do ano anterior:"
      WRITE(11,*) "Ano    Distancia (UA)"
      WRITE(11,*) "--------------------"
      DO K = 2, N_YEARS
      IF ( DIST_YEARLY(K) .GT. 0.0D0 ) THEN
      WRITE(11,51) K, DIST_YEARLY(K)
      END IF
      END DO
      WRITE(11,*) ""
      WRITE(11,*) "Distancia tipica por ano (media):"
      SUM_DIST = 0.0D0
      N_VALID = 0
      DO K = 2, N_YEARS
      IF ( DIST_YEARLY(K) .GT. 0.0D0 ) THEN
      SUM_DIST = SUM_DIST + DIST_YEARLY(K)
      N_VALID = N_VALID + 1
      END IF
      END DO
      IF ( N_VALID .GT. 0 ) THEN
      AVG_DIST = SUM_DIST / DBLE(N_VALID)
      WRITE(11,50) "Distancia media por ano:", AVG_DIST, "UA"
      END IF
50    FORMAT(A30,1X,E15.8,1X,A)
51    FORMAT(I4,5X,E15.8)
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

