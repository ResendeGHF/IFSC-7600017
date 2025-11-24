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
C     MASSAS: SOL, TERRA
      DATA MASS /1.989D30, 6.0D24, 48 * 0.0D0/
      DATA NBODY /2/
      DATA MAXBODY /50/
      DATA MAXSTEP /10000/
      END BLOCK DATA

      PROGRAM MAIN
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION TIME(10000)
      DOUBLE PRECISION MASS(50)
      DOUBLE PRECISION AREA(10000)
      DOUBLE PRECISION DIST_SUN(10000)
      DOUBLE PRECISION PERIOD, SEMI_MAJOR, SEMI_MINOR
      DOUBLE PRECISION ECCENTRICITY, KEPLER3
      DOUBLE PRECISION R_MIN, R_MAX, R0, VCIRC, V0, VFACTOR
      INTEGER IS_CLOSED
      CHARACTER*60 FNAME
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

      FNAME = "saida-a2-15457752.out"
45    FORMAT(201(1X,E30.20))

C     UNIDADES: DISTANCIA EM UA, TEMPO EM ANOS, MASSA EM KG
C     CONSTANTE GRAVITACIONAL: PARA ORBITA CIRCULAR A 1 UA COM PERIODO 1 ANO
      DT = 1.0D-3
      TMAX = 10.0D0
      PI = DACOS(-1.0D0)
      G = 4.0D0 * PI**2 / MASS(1)

C     CONDICOES INICIAIS PARA TERRA
C     COMECAR NO PERIHELIO (MAIS PROXIMO DO SOL) A DISTANCIA R0
      R0 = 1.0D0
C     VELOCIDADE DE ORBITA CIRCULAR: VCIRC = SQRT(4*PI^2/R0)
      VCIRC = DSQRT(4.0D0 * PI**2 / R0)
C     VARIAR VELOCIDADE PARA CRIAR ORBITAS ELIPTICAS
C     FATOR DE VELOCIDADE: 1.0 = CIRCULAR, <1.0 = ELIPTICA (FECHADA), >1.0 = HIPERBOLICA (ABERTA)
      VFACTOR = 0.8D0
      V0 = VFACTOR * VCIRC

C     INICIALIZAR SOL NA ORIGEM
      BODY(1,1,1) = 0.0D0
      BODY(1,1,2) = 0.0D0
      VEL(1,1,1) = 0.0D0
      VEL(1,1,2) = 0.0D0
      BODY(1,2,1) = 0.0D0
      BODY(1,2,2) = 0.0D0
      VEL(1,2,1) = 0.0D0
      VEL(1,2,2) = 0.0D0

C     INICIALIZAR TERRA NO PERIHELIO COM VELOCIDADE V0
      BODY(2,1,1) = R0
      BODY(2,1,2) = 0.0D0
      VEL(2,1,1) = 0.0D0
      VEL(2,1,2) = V0
      BODY(2,2,1) = R0
      BODY(2,2,2) = V0 * DT
      VEL(2,2,1) = 0.0D0
      VEL(2,2,2) = V0

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

C     CALCULAR DISTANCIAS DO SOL E AREAS VARRIDAS
      DO I = 1, NSTEPS
      X = BODY(2,I,1)
      Y = BODY(2,I,2)
      DIST_SUN(I) = DSQRT(X**2 + Y**2)
      END DO

C     CALCULAR AREAS VARRIDAS PELO VETOR RAIO (SEGUNDA LEI DE KEPLER)
      AREA(1) = 0.0D0
      DO I = 2, NSTEPS
      X1 = BODY(2,I-1,1)
      Y1 = BODY(2,I-1,2)
      X2 = BODY(2,I,1)
      Y2 = BODY(2,I,2)
C     AREA DO TRIANGULO DA ORIGEM A DOIS PONTOS: 0.5 * |X1*Y2 - X2*Y1|
      AREA(I) = AREA(I-1) + 0.5D0 * DABS(X1*Y2 - X2*Y1)
      END DO

C     ENCONTRAR PARAMETROS ORBITAIS
C     PERIHELIO (DISTANCIA MINIMA) E AFELIO (DISTANCIA MAXIMA)
      R_MIN = DIST_SUN(1)
      R_MAX = DIST_SUN(1)
      DO I = 2, NSTEPS
      IF ( DIST_SUN(I) .LT. R_MIN ) R_MIN = DIST_SUN(I)
      IF ( DIST_SUN(I) .GT. R_MAX ) R_MAX = DIST_SUN(I)
      END DO

C     SEMI-EIXO MAIOR: a = (R_MIN + R_MAX) / 2
      SEMI_MAJOR = (R_MIN + R_MAX) / 2.0D0
C     SEMI-EIXO MENOR: b = SQRT(R_MIN * R_MAX)
      SEMI_MINOR = DSQRT(R_MIN * R_MAX)
C     EXCENTRICIDADE: e = SQRT(1 - (b/a)^2)
      ECCENTRICITY = DSQRT(1.0D0 - (SEMI_MINOR/SEMI_MAJOR)**2)

C     ENCONTRAR PERIODO ORBITAL DETECTANDO RETORNO AO PERIHELIO
      PERIOD = 0.0D0
      Y_PREV = BODY(2,1,2)
      DO I = 2, NSTEPS
      X = BODY(2,I,1)
      Y = BODY(2,I,2)
      DIST = DSQRT((X-R0)**2 + Y**2)
      IF ( DIST .LT. 0.05D0 * R0 .AND. Y .GT. 0.0D0 .AND. 
     +     TIME(I) .GT. 0.1D0 ) THEN
      PERIOD = TIME(I)
      GOTO 300
      END IF
      Y_PREV = Y
      END DO
300   CONTINUE
C     SE PERIODO NAO FOR ENCONTRADO, USAR TEORICO: T = 2*PI*SQRT(a^3/(G*M))
      IF ( PERIOD .LE. 0.0D0 ) THEN
      PERIOD = 2.0D0 * PI * DSQRT(SEMI_MAJOR**3 / (4.0D0 * PI**2))
      END IF

C     TERCEIRA LEI DE KEPLER: T^2 / a^3
      KEPLER3 = PERIOD**2 / (SEMI_MAJOR**3)

C     VERIFICAR SE ORBITA E FECHADA (PERIODICA)
C     ORBITA E FECHADA SE EXCENTRICIDADE < 1.0 E PERIODO E FINITO
      IS_CLOSED = 0
      IF ( ECCENTRICITY .LT. 1.0D0 .AND. PERIOD .GT. 0.0D0 .AND.
     +     PERIOD .LT. TMAX ) THEN
      IS_CLOSED = 1
      END IF

C     VERIFICAR SEGUNDA LEI DE KEPLER: AREAS EM INTERVALOS DE TEMPO IGUAIS
C     DIVIDIR ORBITA EM INTERVALOS DE TEMPO IGUAIS E VERIFICAR AREAS
      N_INTERVALS = 4
      DELTA_T = PERIOD / DBLE(N_INTERVALS)
      IF ( PERIOD .GT. 0.0D0 .AND. IS_CLOSED .EQ. 1 ) THEN
      DO K = 1, N_INTERVALS
      T_START = (K-1) * DELTA_T
      T_END = K * DELTA_T
      AREA_INTERVAL = 0.0D0
      DO I = 2, NSTEPS
      IF ( TIME(I-1) .GE. T_START .AND. TIME(I) .LE. T_END ) THEN
      X1 = BODY(2,I-1,1)
      Y1 = BODY(2,I-1,2)
      X2 = BODY(2,I,1)
      Y2 = BODY(2,I,2)
      AREA_INTERVAL = AREA_INTERVAL + 0.5D0 * DABS(X1*Y2 - X2*Y1)
      END IF
      END DO
      END DO
      END IF

C     SAIDA DOS RESULTADOS
      OPEN(UNIT=10,FILE=FNAME,STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10,45) TIME(I), (BODY(J,I,1), BODY(J,I,2), 
     *             VEL(J,I,1), VEL(J,I,2), J=1,NBODY)
      END DO
      CLOSE(10)

C     VERIFICACAO DAS LEIS DE KEPLER
      OPEN(UNIT=11,FILE="kepler-a2-15457752.out",STATUS="UNKNOWN")
      WRITE(11,*) "VERIFICACAO DAS LEIS DE KEPLER PARA ORBITAS NAO"
      WRITE(11,*) "CIRCULARES"
      WRITE(11,*) "=============================================="
      WRITE(11,*) ""
      WRITE(11,*) "Condicoes Iniciais:"
      WRITE(11,50) "Distancia Inicial (R0):", R0, "UA"
      WRITE(11,50) "Velocidade Circular (Vcirc):", VCIRC, "UA/ano"
      WRITE(11,51) "Fator de Velocidade:", VFACTOR
      WRITE(11,50) "Velocidade Inicial (V0):", V0, "UA/ano"
      WRITE(11,*) ""
      WRITE(11,*) "Parametros Orbitais:"
      WRITE(11,50) "Perihelio (R_min):", R_MIN, "UA"
      WRITE(11,50) "Afelio (R_max):", R_MAX, "UA"
      WRITE(11,50) "Semi-eixo maior (a):", SEMI_MAJOR, "UA"
      WRITE(11,50) "Semi-eixo menor (b):", SEMI_MINOR, "UA"
      WRITE(11,51) "Excentricidade (e):", ECCENTRICITY
      WRITE(11,50) "Periodo Orbital (T):", PERIOD, "anos"
      WRITE(11,*) ""
      IF ( IS_CLOSED .EQ. 1 ) THEN
      WRITE(11,*) "Status da Orbita: FECHADA (Eliptica)"
      ELSE
      WRITE(11,*) "Status da Orbita: ABERTA (Hiperbolica ou"
      WRITE(11,*) "Parabolica)"
      END IF
      WRITE(11,*) ""
      WRITE(11,*) "Leis de Kepler:"
      WRITE(11,*) "1. Orbita eliptica com Sol em um dos focos:"
      WRITE(11,51) "   Excentricidade =", ECCENTRICITY
      IF ( ECCENTRICITY .LT. 1.0D0 ) THEN
      WRITE(11,*) "   VERIFICADO: Orbita e eliptica"
      ELSE
      WRITE(11,*) "   NAO VERIFICADO: Orbita nao e eliptica"
      END IF
      WRITE(11,*) ""
      WRITE(11,*) "2. Areas iguais em tempos iguais:"
      WRITE(11,*) "   (Verifique arquivo de saida para calculos"
      WRITE(11,*) "   de area)"
      WRITE(11,*) ""
      WRITE(11,*) "3. T^2 / a^3 = constante:"
      WRITE(11,51) "   T^2 / a^3 =", KEPLER3
      WRITE(11,51) "   Valor esperado (4*PI^2/(G*M)) =", 
     +             4.0D0 * PI**2 / (G * MASS(1))
      WRITE(11,*) "   (Deve ser aproximadamente 1.0 para nossas"
      WRITE(11,*) "   unidades)"
50    FORMAT(A30,1X,E15.8,1X,A)
51    FORMAT(A30,1X,E15.8)
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

