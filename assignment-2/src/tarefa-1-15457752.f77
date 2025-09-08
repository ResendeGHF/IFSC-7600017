      PROGRAM MAIN
      INTEGER I, ISIZE
      PARAMETER ( ISIZE = 10000 )
      INTEGER ISEED
      REAL RANDS, M1, M2, M3, M4, DATA(ISIZE)

      ISEED = 1154

      DO 10 I = 1, ISIZE
         DATA(I) = RANDS(ISEED)
         M1 = M1 + DATA(I) ** 1
         M2 = M2 + DATA(I) ** 2
         M3 = M3 + DATA(I) ** 3
         M4 = M4 + DATA(I) ** 4
10    CONTINUE
      M1 = M1 / ISIZE
      M2 = M2 / ISIZE
      M3 = M3 / ISIZE
      M4 = M4 / ISIZE

      WRITE (6,'(F7.5,A,F7.5,A,F7.5,A,F7.5)') M1,' ',M2,' ',M3,' ',M4
      END

      FUNCTION RANDS(ISEED)
c     TODO: Verificar overflow
      INTEGER ISEED, ACOPR, BCOPR, CMOD
      REAL RANDS

      PARAMETER ( ACOPR = 16807 )
      PARAMETER ( BCOPR = 15 )
      PARAMETER ( CMOD = 21474 )

      ISEED = MOD(ACOPR*ISEED+BCOPR,CMOD)
      RANDS = FLOAT(ISEED) / CMOD
      RETURN
      END
