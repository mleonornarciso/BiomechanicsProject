close all
clear all

iter=input('Número de iterações ');

dens=0.5;
passo=20;
k=.0015;
sperc=0.1;
s=(1.7-0.1)*sperc;
pontos=3897;
nome='osso-1';

dens_ini=zeros(pontos,1);
dens_ini(:,1)=dens;
dens_ini2(:,1) = dens_ini+1;
cria_dens(nome,pontos,dens_ini);

i=1;
while (i<=iter && max(abs(dens_ini-dens_ini2(:,i)))>0.01)
    dens_ini2(:,i+1)=dens_ini;
    [a b]=system('abq671 inter job=analise');
    if a~=0
        error(b);
    end
    system('abq671 get_abq67_res');
    ener=readfile('sener.dat');
    if size(ener,1)>pontos
         ener=(ener(1:pontos,:)+ener(pontos+1:end,:))./2;
    end
    system('erase sener.dat');
    dens_ini=huiskes(dens_ini,ener,passo,k,s);
    cria_dens(nome,pontos,dens_ini);
    i=i+1;
    fprintf('%d ',i-1)

end

dens_ini2(:,1)=[];
figure;
plot(dens_ini2');
save (sprintf('dens_ini%d',iter),'dens_ini2');

[c d]=system('dir');
e=findstr(d,sprintf('analise%d.odb',iter));
if e>0
    system(sprintf('erase analise%d.odb',iter));
end
system(sprintf('rename analise.odb analise%d.odb',iter));