%% PROJETO SOFT TISSUES

close all
clear all

cd 'C:\Users\mleon\Desktop\4º Ano 2º Semestre\Biomecânica dos Tecidos\Projeto Soft Tissues\Código Soft Tissues'

load lambda.mat
load tensao_nominal.mat
%passamos para pascais

%% Exercicio 1

fittype_formula = fittype ('(C/B)*(exp(B*(x-1))-1)');
fungs_quasi = fit (lambda, tensao_nominal, fittype_formula);

coeficientes = coeffvalues(fungs_quasi);
%coeficientes(1) = B
%coeficientes(2) = C

B  = 23.6720;
%(22.87, 24.48)
C = 5.06410*10^5 ;
% em pascal(4.696e+05, 5.433e+05)

%NOTA: POR COM AS MESMAS CASAS DECIMAIS QUE PUSEMOS NO FICHEIRO
%ESQUISITO.inp

x = 1:0.001:1.14;
y=C/B*(exp(B*(x-1))-1);
figure('Name', 'Tensao nominal por lambda', 'NumberTitle','off');
figure(1);
plot(lambda,tensao_nominal,'x',x,y)
title('Relação hiperelástica exponencial de Fung');
grid on;
legend ({'experimental data', 'fitted curve'})
ylabel('Tensao Nominal (MPa)'); %xlim([0,1.5]);
xlabel('Alongamento ?'); %ylim([0,1.5]);

%% Exercicio 2

area = 0.5 * 10^-4; %em metros quadrados
comp = 1.05 * 10^-2; %em metros

% Material incompressivel:
% V = V0 <=> AL = A0L0

F = 0:0.01:30;
%mudar consoante valores do abaqus

lambda_F = (1/B)*log((F*B/(area*C))+1)+1;
%lambda_F e o lambda em funcao de F
q = comp*(lambda_F - 1);

%Plot do deslocamento vs forca
figure('Name', 'Deslocamento vs força', 'NumberTitle','off');
plot(F,q)
title('Deslocamento da extremidade livre em função da força aplicada');
ylabel('Deslocamento (m)'); %xlim([0,2]);
xlabel('Força Aplicada (N)'); %ylim([0.01,0.012]);
grid on;

%% Plot de deformacao logaritmica vs forca
figure('Name', 'Deformação logaritmica ', 'NumberTitle','off');
plot(F,log(lambda_F))
title('Logaritmo do Alongamento da extremidade livre em função da força aplicada');
ylabel('ln(?) (m)');% xlim([0,2]);
xlabel('Força Aplicada (N)'); %ylim([0.01,0.012]);
grid on;

%% Plot da tensao de cauchy
sigma = lambda_F.*(F/area);

figure('Name', 'Tensão de Cauchy em função da força aplicada', 'NumberTitle','off');
plot(F, sigma)
title('Tensão de Cauchy em função da força aplicada');
ylabel('Tensão de Cauchy (Pa)');% xlim([0,2]);
xlabel('Força Aplicada (N)'); %ylim([0.01,0.012]);
grid on;

%POR GRAFICOS BONITINHOS COM LEGENDAS E TAL
%% Exercicio 3

%Usamos 10 load steps - .1,1.,.1,.1
%CLOAD forca maxima foi o 27.85 (tiramos o maximo no excell valores experimentais)

%1 elemento finito =  ficheiro que tem no seu titulo 1EF.inp
%3 elementos finitos = ficheiro que tem no seu titulo 3EF.inp


%% Exercicio 4
%Porque é que sao iguais com 1EF e 3EF

%% Exercicio 6

% Inicializar deslocamentos com os deslocamentos obtidos pelo abaqus apos o
% primeiro step

q2=2.6997*10^(-4);
q3=5.3995*10^(-4);
q4=8.0992*10^(-4);

q=[q2;q3;q4];

% Inicializar residuo
Residuo=1;

while Residuo>=10^(-5)
    
    % Calcular os lambdas
    
    lambda_1=(comp/3+q(1))/(comp/3);
    lambda_2=(comp/3+q(2)-q(1))/(comp/3);
    lambda_3=(comp/3+q(3)-q(2))/(comp/3);
    
    % Calcular os T (tensão nominal)
    
    T_1=C/B*(exp(B*(lambda_1-1))-1);
    T_2=C/B*(exp(B*(lambda_2-1))-1);
    T_3=C/B*(exp(B*(lambda_3-1))-1);
    
    % Calcular dT/dlambda
    
    dT_1=C*exp(B*(lambda_1-1));
    dT_2=C*exp(B*(lambda_2-1));
    dT_3=C*exp(B*(lambda_3-1));
    
    % Calcular matrizes K de cada elemento
    
    K_1=dT_1*area/(comp/3)*[1 -1;-1 1];
    K_2=dT_2*area/(comp/3)*[1 -1;-1 1];
    K_3=dT_3*area/(comp/3)*[1 -1;-1 1];
    
    % Calcular os vetores de força interna de cada elemento
    
    Fint_1=T_1*area*[1;-1];
    Fint_2=T_2*area*[1;-1];
    Fint_3=T_3*area*[1;-1];
    
    % Assemblagem: matrix K global
    K_TOTAL=zeros(4,4);
    
    K_TOTAL(1,1)=K_1(1,1);
    K_TOTAL(2,2)=K_1(2,2)+K_2(1,1);
    K_TOTAL(3,3)=K_2(2,2)+K_3(1,1);
    K_TOTAL(4,4)=K_2(2,2);
    K_TOTAL(1,2)=K_1(1,2);
    K_TOTAL(2,1)=K_TOTAL(1,2);
    K_TOTAL(1,3)=0;
    K_TOTAL(3,1)=K_TOTAL(1,3);
    K_TOTAL(1,4)=0;
    K_TOTAL(4,1)=K_TOTAL(1,4);
    K_TOTAL(2,3)=K_2(1,2);
    K_TOTAL(3,2)=K_TOTAL(2,3);
    K_TOTAL(2,4)=0;
    K_TOTAL(4,2)=K_TOTAL(2,4);
    K_TOTAL(3,4)=K_3(1,2);
    K_TOTAL(4,3)=K_TOTAL(3,4);
    
    % Assemblagem: vetor de forças internas globais
    
    Fint_TOTAL=zeros(4,1);
    
    Fint_TOTAL(1)=Fint_1(1);
    Fint_TOTAL(2)=Fint_1(2)+Fint_2(1);
    Fint_TOTAL(3)=Fint_2(2)+Fint_3(1);
    Fint_TOTAL(4)=Fint_3(2);
    
    % Construção do sistema de equações
    % K*vetor_deslocamentos=Fint+Fext
    
    % Aplicação das condições de fronteira: d_q1=0 -> eliminar primeira linha
    % do sistema de equações
    K=K_TOTAL(2:4,2:4);
    Fint=Fint_TOTAL(2:4);
    
    % Vetor de forças externas Fext (2º incremento de 5 steps*força maxima dos
    % dados)
    Fext=[0;0;2/5*27.85];
    
    % Resolver sistema de equações
    d_q=K\(Fint+Fext);
    
    % Atualizar valor dos deslocamentos
    q=q+d_q;
    
    % Calcular valor do modulo do residuo
    Residuo=norm(Fint+Fext);
    
    disp(Residuo)
    
end

