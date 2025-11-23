      BLOCK DATA
      COMMON /ARRAYS/ BODY, MASS, NBODY
      DATA BODY /40000 * 0.0/
      DATA MASS / 333000, 1 /
      DATA NBODY /2/
      END BLOCK DATA

      PROGRAM MAIN
      REAL BODY(2,10000,2)
      REAL TIME(10000)
      REAL MASS(2)
      CHARACTER*60 FNAME
      INTEGER NBODY ! NECESSARIO PASSAR POR REFERENCIA P/ SUBROUTINE
      COMMON /ARRAYS/ BODY, MASS, NBODY
      DATA BODY /40000 * 0.0/

      FNAME = "saida-a1-15457752.out"
45    FORMAT(F15.10,F15.10,F15.10)

      DT = 10-3
      PI = ACOS(-1.0)

      BODY(2,1,1) = 1
      BODY(2,1,2) = 0
      TIME(1) = 0
      TIME(2) = DT
      
      VX0 = SQRT(PI)
      VY0 = SQRT(PI)

      BODY(2,2,1) = BODY(2,1,1) + VX0*DT
      BODY(2,2,2) = BODY(2,1,2) + VY0*DT
      
100   CONTINUE
      I = 3
      IF ( T .GE. TMAX ) GOTO 200
      TIME(I) = DT * ( I - 1 )
      DO J = 1, NBODY
      CALL RAC(J,(I-1),AX,AY)
      BODY(J,I,1) = 2 * BODY(J,(I-1),1) - BODY(J,(I-2),1) + AX * DT**2
      BODY(J,I,2) = 2 * BODY(J,(I-1),2) - BODY(J,(I-2),1) + AY * DT**2
      END DO
      GOTO 100
200   CONTINUE

      OPEN(UNIT=10,FILE=FNAME,STATUS="UNKNOWN")
      WRITE(10,45) TIME, BODY
      CLOSE(10)

      END

      FUNCTION AC(M1, M2, CORD, DIST)
      ! M1 ACCELERETIOM DUE M2
      G = 2.97E-4
      AC =  ((G * M1 * M2 * CORD) / (DIST ** 3)) / M1
      END

      FUNCTION DIST(X1,Y1,X2,Y2)
      ! DIST R2 FROM R1
      DIST = ( (X2-X1) ** 2 + (Y2-Y1) ** 2 ) ** ( 1.0/2.0 )
      END

      SUBROUTINE RAC(I,J,ACX,ACY)
      COMMON /ARRAYS/ BODY, MASS, NBODY
      REAL ADIST(NBODY-1)
      ACX = 0
      ACY = 0
      X2 = BODY(I,J,1)
      Y2 = BODY(I,J,2)
      DO K = 1, NBODY
      X1 = BODY(K,J,1)
      Y1 = BODY(K,J,2)
      ADIST(K) = DIST(X1,Y1,X2,Y2)
      ACX = ACX + AC(MASSES(K),MASSES(I),X2,ADIST(K))
      ACY = ACY + AC(MASSES(K),MASSES(I),XY,ADIST(K))
      END DO
      END
