      PROGRAM MAIN
      DOUBLE PRECISION BR, SR, SUR, VOL, DPI
      DPI = DACOS(-1.0D0)

      WRITE(6,'(A)') 'ENTRE COM BR E SR:'
      READ(5,'(F5.2,F5.2)') BR, SR

      SUR = 4 * DPI ** 2 * BR * SR
      VOL = 2 * DPI ** 2 * BR * SR ** 2

      WRITE(6,'(A,F9.2,F9.2)') 'OS VOLUMES SAO:', SUR, VOL
      END
