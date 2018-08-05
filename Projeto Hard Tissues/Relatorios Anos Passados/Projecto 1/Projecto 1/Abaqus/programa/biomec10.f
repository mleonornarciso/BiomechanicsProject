c
c --- O programa aplica computacionalmente o método evolutivo baseado no critério:
c --- se a TensaoVonMises>TensaoReferencia => aumentar densidade
c --- em caso contrario => diminuir a densidade
c
      implicit real*8(a-h,o-z)
      character*5 idensch
c --- o dimensionamento considerado esta limitado a 5000 variaveis
      dimension dens(5000),vmises(5000)
c
c --- leitura de dados iniciais
c
      write(*,*) 'VonMises_ref=?, salto=?, num_iter=?'
      read(*,*) vmref, salto, niter
c
c --- leitura das densidades iniciais
c --- (e contagem do numero de variaveis de adaptacao)
c
      open(unit=15,file='dens_ini.dat')
      ndens=0
   10 continue
      read(15,*,end=50) iaux,dens(ndens+1)
      ndens=ndens+1
      goto 10
   50 continue
      close(15)
c
c --- processo iterativo
c
      do iter=1,niter
		  write(*,*)
		  write(*,*)'Iteracao:',iter
c
c ------- criacao de ficheiro com a lista das densidades para leitura do ABAQUS
c
          open(unit=19,file='dens.dat')
          do idens=1,ndens
c ----------- "passagem" da variavel inteira ielem para variavel caracter ielemch
              call wrt2char(idens,idensch)
c ----------- escrita da instrucao
              write(19,1040) idensch,dens(idens)
          end do
c ------- formato da escrita
c ------- Nota: a "instance" de adaptacao chama-se Part-1-1
 1040     format('Part-1-1.',A5,',',F10.6)
          close(19)
c
c ------- limpar ficheiros de analises anteriores (se existirem)
c
          call apaga_fich_inicio()
c
c ------- resolucao do problema de Elementos Finitos
c ------- Nota: o ficheiro .inp tem de se chamar analise.inp
c
          call system ('abaqus job=analise inter')
c
c ------- extracao dos resultados do ABAQUS e escrita em ficheiros texto
c
          call system ('abaqus get_abq67_res.exe')
c
c ------- limpar os ficheiros da analise que nao interessao
c
          call apaga_fich_fim()
c
c ------- leitura das tensões 
c
          idens=1
          open(12,file='vmises.dat')
   80     continue
          read(12,*,end=90)istep,iaux,jpnt,vmises(idens)
          idens=idens+1
          goto 80
   90     continue
          close(12)
c
c ------- actualizacao das densidades
c
          do idens=1,ndens
c ----------- calculo do novo valor de densidade,
c ----------- tendo em conta a lei de evolucao
              if (vmises(idens).gt.vmref) then
                  dens_new=dens(idens)+salto
              else
                  dens_new=dens(idens)-salto
              endif
c ----------- se a nova densidade exceder o limite inferior 0.01 ou superior 1
c ----------- entao atribuir a densidade o valor limite
              if (dens_new.gt.1.) then
                  dens(idens)=1.
              elseif (dens_new.lt.0.01) then
                  dens(idens)=0.01
c ----------- se a nova densidade estiver dentro dos valores limites de 0.01 e 1
c ----------- entao atribuir o novo valor
			  else
                  dens(idens)=dens_new
              endif
c ----------- fim da actualizacao das densidades
          end do
c
c --- fim do processo iterativo
c
      end do
c
c --- fim do programa
c
      end
c
c **********************************************
c --- escrita na variavel tipo caracter ichar de
c --- o numero contido na variavel inteira inum  
	subroutine wrt2char(inum,ichar)
	character*5 ichar,caux
	write(caux,'(I5)') inum
	if (inum.lt.0) then
		ichar='*****'
	elseif (inum.lt.10) then
		ichar='0000'//caux(5:5)
	elseif (inum.lt.100) then
		ichar='000'//caux(4:5)
	elseif (inum.lt.1000) then
		ichar='00'//caux(3:5)
	elseif (inum.lt.10000) then
		ichar='0'//caux(2:5)
	elseif (inum.lt.100000) then
		ichar=caux(1:5)
	else
		ichar='*****'
	endif
	end
c ************************************************
c --- apagar todos os ficheiros do processo ABAQUS
c --- com o nome analise, excepto o ficheiro .inp
	subroutine apaga_fich_inicio()
	call system('move analise.inp fichaux.inp')
	call system('del analise.*')
	call system('move fichaux.inp analise.inp')
	end
c ******************************************************
c --- apagar todos os ficheiros do processo ABAQUS
c --- com o nome analise, excepto o ficheiro .inp e .odb
	subroutine apaga_fich_fim()
	call system('move analise.inp fichaux.inp')
	call system('move analise.odb fichaux.odb')
	call system('del analise.*')
	call system('move fichaux.inp analise.inp')
	call system('move fichaux.odb analise.odb')
	end