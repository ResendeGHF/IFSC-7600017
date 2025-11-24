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
C     MASSAS: SOL, TERRA, LUA
C     MASSA DA LUA: 7.342E22 KG
C     DISTANCIA DA LUA DA TERRA: ~0.00257 UA (384400 KM)
      DATA MASS /1.989D30, 6.0D24, 7.342D22, 47 * 0.0D0/
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
      DOUBLE PRECISION DIST_ES(10000)
      DOUBLE PRECISION DIST_EM(10000)
      DOUBLE PRECISION DIST_MS(10000)
      DOUBLE PRECISION ANGLE_ESM(10000)
      DOUBLE PRECISION ANGLE_SEM(10000)
      INTEGER SOLAR_ECLIPSE(10000)
      INTEGER LUNAR_ECLIPSE(10000)
      CHARACTER*60 FNAME
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

      FNAME = "saida-b4-eclipse-15457752.out"
45    FORMAT(201(1X,E30.20))

C     UNIDADES: DISTANCIA EM UA, TEMPO EM ANOS, MASSA EM KG
      DT = 1.0D-3
      TMAX = 1.0D0
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

C     INICIALIZAR LUA ORBITANDO TERRA
C     DISTANCIA DA LUA DA TERRA: ~0.00257 UA
C     PERIODO ORBITAL DA LUA: ~27.3 DIAS = 0.0748 ANOS
C     VELOCIDADE DA LUA RELATIVA A TERRA: V = 2*PI*R/T
      R_MOON = 0.00257D0
      T_MOON = 0.0748D0
      V_MOON = 2.0D0 * PI * R_MOON / T_MOON
C     LUA COMECA NA POSICAO DA TERRA + R_MOON NA DIRECAO X
      BODY(3,1,1) = R_EARTH + R_MOON
      BODY(3,1,2) = 0.0D0
C     VELOCIDADE DA LUA = VELOCIDADE DA TERRA + VELOCIDADE ORBITAL NA DIRECAO Y
      VEL(3,1,1) = 0.0D0
      VEL(3,1,2) = V_EARTH + V_MOON
      BODY(3,2,1) = R_EARTH + R_MOON
      BODY(3,2,2) = (V_EARTH + V_MOON) * DT
      VEL(3,2,1) = 0.0D0
      VEL(3,2,2) = V_EARTH + V_MOON

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

C     CALCULAR DISTANCIAS E ANGULOS PARA DETECCAO DE ECLIPSES
      DO I = 1, NSTEPS
C     DISTANCIAS: ES = TERRA-SOL, EM = TERRA-LUA, MS = LUA-SOL
      X_S = BODY(1,I,1)
      Y_S = BODY(1,I,2)
      X_E = BODY(2,I,1)
      Y_E = BODY(2,I,2)
      X_M = BODY(3,I,1)
      Y_M = BODY(3,I,2)
      
      DIST_ES(I) = DSQRT((X_E - X_S)**2 + (Y_E - Y_S)**2)
      DIST_EM(I) = DSQRT((X_M - X_E)**2 + (Y_M - Y_E)**2)
      DIST_MS(I) = DSQRT((X_M - X_S)**2 + (Y_M - Y_S)**2)
      
C     CALCULAR ANGULOS PARA DETECCAO DE ALINHAMENTO
C     ANGLE_ESM: ANGULO NA TERRA ENTRE SOL E LUA
      DX_SE = X_E - X_S
      DY_SE = Y_E - Y_S
      DX_ME = X_M - X_E
      DY_ME = Y_M - Y_E
      
C     PRODUTO ESCALAR E PRODUTO VETORIAL PARA ANGULO
      DOT = DX_SE * DX_ME + DY_SE * DY_ME
      CROSS = DX_SE * DY_ME - DY_SE * DX_ME
      COS_ANGLE = DOT / (DIST_ES(I) * DIST_EM(I))
      IF ( COS_ANGLE .GT. 1.0D0 ) COS_ANGLE = 1.0D0
      IF ( COS_ANGLE .LT. -1.0D0 ) COS_ANGLE = -1.0D0
      ANGLE_ESM(I) = DACOS(COS_ANGLE)
      
C     ECLIPSE SOLAR: LUA ENTRE TERRA E SOL
C     VERIFICAR SE LUA ESTA MAIS PROXIMA DA TERRA QUE O SOL, E ALINHADA
C     ALINHAMENTO: ANGULO DEVE SER PEQUENO (LUA ENTRE TERRA E SOL)
      SOLAR_ECLIPSE(I) = 0
      IF ( DIST_EM(I) .LT. DIST_ES(I) .AND. 
     +     ANGLE_ESM(I) .LT. 0.2D0 .AND.
     +     DIST_MS(I) .LT. DIST_ES(I) ) THEN
      SOLAR_ECLIPSE(I) = 1
      END IF
      
C     ECLIPSE LUNAR: TERRA ENTRE SOL E LUA
C     VERIFICAR SE TERRA ESTA ENTRE SOL E LUA
C     ALINHAMENTO: ANGULO DEVE ESTAR PROXIMO DE PI (TERRA ENTRE)
      LUNAR_ECLIPSE(I) = 0
      IF ( DIST_ES(I) .LT. DIST_MS(I) .AND.
     +     ANGLE_ESM(I) .GT. (PI - 0.2D0) ) THEN
      LUNAR_ECLIPSE(I) = 1
      END IF
      END DO

C     ANALISAR ELIPSES ORBITAIS
C     ENCONTRAR PERIHELIO E AFELIO PARA TERRA E LUA
      R_MIN_EARTH = DIST_ES(1)
      R_MAX_EARTH = DIST_ES(1)
      R_MIN_MOON = DIST_EM(1)
      R_MAX_MOON = DIST_EM(1)
      DO I = 2, NSTEPS
      IF ( DIST_ES(I) .LT. R_MIN_EARTH ) R_MIN_EARTH = DIST_ES(I)
      IF ( DIST_ES(I) .GT. R_MAX_EARTH ) R_MAX_EARTH = DIST_ES(I)
      IF ( DIST_EM(I) .LT. R_MIN_MOON ) R_MIN_MOON = DIST_EM(I)
      IF ( DIST_EM(I) .GT. R_MAX_MOON ) R_MAX_MOON = DIST_EM(I)
      END DO
      
      SEMI_MAJOR_EARTH = (R_MIN_EARTH + R_MAX_EARTH) / 2.0D0
      SEMI_MAJOR_MOON = (R_MIN_MOON + R_MAX_MOON) / 2.0D0
      ECCENTRICITY_EARTH = (R_MAX_EARTH - R_MIN_EARTH) / 
     +                     (R_MAX_EARTH + R_MIN_EARTH)
      ECCENTRICITY_MOON = (R_MAX_MOON - R_MIN_MOON) / 
     +                    (R_MAX_MOON + R_MIN_MOON)

C     SAIDA DOS RESULTADOS
      OPEN(UNIT=10,FILE=FNAME,STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10,45) TIME(I), (BODY(J,I,1), BODY(J,I,2), 
     *             VEL(J,I,1), VEL(J,I,2), J=1,NBODY),
     *             DIST_ES(I), DIST_EM(I), DIST_MS(I),
     *             ANGLE_ESM(I), DBLE(SOLAR_ECLIPSE(I)), 
     *             DBLE(LUNAR_ECLIPSE(I))
      END DO
      CLOSE(10)

C     ANALISE DE ECLIPSES E ELIPSES
      OPEN(UNIT=11,FILE="analysis-b4-eclipse-15457752.out",STATUS=
     +     "UNKNOWN")
      WRITE(11,*) "ANALISE DE ECLIPSES E ELIPSES ORBITAIS"
      WRITE(11,*) "======================================"
      WRITE(11,*) ""
      WRITE(11,*) "Elipses Orbitais:"
      WRITE(11,50) "Perihelio Terra-Sol:", R_MIN_EARTH, "UA"
      WRITE(11,50) "Afelio Terra-Sol:", R_MAX_EARTH, "UA"
      WRITE(11,50) "Semi-eixo maior Terra-Sol:", SEMI_MAJOR_EARTH, "UA"
      WRITE(11,51) "Excentricidade Terra-Sol:", ECCENTRICITY_EARTH
      WRITE(11,*) ""
      WRITE(11,50) "Distancia minima Lua-Terra:", R_MIN_MOON, "UA"
      WRITE(11,50) "Distancia maxima Lua-Terra:", R_MAX_MOON, "UA"
      WRITE(11,50) "Semi-eixo maior Lua-Terra:", SEMI_MAJOR_MOON, "UA"
      WRITE(11,51) "Excentricidade Lua-Terra:", ECCENTRICITY_MOON
      WRITE(11,*) ""
      WRITE(11,*) "Eventos de Eclipse:"
      N_SOLAR = 0
      N_LUNAR = 0
      DO I = 1, NSTEPS
      IF ( SOLAR_ECLIPSE(I) .EQ. 1 ) N_SOLAR = N_SOLAR + 1
      IF ( LUNAR_ECLIPSE(I) .EQ. 1 ) N_LUNAR = N_LUNAR + 1
      END DO
      WRITE(11,52) "Numero de eclipses solares:", N_SOLAR
      WRITE(11,52) "Numero de eclipses lunares:", N_LUNAR
      WRITE(11,*) ""
      WRITE(11,*) "Tempos de Eclipse Solar (quando Lua esta entre"
      WRITE(11,*) "Terra e Sol):"
      DO I = 1, NSTEPS
      IF ( SOLAR_ECLIPSE(I) .EQ. 1 ) THEN
      WRITE(11,53) TIME(I), DIST_EM(I), ANGLE_ESM(I)
      END IF
      END DO
      WRITE(11,*) ""
      WRITE(11,*) "Tempos de Eclipse Lunar (quando Terra esta entre"
      WRITE(11,*) "Sol e Lua):"
      DO I = 1, NSTEPS
      IF ( LUNAR_ECLIPSE(I) .EQ. 1 ) THEN
      WRITE(11,53) TIME(I), DIST_ES(I), ANGLE_ESM(I)
      END IF
      END DO
50    FORMAT(A30,1X,E15.8,1X,A)
51    FORMAT(A30,1X,E15.8)
52    FORMAT(A30,1X,I10)
53    FORMAT("  Tempo:",F10.6," anos, Distancia:",E12.5," UA, Angulo:",
     +       E12.5," rad")
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

