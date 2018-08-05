function [ output_args ] = cria_dens( partNome, num, valor )

file_id=fopen('dens.dat','w');

for i=1:num
    fprintf(file_id,'%s.%d, %f\n',partNome, i, valor(i));
end

fclose(file_id);
end