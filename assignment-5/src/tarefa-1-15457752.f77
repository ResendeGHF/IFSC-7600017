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
C     MASSAS: TRES PARTICULAS DE MESMA MASSA M
C     PARA SIMPLICIDADE, USAREMOS M = 1.0 (UNIDADES ADIMENSIONAIS)
      DATA MASS /1.0D0, 1.0D0, 1.0D0, 47 * 0.0D0/
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
      DOUBLE PRECISION DIST_12(10000)
      DOUBLE PRECISION DIST_13(10000)
      DOUBLE PRECISION DIST_23(10000)
      DOUBLE PRECISION DIST_CM(10000,3)
      DOUBLE PRECISION R_CM_MEAN(3)
      DOUBLE PRECISION R_CM_MIN(3)
      DOUBLE PRECISION R_CM_MAX(3)
      CHARACTER*60 FNAME
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

      FNAME = "saida-1-15457752.out"
45    FORMAT(201(1X,E30.20))

C     PROBLEMA DE LAGRANGE: 3 PARTICULAS DE MESMA MASSA
C     MOVENDO-SE EM ORBITA CIRCULAR FORMANDO TRIANGULO EQUILATERO
C     UNIDADES: DISTANCIA E TEMPO ADIMENSIONAIS
C     CONSTANTE GRAVITACIONAL: G = 1.0 (UNIDADES ADIMENSIONAIS)
      DT = 1.0D-3
      TMAX = 10.0D0
      PI = DACOS(-1.0D0)
      G = 1.0D0

C     VELOCIDADE INICIAL: v0 = 3^(-1/4)
      V0 = 3.0D0 ** (-0.25D0)

C     INICIALIZAR PARTICULA 1
C     POSICAO: (1.0, 0.0)
C     VELOCIDADE: (0.0, v0)
      BODY(1,1,1) = 1.0D0
      BODY(1,1,2) = 0.0D0
      VEL(1,1,1) = 0.0D0
      VEL(1,1,2) = V0

C     INICIALIZAR PARTICULA 2
C     POSICAO: (-0.5, sqrt(3)/2)
C     VELOCIDADE: (-sqrt(3)/2 * v0, -1/2 * v0)
      BODY(2,1,1) = -0.5D0
      BODY(2,1,2) = DSQRT(3.0D0) / 2.0D0
      VEL(2,1,1) = -DSQRT(3.0D0) / 2.0D0 * V0
      VEL(2,1,2) = -0.5D0 * V0

C     INICIALIZAR PARTICULA 3
C     POSICAO: (-0.5, -sqrt(3)/2)
C     VELOCIDADE: (sqrt(3)/2 * v0, -1/2 * v0)
      BODY(3,1,1) = -0.5D0
      BODY(3,1,2) = -DSQRT(3.0D0) / 2.0D0
      VEL(3,1,1) = DSQRT(3.0D0) / 2.0D0 * V0
      VEL(3,1,2) = -0.5D0 * V0

C     CALCULAR POSICOES NO SEGUNDO PASSO (VERLET)
      TIME(1) = 0.0D0
      TIME(2) = DT
      DO J = 1, NBODY
      CALL RAC(J,1,AX,AY)
      BODY(J,2,1) = BODY(J,1,1) + VEL(J,1,1)*DT + 0.5D0*AX*DT**2
      BODY(J,2,2) = BODY(J,1,2) + VEL(J,1,2)*DT + 0.5D0*AY*DT**2
      VEL(J,2,1) = VEL(J,1,1) + AX*DT
      VEL(J,2,2) = VEL(J,1,2) + AY*DT
      END DO
      
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

C     CALCULAR DISTANCIAS ENTRE PARTICULAS E DISTANCIAS AO CENTRO DE MASSA
C     VERIFICAR QUE AS DISTANCIAS ENTRE PARTICULAS PERMANECEM CONSTANTES
C     E QUE AS ORBITAS SAO CIRCULARES
      DO I = 1, NSTEPS
C     DISTANCIAS ENTRE PARES DE PARTICULAS
      DIST_12(I) = DSQRT((BODY(1,I,1) - BODY(2,I,1))**2 + 
     +                   (BODY(1,I,2) - BODY(2,I,2))**2)
      DIST_13(I) = DSQRT((BODY(1,I,1) - BODY(3,I,1))**2 + 
     +                   (BODY(1,I,2) - BODY(3,I,2))**2)
      DIST_23(I) = DSQRT((BODY(2,I,1) - BODY(3,I,1))**2 + 
     +                   (BODY(2,I,2) - BODY(3,I,2))**2)
      
C     CENTRO DE MASSA (CM)
      CM_X = (BODY(1,I,1) + BODY(2,I,1) + BODY(3,I,1)) / 3.0D0
      CM_Y = (BODY(1,I,2) + BODY(2,I,2) + BODY(3,I,2)) / 3.0D0
      
C     DISTANCIAS DE CADA PARTICULA AO CM
      DIST_CM(I,1) = DSQRT((BODY(1,I,1) - CM_X)**2 + 
     +                     (BODY(1,I,2) - CM_Y)**2)
      DIST_CM(I,2) = DSQRT((BODY(2,I,1) - CM_X)**2 + 
     +                     (BODY(2,I,2) - CM_Y)**2)
      DIST_CM(I,3) = DSQRT((BODY(3,I,1) - CM_X)**2 + 
     +                     (BODY(3,I,2) - CM_Y)**2)
      END DO

C     SAIDA DOS RESULTADOS
      OPEN(UNIT=10,FILE=FNAME,STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10,45) TIME(I), (BODY(J,I,1), BODY(J,I,2), 
     *             VEL(J,I,1), VEL(J,I,2), J=1,NBODY),
     *             DIST_12(I), DIST_13(I), DIST_23(I),
     *             DIST_CM(I,1), DIST_CM(I,2), DIST_CM(I,3)
      END DO
      CLOSE(10)

C     ANALISE DOS RESULTADOS
      OPEN(UNIT=11,FILE="analysis-1-15457752.out",STATUS="UNKNOWN")
      WRITE(11,*) "PROBLEMA DE LAGRANGE: TRIANGULO EQUILATERO"
      WRITE(11,*) "=========================================="
      WRITE(11,*) ""
      WRITE(11,*) "Condicoes Iniciais:"
      WRITE(11,*) "Particula 1: posicao (1.0, 0.0), velocidade"
      WRITE(11,*) "             (0.0, v0)"
      WRITE(11,*) "Particula 2: posicao (-0.5, sqrt(3)/2),"
      WRITE(11,*) "             velocidade (-sqrt(3)/2*v0, -v0/2)"
      WRITE(11,*) "Particula 3: posicao (-0.5, -sqrt(3)/2),"
      WRITE(11,*) "             velocidade (sqrt(3)/2*v0, -v0/2)"
      WRITE(11,51) "v0 = 3^(-1/4) =", V0
      WRITE(11,*) ""
      
C     CALCULAR ESTATISTICAS DAS DISTANCIAS
      DIST_12_MEAN = 0.0D0
      DIST_13_MEAN = 0.0D0
      DIST_23_MEAN = 0.0D0
      DIST_12_MIN = DIST_12(1)
      DIST_12_MAX = DIST_12(1)
      DIST_13_MIN = DIST_13(1)
      DIST_13_MAX = DIST_13(1)
      DIST_23_MIN = DIST_23(1)
      DIST_23_MAX = DIST_23(1)
      
      DO I = 1, NSTEPS
      DIST_12_MEAN = DIST_12_MEAN + DIST_12(I)
      DIST_13_MEAN = DIST_13_MEAN + DIST_13(I)
      DIST_23_MEAN = DIST_23_MEAN + DIST_23(I)
      IF ( DIST_12(I) .LT. DIST_12_MIN ) DIST_12_MIN = DIST_12(I)
      IF ( DIST_12(I) .GT. DIST_12_MAX ) DIST_12_MAX = DIST_12(I)
      IF ( DIST_13(I) .LT. DIST_13_MIN ) DIST_13_MIN = DIST_13(I)
      IF ( DIST_13(I) .GT. DIST_13_MAX ) DIST_13_MAX = DIST_13(I)
      IF ( DIST_23(I) .LT. DIST_23_MIN ) DIST_23_MIN = DIST_23(I)
      IF ( DIST_23(I) .GT. DIST_23_MAX ) DIST_23_MAX = DIST_23(I)
      END DO
      
      DIST_12_MEAN = DIST_12_MEAN / DBLE(NSTEPS)
      DIST_13_MEAN = DIST_13_MEAN / DBLE(NSTEPS)
      DIST_23_MEAN = DIST_23_MEAN / DBLE(NSTEPS)
      
      WRITE(11,*) "Distancias entre particulas:"
      WRITE(11,50) "Distancia media 1-2:", DIST_12_MEAN
      WRITE(11,50) "Distancia media 1-3:", DIST_13_MEAN
      WRITE(11,50) "Distancia media 2-3:", DIST_23_MEAN
      WRITE(11,*) ""
      WRITE(11,*) "Variacao das distancias:"
      WRITE(11,52) "Dist 1-2: min =", DIST_12_MIN, "max =", DIST_12_MAX
      WRITE(11,52) "Dist 1-3: min =", DIST_13_MIN, "max =", DIST_13_MAX
      WRITE(11,52) "Dist 2-3: min =", DIST_23_MIN, "max =", DIST_23_MAX
      WRITE(11,*) ""
      
C     CALCULAR ESTATISTICAS DAS DISTANCIAS AO CM
      R_CM_MEAN(1) = 0.0D0
      R_CM_MEAN(2) = 0.0D0
      R_CM_MEAN(3) = 0.0D0
      R_CM_MIN(1) = DIST_CM(1,1)
      R_CM_MAX(1) = DIST_CM(1,1)
      R_CM_MIN(2) = DIST_CM(1,2)
      R_CM_MAX(2) = DIST_CM(1,2)
      R_CM_MIN(3) = DIST_CM(1,3)
      R_CM_MAX(3) = DIST_CM(1,3)
      
      DO I = 1, NSTEPS
      R_CM_MEAN(1) = R_CM_MEAN(1) + DIST_CM(I,1)
      R_CM_MEAN(2) = R_CM_MEAN(2) + DIST_CM(I,2)
      R_CM_MEAN(3) = R_CM_MEAN(3) + DIST_CM(I,3)
      IF ( DIST_CM(I,1) .LT. R_CM_MIN(1) ) R_CM_MIN(1) = DIST_CM(I,1)
      IF ( DIST_CM(I,1) .GT. R_CM_MAX(1) ) R_CM_MAX(1) = DIST_CM(I,1)
      IF ( DIST_CM(I,2) .LT. R_CM_MIN(2) ) R_CM_MIN(2) = DIST_CM(I,2)
      IF ( DIST_CM(I,2) .GT. R_CM_MAX(2) ) R_CM_MAX(2) = DIST_CM(I,2)
      IF ( DIST_CM(I,3) .LT. R_CM_MIN(3) ) R_CM_MIN(3) = DIST_CM(I,3)
      IF ( DIST_CM(I,3) .GT. R_CM_MAX(3) ) R_CM_MAX(3) = DIST_CM(I,3)
      END DO
      
      R_CM_MEAN(1) = R_CM_MEAN(1) / DBLE(NSTEPS)
      R_CM_MEAN(2) = R_CM_MEAN(2) / DBLE(NSTEPS)
      R_CM_MEAN(3) = R_CM_MEAN(3) / DBLE(NSTEPS)
      
      WRITE(11,*) "Distancias ao centro de massa:"
      WRITE(11,50) "Raio medio orbita particula 1:", R_CM_MEAN(1)
      WRITE(11,50) "Raio medio orbita particula 2:", R_CM_MEAN(2)
      WRITE(11,50) "Raio medio orbita particula 3:", R_CM_MEAN(3)
      WRITE(11,*) ""
      WRITE(11,*) "Variacao dos raios orbitais:"
      WRITE(11,52) "Particula 1: min =", R_CM_MIN(1), "max =", 
     +             R_CM_MAX(1)
      WRITE(11,52) "Particula 2: min =", R_CM_MIN(2), "max =", 
     +             R_CM_MAX(2)
      WRITE(11,52) "Particula 3: min =", R_CM_MIN(3), "max =", 
     +             R_CM_MAX(3)
      WRITE(11,*) ""
      WRITE(11,*) "Conclusao:"
      WRITE(11,*) "Se as distancias entre particulas permanecem"
      WRITE(11,*) "constantes e os raios orbitais ao CM sao"
      WRITE(11,*) "constantes, entao as orbitas sao circulares."
50    FORMAT(A30,1X,E15.8)
51    FORMAT(A30,1X,E15.8)
52    FORMAT(A30,1X,E15.8,1X,A5,1X,E15.8)
      CLOSE(11)

      END

      FUNCTION AC(AM2, CORD, DIST)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     COMPONENTE DE ACELERACAO DEVIDA A M2 NA DIRECAO CORD
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      DOUBLE PRECISION BODY(50,10000,2)
      DOUBLE PRECISION VEL(50,10000,2)
      DOUBLE PRECISION MASS(50)
      G = 1.0D0
      AC = (G * AM2 * CORD) / (DIST ** 3)
      END

      FUNCTION DIST(X1,Y1,X2,Y2)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     DISTANCIA ENTRE OS PONTOS (X1,Y1) E (X2,Y2)
      DIST = ( (X2-X1) ** 2 + (Y2-Y1) ** 2 ) 
     + ** ( 1.0D0/2.0D0 )
      END

      SUBROUTINE RAC(I,J,ACX,ACY)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     CALCULA ACELERACAO TOTAL DO CORPO I NO PASSO DE TEMPO J
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

