      PROGRAM MAIN
      REAL Q, AJM, V
      INTEGER N

      WRITE (6,'(A)') 'ENTRE COM Q, N, AJM'
      READ (5,*) Q, N, AJM

      V = ( Q * (AJM) ** N ) / N

      WRITE (6, '(A,F9.2)') 'O VALOR DAS PARCELAS E'':', V

      END
