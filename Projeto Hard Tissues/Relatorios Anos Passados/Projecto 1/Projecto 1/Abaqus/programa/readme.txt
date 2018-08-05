Este ficheiro pretende alertar para algumas particularidades de funcionamento do programa biomec10.f.
Para executar o programa fazer double click sobre o ficheiro biomec09.exe ou dar o comando numa janela MS-DOS:
C:> biomec10 

NOTA: Para além do indicado em seguida, o programa possui comentários dando indicação de aspectos do seu funcionamento.

1. O programa aplica computacionalmente o método evolutivo baseado no critério:
se a TensaoVonMises>TensaoReferencia => aumentar densidade
em caso contrario => diminuir a densidade
Consequentemente, o programa NÃO corresponde à implementação computacional do modelo de Huiskes.

2. O programa considera que o utilizador criou previamente um ficheiro com as densidades iniciais (ficheiro dens_ini.dat). O número de linhas do ficheiro dens_ini.dat é igual ao número de nós do domínio aos quais está associada um parâmetro densidade - os nós de osso. Cada linha do ficheiro tem o número do nó e o respectivo valor de densidade inicial.

3. É assumido pelo programa que a numeração dos nós (de osso) se inicia em 1, é sequencial e que não há falhas na numeração.

4. O programa assume que o utilizador criou previamente um ficheiro de input para o ABAQUS com a designação analise.inp.

5. O modelo material utilizado para o osso considera que este não é homogéneo - tem propriedades variáveis de ponto para ponto. É considerado que no ficheiro analise.inp o material é definido em função dum parâmetro (densidade).
 
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

6. Posteriormente é necessário indicar o valor do parâmetro para cada ponto do osso. A forma utilizada para o realizar foi através dum modo tabular, dando a indicação da densidade para cada nó de osso. O modo implementado foi ler os valores dum ficheiro dens.dat.

7. O programa biomec10.f gera o ficheiro dens.dat. O ficheiro dens.dat é uma tabela de valores, com um número de linhas igual ao número de nós do domínio de osso. Foi considerado que o nome da “part-instance” onde está o osso tem a designação de Part-1-1. Cada linha do ficheiro tem o nome da “part-instance”, o número do nó e o respectivo valor de densidade inicial.
Exemplo:
Part-1-1.1, 0.5
Part-1-1.2, 0.5
Part-1-1.3, 0.5
...

8. O programa considera apenas 1 caso de carga (e por isso pressupõe a existência de apenas 1 step, ou melhor, apenas considera o resultado do último step) 

9. O programa considera que no ficheiro vmises.dat apenas existem resultados para os nós de osso (logo não existem resultados para outras zonas do domínio). Isso é conseguido especificando no ficheiro analise.inp a escrita das tensões de Von Mises apenas para os elementos de osso (escrever as tensões de Von Mises apenas para um determinado elset)

10. Após a leitura dos resultados, o programa apaga diversos ficheiros gerados pelo ABAQUS de modo a “limpar” a directoria e viabilizar a realização da iteração seguinte.
