1. O utilit�rio get_abq67_res.exe tem as seguintes caracter�sticas de funcionamento:
1.1. l� valores dum ficheiro �bin�rio� analise.fil
1.2. gera dois ficheiros de dados, um designado por vmises.dat e outro de sener.dat


2. Para �executar� este utilit�rio dar o comando:
C:> abaqus get_abq67_res


3. Como gerar o ficheiro analise.fil (com resultados da tens�o de Von Mises e densidade de energia el�stica)?
3.1. O ficheiro analise.fil � resultado da execu��o dum processo de ABAQUS com o nome de analise (ficheiro de input analise.inp).
3.2. Para que esse ficheiro seja criado pela execu��o do processo analise, � necess�rio que existam instru��es de escrita no ficheiro analise.inp, de modo a serem escritos certos resultados da an�lise do ABAQUS � neste caso t�m de existir uma instru��o para escrever a tens�o de Von Mises e a densidade de energia el�stica.
3.3. Essas instru��es de escrita de resultados s�o posicionadas na defini��o do step (parte final do ficheiro analise.inp):

3.3.1.
*el file, pos=average, freq=99999
sinv,
ener

3.3.2. Tendo definido previamente os elementos de osso no conjunto designado por elem_osso,
*el file, pos=average, freq=99999, elset=elem_osso
sinv,
ener

Com a instru��o 3.3.1 s�o apresentados resultados para todos os n�s do modelo enquanto que com a instru��o 3.3.2 s�o apresentados resultados apenas para os n�s dos elementos do conjunto elem_osso.


4. O que � gerado nos ficheiros vmises.dat e sener.dat?
S�o geradas linhas com quatro valores: o primeiro valor cont�m o n�mero do step do processo ABAQUS, o segundo o n�mero do n�, o terceiro um c�digo (valor zero) e o �ltimo valor cont�m a tens�o de Von Mises ou a densidade de energia el�stica associada ao n� indicado.

