       SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,RPL,DDSDDT,
     1 DRPLDE,DRPLDT,STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,
     2 CMNAME,NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     3 CELENT,DFGRAD0,DFGRAD1,NOEL,NPT,LAYER,KSPT,KSTEP,KINC)
c
c   ******************************************************************
c   *   1D Non-Linear Elastic model                                  *
c   ******************************************************************
c   *  List of variables                                             *
c   *                                                                *
c   *  STRESS()    - Cauchy stress                                   *
c   *  STRAN()     - Logarithmic Strain at beginning of increment    *
c   *                = Log (stretch)                                 *
c   *  DSTRAN()    - Logarithmic Strain increment                    *
c   *  PROPS()     - Material constants                              *
c   *  NPROPS      - Number of material constants                    *
c   *  DTIME       - Time increment                                  *
c   *  E           - Elastic response constant                       *
c   *  ALAM2       - Stretch at the end of the increment             *
c   *  T           - Nominal stress                                  *
c   *  DTDlam      - Jacobian of constitut. model in Lagrangean form *
c   *                = d(T)/d(stretch)                               *
c   *  DDSDDE()    - Jacobian of constitut. model in current config. *
c   *                = d(Cauchy stress) / d(log stretch)             *
c   ******************************************************************
c     
      INCLUDE 'ABA_PARAM.INC'
c
      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV),
     1 DDSDDE(NTENS,NTENS),DDSDDT(NTENS),DRPLDE(NTENS),
     2 STRAN(NTENS),DSTRAN(NTENS),TIME(2),PREDEF(1),DPRED(1),
     3 PROPS(NPROPS),COORDS(3),DROT(3,3),DFGRD0(3,3),DFGRD1(3,3)
c
c     Input of material properties
c
           B = props(1)
	   C = props(2)
c
c     Stretch ratio at end of increment
c
           ALAM2=DEXP(STRAN(1)+DSTRAN(1))
c
c     Nominal Stress at end of increment
c
           T = C/B * (dexp(B*(ALAM2 - 1.))-1.)
c
c   ******************************************************************
c   *  Resultado requerido pelo ABAQUS:                              *
c   *  Cauchy stress at end of increment                             *
c   *                                                                *
           STRESS(1)= T*ALAM2
c   *                                                                *
c   ******************************************************************
c
c     Jacobian of the model in Lagrangean form 
c
           DTDlam = C*dexp(B*(ALAM2 - 1.))
c
c   ******************************************************************
c   *  Resultado requerido pelo ABAQUS:                              *
c   *  Jacobian of the constitutive model in current configuration   *
c   *                                                                *     
           DDSDDE(1,1)=ALAM2*(T+ALAM2*DTDlam)
c   *                                                                *
c   ******************************************************************
c  
      RETURN
      END

