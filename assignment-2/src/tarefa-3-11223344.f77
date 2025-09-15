      BLOCK DATA
      INTEGER ISEED
      COMMON /SEEDBLK/ ISEED
      DATA ISEED /1154/ 
      END

      FUNCTION RANDS()
c     RETORNA DOUBLE PRECISION E ATUALIZA ISEED NO BLOCO ALOCADO
      DOUBLE PRECISION RANDS
      INTEGER ISEED
      COMMON /SEEDBLK/ ISEED

c     PARAMETROS PARA O GERADOR MINSTD (A=16807, M=2**31-1)
      INTEGER A, M, Q, R
      PARAMETER (A = 16807)
      PARAMETER (M = 2147483647)
c     PARAMETROS PARA O METODO DE SCHRANGE (PRE-CALCULADOS)
c     Q = M / A = 127773
c     R = M % A = 8776
      PARAMETER (Q = 127773)
      PARAMETER (R = 8776)

      INTEGER TEST

c     METODO DE SCHRANGE PARA CALCULAR '(A*ISEED)%M' SEM OVERFLOW
      TEST = A * (MOD(ISEED, Q)) - R * (ISEED / Q)
c     E SE O RESULTADO FOR NEGATIVO, LEVAR AO DOMINIO CORRETO.
      IF (TEST .LT. 0) THEN
         TEST = TEST + M
      END IF

      ISEED = TEST
      RANDS = DBLE(ISEED) / DBLE(M)
      RETURN
      END

      FUNCTION STEP()
      REAL STEP
      DOUBLE PRECISION RVAL
      RVAL = RAND()
      IF ( RVAL .LT. DPROB ) THEN
         STEP = 1
      ELSE
         STEP = -1
      END IF
      RETURN
      END

      PROGRAM MAIN
      INTEGER NSTEPS, MWALK
      PARAMETER (NSTEPS=1000000, MWALK=1000)
      REAL POS(2*MWALK)
      REAL AVGX, AVGY, AVGR2, DELTASQ
      DOUBLE PRECISION RANDS, RVAL
C     VARIAVEIS DE CONTROLE E PARA ARQUIVOS
      INTEGER I, J, K, NOUT_IDX
      INTEGER NOUT(6)
      CHARACTER*20 FNAME
C     NUMERO DE PASSOS ONDE OS DADOS SERAO SALVOS
      DATA NOUT /10, 100, 1000, 10000, 100000, 1000000/
C     INICIALIZACAO DAS POSICOES EM (0,0) COM UM LACO DO
      DO 5 I=1, 2*MWALK
         POS(I) = 0.0
5     CONTINUE
      
      WRITE(*,*) 'NUMERO DE ANDARILHOS:', MWALK
      WRITE(*,'(A10, A15, A15, A15, A15)') 'N_PASSOS', '<X>', '<Y>',
     +     '<R^2>', 'DELTA^2'
      DO 10 J=1, NSTEPS
         DO 20 K=1, 2*MWALK, 2
            RVAL = RANDS()
            IF ( RVAL .LT. 0.25 ) THEN
C              PASSO PARA LESTE (+X)
               POS(K) = POS(K) + 1.0
            ELSE IF ( RVAL .LT. 0.50 ) THEN
C              PASSO PARA OESTE (-X)
               POS(K) = POS(K) - 1.0
            ELSE IF ( RVAL .LT. 0.75 ) THEN
C              PASSO PARA NORTE (+Y)
               POS(K+1) = POS(K+1) + 1.0
            ELSE
C              PASSO PARA SUL (-Y)
               POS(K+1) = POS(K+1) - 1.0
            END IF
 20      CONTINUE
C        VERIFICA SE O PASSO ATUAL 'J' E UM DOS PASSOS DE INTERESSE
         DO 30 NOUT_IDX=1, 6
            IF (J .EQ. NOUT(NOUT_IDX)) THEN
C              INICIO DOS CALCULOS ESTATISTICOS
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
C              IMPRIME RESULTADOS NA TELA
               WRITE(*,'(I10, 4F15.5)') J, AVGX, AVGY, AVGR2, DELTASQ
C              SALVA POSICOES EM ARQUIVO PARA GERAR DIAGRAMA
               WRITE(FNAME, '(A,I7.7,A)') 'pos_N', J, '.dat'
               OPEN(10, FILE=FNAME, STATUS='UNKNOWN')
               DO 50 I=1, 2*MWALK, 2
                  WRITE(10,*) POS(I), POS(I+1)
 50            CONTINUE
               CLOSE(10)
            END IF
 30      CONTINUE
 10   CONTINUE
      STOP
      END
