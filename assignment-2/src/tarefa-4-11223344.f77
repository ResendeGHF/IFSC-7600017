      PROGRAM MAIN
C     PARAMETROS DA SIMULACAO
      INTEGER NSTEPS, MWALK
      PARAMETER (NSTEPS=1000000, MWALK=2000)
      INTEGER NGRID
      REAL H, XMIN
      PARAMETER (NGRID = 300)
      PARAMETER (H = 10.0)
      PARAMETER (XMIN = -1500.0)
      REAL POS(2*MWALK)
      REAL AVGX, AVGY, AVGR2, DELTASQ, ENTROP
      INTEGER NCELLS(NGRID, NGRID)
C     FUNCAO EXTERNA E COMMON BLOCK
      DOUBLE PRECISION RANDS, RVAL
C     VARIAVEIS DE CONTROLE E ARQUIVOS
      INTEGER I, J, K, NOUT_IDX, IX, IY, N_I
      INTEGER NOUT(6)
      REAL XPOS, YPOS, PROB_I
      CHARACTER*20 FNAME
      DATA NOUT /10, 100, 1000, 10000, 100000, 1000000/
      OPEN(11, FILE='entropia_vs_N.dat', STATUS='UNKNOWN')
      WRITE(11,*) '# N_PASSOS      ENTROPIA'
C
      DO 5 I=1, 2*MWALK
         POS(I) = 0.0
 5    CONTINUE
      WRITE(*,*) 'NUMERO DE ANDARILHOS:', MWALK
      WRITE(*,'(A10, A15, A15, A15, A15, A15)') 'N_PASSOS', '<X>',
     +     '<Y>', '<R^2>', 'DELTA^2', 'ENTROPIA'
      DO 10 J=1, NSTEPS
         DO 20 K=1, 2*MWALK, 2
            RVAL = RANDS()
            IF ( RVAL .LT. 0.25 ) THEN
               POS(K) = POS(K) + 1.0
            ELSE IF ( RVAL .LT. 0.50 ) THEN
               POS(K) = POS(K) - 1.0
            ELSE IF ( RVAL .LT. 0.75 ) THEN
               POS(K+1) = POS(K+1) + 1.0
            ELSE
               POS(K+1) = POS(K+1) - 1.0
            END IF
 20      CONTINUE
         DO 30 NOUT_IDX=1, 6
            IF (J .EQ. NOUT(NOUT_IDX)) THEN
               AVGX  = 0.0
               AVGY  = 0.0
               AVGR2 = 0.0
               DO 40 I=1, 2*MWALK, 2
                  AVGX  = AVGX + POS(I)
                  AVGY  = AVGY + POS(I+1)
                  AVGR2 = AVGR2 + (POS(I)**2 + POS(I+1)**2)
 40            CONTINUE
               AVGX  = AVGX / REAL(MWALK)
               AVGY  = AVGY / REAL(MWALK)
               AVGR2 = AVGR2 / REAL(MWALK)
               DELTASQ = AVGR2 - (AVGX**2 + AVGY**2)
               DO 50 IX=1, NGRID
                  DO 50 IY=1, NGRID
                     NCELLS(IX,IY) = 0
 50            CONTINUE
C              2. DISTRIBUI OS ANDARILHOS NAS CELULAS DO GRID (BINNING)
               DO 60 I=1, 2*MWALK, 2
                  XPOS = POS(I)
                  YPOS = POS(I+1)
C                 CONVERTE POSICAO (X,Y) PARA INDICE DE CELULA (IX,IY)
                  IX = INT((XPOS - XMIN) / H) + 1
                  IY = INT((YPOS - XMIN) / H) + 1
C                 VERIFICA SE O ANDARILHO ESTA DENTRO DOS LIMITES DO GRID
                  IF (IX.GE.1 .AND. IX.LE.NGRID .AND.
     +                IY.GE.1 .AND. IY.LE.NGRID) THEN
                     NCELLS(IX,IY) = NCELLS(IX,IY) + 1
                  END IF
 60            CONTINUE
               ENTROP = 0.0
               DO 70 IX=1, NGRID
                  DO 70 IY=1, NGRID
                     N_I = NCELLS(IX,IY)
C                    SOMA APENAS SE A CELULA NAO ESTIVER VAZIA
                     IF (N_I .GT. 0) THEN
                        PROB_I = REAL(N_I) / REAL(MWALK)
                        ENTROP = ENTROP - PROB_I * ALOG(PROB_I)
                     END IF
 70            CONTINUE
               WRITE(*,'(I10, 4F15.5, F15.5)') J, AVGX, AVGY, AVGR2,
     +                                         DELTASQ, ENTROP
               WRITE(11,'(I12, F15.6)') J, ENTROP
            END IF
 30      CONTINUE
 10   CONTINUE
      CLOSE(11)
      STOP
      END

      BLOCK DATA
      INTEGER ISEED
      COMMON /SEEDBLK/ ISEED
      DATA ISEED /1154/
      END

      FUNCTION RANDS()
      DOUBLE PRECISION RANDS
      INTEGER ISEED
      COMMON /SEEDBLK/ ISEED
      INTEGER A, M, Q, R
      PARAMETER (A = 16807)
      PARAMETER (M = 2147483647)
      PARAMETER (Q = 127773)
      PARAMETER (R = 2836)
      INTEGER TEST
      TEST = A * MOD(ISEED, Q) - R * (ISEED / Q)
      IF (TEST .LT. 0) THEN
         TEST = TEST + M
      END IF
      ISEED = TEST
      RANDS = DBLE(ISEED) / DBLE(M)
      RETURN
      END
