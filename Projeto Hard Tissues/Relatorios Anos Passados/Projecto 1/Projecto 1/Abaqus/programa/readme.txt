Este ficheiro pretende alertar para algumas particularidades de funcionamento do programa biomec10.f.
Para executar o programa fazer double click sobre o ficheiro biomec09.exe ou dar o comando numa janela MS-DOS:
C:> biomec10 

NOTA: Para al�m do indicado em seguida, o programa possui coment�rios dando indica��o de aspectos do seu funcionamento.

1. O programa aplica computacionalmente o m�todo evolutivo baseado no crit�rio:
se a TensaoVonMises>TensaoReferencia => aumentar densidade
em caso contrario => diminuir a densidade
Consequentemente, o programa N�O corresponde � implementa��o computacional do modelo de Huiskes.

2. O programa considera que o utilizador criou previamente um ficheiro com as densidades iniciais (ficheiro dens_ini.dat). O n�mero de linhas do ficheiro dens_ini.dat � igual ao n�mero de n�s do dom�nio aos quais est� associada um par�metro densidade - os n�s de osso. Cada linha do ficheiro tem o n�mero do n� e o respectivo valor de densidade inicial.

3. � assumido pelo programa que a numera��o dos n�s (de osso) se inicia em 1, � sequencial e que n�o h� falhas na numera��o.

4. O programa assume que o utilizador criou previamente um ficheiro de input para o ABAQUS com a designa��o analise.inp.

5. O modelo material utilizado para o osso considera que este n�o � homog�neo - tem propriedades vari�veis de ponto para ponto. � considerado que no ficheiro analise.inp o material � definido em fun��o dum par�metro (densidade).
 
Exemplo: Material com E=20000*densidade^2, 0.01<densidade<1, Poisson=0.3
*Material, name=Osso
*Elastic
     2.  ,  0.3,  0.01
   200.  ,  0.3,  0.1
   800.  ,  0.3,  0.2
  1800.  ,  0.3,  0.3
  3200.  ,  0.3,  0.4
  5000.  ,  0.3,  0.5
  7200.  ,  0.3,  0.6
  9800.  ,  0.3,  0.7
 12800.  ,  0.3,  0.8
 16200.  ,  0.3,  0.9
 20000.  ,  0.3,  1.0

6. Posteriormente � necess�rio indicar o valor do par�metro para cada ponto do osso. A forma utilizada para o realizar foi atrav�s dum modo tabular, dando a indica��o da densidade para cada n� de osso. O modo implementado foi ler os valores dum ficheiro dens.dat.

7. O programa biomec10.f gera o ficheiro dens.dat. O ficheiro dens.dat � uma tabela de valores, com um n�mero de linhas igual ao n�mero de n�s do dom�nio de osso. Foi considerado que o nome da �part-instance� onde est� o osso tem a designa��o de Part-1-1. Cada linha do ficheiro tem o nome da �part-instance�, o n�mero do n� e o respectivo valor de densidade inicial.
Exemplo:
Part-1-1.1, 0.5
Part-1-1.2, 0.5
Part-1-1.3, 0.5
...

8. O programa considera apenas 1 caso de carga (e por isso pressup�e a exist�ncia de apenas 1 step, ou melhor, apenas considera o resultado do �ltimo step) 

9. O programa considera que no ficheiro vmises.dat apenas existem resultados para os n�s de osso (logo n�o existem resultados para outras zonas do dom�nio). Isso � conseguido especificando no ficheiro analise.inp a escrita das tens�es de Von Mises apenas para os elementos de osso (escrever as tens�es de Von Mises apenas para um determinado elset)

10. Ap�s a leitura dos resultados, o programa apaga diversos ficheiros gerados pelo ABAQUS de modo a �limpar� a directoria e viabilizar a realiza��o da itera��o seguinte.
