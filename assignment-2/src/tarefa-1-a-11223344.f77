      BLOCK DATA
      INTEGER ISEED
      COMMON /LCGBLK/ ISEED
      DATA ISEED /1154/
      END

      PROGRAM MAIN
      INTEGER I, ISIZE
      PARAMETER (ISIZE=10000)
      REAL RANDS, RVAL, M1, M2, M3, M4
      DATA M1, M2, M3, M4 /4*0.0/

      DO 10 I = 1, ISIZE
         RVAL = RANDS()
         M1 = M1 + RVAL ** 1
         M2 = M2 + RVAL ** 2
         M3 = M3 + RVAL ** 3
         M4 = M4 + RVAL ** 4
10    CONTINUE
      M1 = M1 / ISIZE
      M2 = M2 / ISIZE
      M3 = M3 / ISIZE
      M4 = M4 / ISIZE

      WRITE (6,'(F7.5,A,F7.5,A,F7.5,A,F7.5)') M1,' ',M2,' ',M3,' ',M4
      END

      FUNCTION RANDS()
      INTEGER ISEED, ACOPR, BCOPR, CMOD
      COMMON /LCGBLK/ ISEED
      REAL RANDS

      PARAMETER ( ACOPR = 16807 )
      PARAMETER ( BCOPR = 15 )
      PARAMETER ( CMOD = 21474 )

      ISEED = MOD(ACOPR*ISEED+BCOPR,CMOD)
      RANDS = FLOAT(ISEED) / CMOD
      RETURN
      END

