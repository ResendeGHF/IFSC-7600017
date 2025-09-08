      PROGRAM MAIN
      CHARACTER*256 PATH
      INTEGER N

      PATH = 'tarefa-3-11223344.in'
      CALL SIZEOFFILE(PATH, N)
      WRITE(6,*) N
      END

      SUBROUTINE SIZEOFFILE(PATH,N)
      CHARACTER*256 PATH, LINE
      INTEGER N, IOS
      
      N = 0
      IOS = 0

      OPEN(UNIT=10, FILE=PATH, STATUS='OLD', IOSTAT=IOS)
      
      IF ( IOS .NE. 0 ) THEN
         WRITE(6,'(A,I1,A,A)') 'I/O ERROR AT FILE OPEN, ERROR COD:',
     1 IOS, ', FILE: ', PATH
         STOP
      END IF

10    READ(10,'(A)', END=20, ERR=30) LINE
      N = N + 1
      GOTO 10
20    CLOSE(10)
      RETURN
30    WRITE(6,'(A)') 'ERROR: READ ERROR ON UNIT 10'
      STOP
      END

      SUBROUTINE SORT(N,DATA,SORTED)
      INTEGER N, I, J
      REAL DATA(N), SORTED(N), KEY
      
      DO 40 I = 1, N
         SORTED(I) = DATA(I)
40    CONTINUE

      DO 60 I = 2, N
         KEY = SORTED(I)
         J = I - 1
50       IF (J .GE. 1 .AND. SORTED(J) .GT. KEY) THEN
            SORTED(J+1) = SORTED(J)
            J = J - 1
            GOTO 50
         END IF
         SORTED(J+1) = KEY
60    CONTINUE
      RETURN   
      END


