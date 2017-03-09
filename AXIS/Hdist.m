%Hamming distance. LC Dec 2013 Calcula la distancia de Hamming entre todos
%los picos.
%La distancia de Hamming entre dos cadenas del mismo
%tamanhio esta definida como el numero de elementos diferentes en cada
%posicion de ambos arreglos. Un arreglo binario de longitud n puede ser
%visto como un vector de n dimensiones, de tal manera que los vertices
%forman un hypercubo de dimension n y la distancia de Hamming es
%equivalente a la minima distancia entre dos vertices. 
%Hamming, R.W. 1950. Error detecting and error correcting codes. 

function [Hd]=Hdist(A)

N=size(A,2); %Número de picos

for i=1:N
    for j=i:N
    Aa=A(:,i);
    Ab=A(:,j);
    
    Hi=sum(xor(Aa,Ab))/sum(or(Aa,Ab)); %normalizo entre el numero total de elementos
    Hd(i,j)=Hi;
    Hd(j,i)=Hi;
    end
end;