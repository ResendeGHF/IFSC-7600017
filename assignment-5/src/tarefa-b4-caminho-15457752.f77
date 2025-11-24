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
C     MASSAS: SOL, MERCURIO, VENUS, TERRA, MARTE, JUPITER, SATURNO, URANO, NETUNO, PLUTAO
      DATA MASS /1.989D30, 2.4D23, 4.9D24, 6.0D24, 6.6D23, 1.9D27,
     +           5.7D26, 8.8D25, 1.03D26, 6.0D24, 40 * 0.0D0/
      DATA NBODY /10/
      DATA MAXBODY /50/
      DATA MAXSTEP /10000/
      END BLOCK DATA

      PROGRAM MAIN
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION TIME(10000)
      DOUBLE PRECISION MASS(50)
      DOUBLE PRECISION RADIUS(10)
      DOUBLE PRECISION REL_POS(50,10000,2)
      CHARACTER*60 FNAME(10)
      CHARACTER*30 BODY_NAME(10)
      INTEGER PLANET_IDX
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

C     NOMES DOS CORPOS PARA ARQUIVOS DE SAIDA
      BODY_NAME(1) = "sol"
      BODY_NAME(2) = "mercurio"
      BODY_NAME(3) = "venus"
      BODY_NAME(4) = "terra"
      BODY_NAME(5) = "marte"
      BODY_NAME(6) = "jupiter"
      BODY_NAME(7) = "saturno"
      BODY_NAME(8) = "urano"
      BODY_NAME(9) = "netuno"
      BODY_NAME(10) = "plutao"

45    FORMAT(201(1X,E30.20))

C     UNIDADES: DISTANCIA EM UA, TEMPO EM ANOS, MASSA EM KG
      DT = 1.0D-3
      TMAX = 1.0D0
      PI = DACOS(-1.0D0)
      G = 4.0D0 * PI**2 / MASS(1)

C     RAIOS PLANETARIOS EM UA (DA TABELA)
      RADIUS(1) = 0.39D0
      RADIUS(2) = 0.72D0
      RADIUS(3) = 1.00D0
      RADIUS(4) = 1.52D0
      RADIUS(5) = 5.20D0
      RADIUS(6) = 9.24D0
      RADIUS(7) = 19.19D0
      RADIUS(8) = 30.06D0
      RADIUS(9) = 39.53D0

C     INICIALIZAR SOL NA ORIGEM
      BODY(1,1,1) = 0.0D0
      BODY(1,1,2) = 0.0D0
      VEL(1,1,1) = 0.0D0
      VEL(1,1,2) = 0.0D0
      BODY(1,2,1) = 0.0D0
      BODY(1,2,2) = 0.0D0
      VEL(1,2,1) = 0.0D0
      VEL(1,2,2) = 0.0D0

C     INICIALIZAR PLANETAS EM SEUS RAIOS COM VELOCIDADES DE ORBITA CIRCULAR
      DO J = 2, NBODY
      PLANET_IDX = J - 1
      R = RADIUS(PLANET_IDX)
      VCIRC = DSQRT(4.0D0 * PI**2 / R)
      BODY(J,1,1) = R
      BODY(J,1,2) = 0.0D0
      VEL(J,1,1) = 0.0D0
      VEL(J,1,2) = VCIRC
      BODY(J,2,1) = R
      BODY(J,2,2) = VCIRC * DT
      VEL(J,2,1) = 0.0D0
      VEL(J,2,2) = VCIRC
      END DO

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

C     CALCULAR POSICOES RELATIVAS DA PERSPECTIVA DA TERRA
C     TERRA E O CORPO 4 (INDICE 4)
      EARTH_IDX = 4
      DO I = 1, NSTEPS
      X_EARTH = BODY(EARTH_IDX,I,1)
      Y_EARTH = BODY(EARTH_IDX,I,2)
      DO J = 1, NBODY
      REL_POS(J,I,1) = BODY(J,I,1) - X_EARTH
      REL_POS(J,I,2) = BODY(J,I,2) - Y_EARTH
      END DO
      END DO

C     SAIDA DAS POSICOES RELATIVAS PARA CADA CORPO
      DO J = 1, NBODY
      IF ( J .EQ. 1 ) THEN
      FNAME(J) = "saida-b4-sol-15457752.out"
      ELSE IF ( J .EQ. 2 ) THEN
      FNAME(J) = "saida-b4-mercurio-15457752.out"
      ELSE IF ( J .EQ. 3 ) THEN
      FNAME(J) = "saida-b4-venus-15457752.out"
      ELSE IF ( J .EQ. 4 ) THEN
      FNAME(J) = "saida-b4-terra-15457752.out"
      ELSE IF ( J .EQ. 5 ) THEN
      FNAME(J) = "saida-b4-marte-15457752.out"
      ELSE IF ( J .EQ. 6 ) THEN
      FNAME(J) = "saida-b4-jupiter-15457752.out"
      ELSE IF ( J .EQ. 7 ) THEN
      FNAME(J) = "saida-b4-saturno-15457752.out"
      ELSE IF ( J .EQ. 8 ) THEN
      FNAME(J) = "saida-b4-urano-15457752.out"
      ELSE IF ( J .EQ. 9 ) THEN
      FNAME(J) = "saida-b4-netuno-15457752.out"
      ELSE
      FNAME(J) = "saida-b4-plutao-15457752.out"
      END IF
      OPEN(UNIT=10+J,FILE=FNAME(J),STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10+J,45) TIME(I), REL_POS(J,I,1), REL_POS(J,I,2)
      END DO
      CLOSE(10+J)
      END DO

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

