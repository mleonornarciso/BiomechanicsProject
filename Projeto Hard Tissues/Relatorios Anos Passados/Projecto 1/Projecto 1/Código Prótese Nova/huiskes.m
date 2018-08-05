function [ dens_f ] = huiskes( dens_ini, ener, passo, k, s )
%HUISKES Summary of this function goes here
%   Detailed explanation goes here

dens_f=zeros(length(dens_ini),1);

for j=1:length(dens_ini)
    if ener(j)/dens_ini(j)<(1-s)*k
        dens_f(j) = dens_ini(j) + passo * (ener(j,4)./dens_ini(j)-(1-s)*k);
        if dens_f(j)>1.7
            dens_f(j)=1.7;
        elseif dens_f(j)<0.1
            dens_f(j)=0.1;
        end
    elseif ener(j)/dens_ini(j)>(1-s)*k
        dens_f(j) = dens_ini(j) + passo * (ener(j,4)./dens_ini(j)-(1+s)*k);
        if dens_f(j)>1.7
            dens_f(j)=1.7;
        elseif dens_f(j)<0.1
            dens_f(j)=0.1;
        end
    else
        dens_f(j)=dens_ini(j);
    end
    
end