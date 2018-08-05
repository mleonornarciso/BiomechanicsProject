function [ res ] = readfile( nome )
%READFILE Summary of this function goes here
%   Detailed explanation goes here

f=fopen(nome,'r');

while f==-1
    f=fopen(nome,'r');
end

res=[];
a = fgetl(f);

while ~isequal(a,-1)
    x=str2num(a);
    res=[res;x];
    a=fgetl(f);
end

fclose(f);

end

