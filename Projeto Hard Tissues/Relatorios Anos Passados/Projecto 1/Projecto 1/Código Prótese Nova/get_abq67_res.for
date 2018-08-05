      SUBROUTINE ABQMAIN
      INCLUDE 'aba_param.inc'
      CHARACTER*80 FNAME
      DIMENSION ARRAY(513),JRRAY(NPRECD,513),LRUNIT(2,1)
      EQUIVALENCE(ARRAY(1),JRRAY(1,1))
c
      real*8 vmises,sener
c
      open(14,file='vmises.dat')
      open(15,file='sener.dat')
c
c     file initialization
c
      fname='analise'
      NRU=1
      LRUNIT(1,1)=8
      LRUNIT(2,1)=2
      LOUTF=0
      CALL INITPF(FNAME,NRU,LRUNIT,LOUTF)
      JUNIT=8
      CALL DBRNU(JUNIT)
c
c     loop on all records in results file
c
  100     CALL DBFILE(0,ARRAY,JRCD)
          IF (JRCD.NE.0) GOTO 110
          KEY=JRRAY(1,2)
          IF (KEY.EQ.2000) THEN
              istep=JRRAY(1,8)
          ELSEIF (KEY.EQ.1) THEN
              nnel=JRRAY(1,3)
              jpnt=JRRAY(1,4)
          ELSEIF (KEY.EQ.12) THEN
              vmises=array(3)
              write(14,2000)istep,nnel,jpnt,vmises
          ELSEIF (KEY.EQ.14) THEN
              sener=array(3)
              write(15,2000)istep,nnel,jpnt,sener
          ENDIF
          goto 100
  110 CONTINUE
c
 2000 format(3I8,6E14.6)
c
      close(14)
      close(15)
c
      end
