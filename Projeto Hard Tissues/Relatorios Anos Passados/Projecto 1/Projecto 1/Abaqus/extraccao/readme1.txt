1. O utilitário get_abq67_res.exe tem as seguintes características de funcionamento:
1.1. lê valores dum ficheiro “binário” analise.fil
1.2. gera dois ficheiros de dados, um designado por vmises.dat e outro de sener.dat


2. Para “executar” este utilitário dar o comando:
C:> abaqus get_abq67_res


3. Como gerar o ficheiro analise.fil (com resultados da tensão de Von Mises e densidade de energia elástica)?
3.1. O ficheiro analise.fil é resultado da execução dum processo de ABAQUS com o nome de analise (ficheiro de input analise.inp).
3.2. Para que esse ficheiro seja criado pela execução do processo analise, é necessário que existam instruções de escrita no ficheiro analise.inp, de modo a serem escritos certos resultados da análise do ABAQUS – neste caso têm de existir uma instrução para escrever a tensão de Von Mises e a densidade de energia elástica.
3.3. Essas instruções de escrita de resultados são posicionadas na definição do step (parte final do ficheiro analise.inp):

3.3.1.
*el file, pos=average, freq=99999
sinv,
ener

3.3.2. Tendo definido previamente os elementos de osso no conjunto designado por elem_osso,
*el file, pos=average, freq=99999, elset=elem_osso
sinv,
ener

Com a instrução 3.3.1 são apresentados resultados para todos os nós do modelo enquanto que com a instrução 3.3.2 são apresentados resultados apenas para os nós dos elementos do conjunto elem_osso.


4. O que é gerado nos ficheiros vmises.dat e sener.dat?
São geradas linhas com quatro valores: o primeiro valor contém o número do step do processo ABAQUS, o segundo o número do nó, o terceiro um código (valor zero) e o último valor contém a tensão de Von Mises ou a densidade de energia elástica associada ao nó indicado.

