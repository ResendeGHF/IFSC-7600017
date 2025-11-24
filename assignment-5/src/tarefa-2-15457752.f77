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
      CHARACTER*60 FNAME
      COMMON /ARRAYS/ BODY, VEL, MASS, NBODY
      COMMON /PARAMS/ MAXBODY, MAXSTEP

      FNAME = "saida-2-15457752.out"
45    FORMAT(201(1X,E30.20))

C     SOLUCAO "O OITO" (FIGURE-8) DE MOORE (1993)
C     3 PARTICULAS DE MESMA MASSA M
C     UNIDADES: DISTANCIA E TEMPO ADIMENSIONAIS
C     CONSTANTE GRAVITACIONAL: G = 1.0 (UNIDADES ADIMENSIONAIS)
      DT = 1.0D-3
      TMAX = 10.0D0
      PI = DACOS(-1.0D0)
      G = 1.0D0

C     INICIALIZAR PARTICULA 1
C     POSICAO: (0.97000436, -0.24308753)
C     VELOCIDADE: (0.466203685, 0.43236573)
      BODY(1,1,1) = 0.97000436D0
      BODY(1,1,2) = -0.24308753D0
      VEL(1,1,1) = 0.466203685D0
      VEL(1,1,2) = 0.43236573D0

C     INICIALIZAR PARTICULA 2
C     POSICAO: (-0.97000436, 0.24308753)
C     VELOCIDADE: (0.466203685, 0.43236573)
      BODY(2,1,1) = -0.97000436D0
      BODY(2,1,2) = 0.24308753D0
      VEL(2,1,1) = 0.466203685D0
      VEL(2,1,2) = 0.43236573D0

C     INICIALIZAR PARTICULA 3
C     POSICAO: (0.0, 0.0)
C     VELOCIDADE: (-0.93240737, -0.86473146)
      BODY(3,1,1) = 0.0D0
      BODY(3,1,2) = 0.0D0
      VEL(3,1,1) = -0.93240737D0
      VEL(3,1,2) = -0.86473146D0

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

C     SAIDA DOS RESULTADOS
      OPEN(UNIT=10,FILE=FNAME,STATUS="UNKNOWN")
      DO I = 1, NSTEPS
      WRITE(10,45) TIME(I), (BODY(J,I,1), BODY(J,I,2), 
     *             VEL(J,I,1), VEL(J,I,2), J=1,NBODY)
      END DO
      CLOSE(10)

C     ANALISE DOS RESULTADOS
C     MOSTRAR POSICOES EM ALGUNS INSTANTES DE TEMPO
      OPEN(UNIT=11,FILE="analysis-2-15457752.out",STATUS="UNKNOWN")
      WRITE(11,*) "SOLUCAO 'O OITO' (FIGURE-8) DE MOORE (1993)"
      WRITE(11,*) "==========================================="
      WRITE(11,*) ""
      WRITE(11,*) "Condicoes Iniciais:"
      WRITE(11,*) "Particula 1: posicao (0.97000436, -0.24308753),"
      WRITE(11,*) "             velocidade (0.466203685, 0.43236573)"
      WRITE(11,*) "Particula 2: posicao (-0.97000436, 0.24308753),"
      WRITE(11,*) "             velocidade (0.466203685, 0.43236573)"
      WRITE(11,*) "Particula 3: posicao (0.0, 0.0),"
      WRITE(11,*) "             velocidade (-0.93240737, -0.86473146)"
      WRITE(11,*) ""
      WRITE(11,*) "Evolucao das posicoes em instantes selecionados:"
      WRITE(11,*) ""
      WRITE(11,*) "Tempo    Particula 1 (x, y)    Particula 2 (x, y)"
      WRITE(11,*) "         Particula 3 (x, y)"
      WRITE(11,*) "------------------------------------------------"
      
C     SELECIONAR ALGUNS INSTANTES DE TEMPO PARA MOSTRAR
C     MOSTRAR EM t = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
      DO K = 0, 10
      T_SELECT = DBLE(K)
      I_CLOSEST = 1
      T_DIFF_MIN = DABS(TIME(1) - T_SELECT)
      DO I = 2, NSTEPS
      T_DIFF = DABS(TIME(I) - T_SELECT)
      IF ( T_DIFF .LT. T_DIFF_MIN ) THEN
      T_DIFF_MIN = T_DIFF
      I_CLOSEST = I
      END IF
      END DO
      WRITE(11,50) TIME(I_CLOSEST), BODY(1,I_CLOSEST,1), 
     +             BODY(1,I_CLOSEST,2), BODY(2,I_CLOSEST,1),
     +             BODY(2,I_CLOSEST,2), BODY(3,I_CLOSEST,1),
     +             BODY(3,I_CLOSEST,2)
      END DO
      
      WRITE(11,*) ""
      WRITE(11,*) "Nota: Esta solucao periodica forma uma orbita"
      WRITE(11,*) "em forma de '8' (figure-8), descoberta por"
      WRITE(11,*) "C. Moore em 1993 (Phys. Rev. Lett. 70, 3675)."
50    FORMAT(F6.3,3X,3(F10.6,1X,F10.6,3X))
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

