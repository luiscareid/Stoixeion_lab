%Creado por Luisca Mayo09. 
%SRactive() genera una matriz nXm donde 
%n:N�mero de c�lulas activas; 
%m:n�mero de picos 

function [SR_active]=SRactive(A)

%S_Rasterbin=Rb*Si; %C�lulas totalesXn�mero de picos

% Rasterbin y S_index tienen que tener 1 frame de resoluci�n.

N=size(A,1); %N�mero de c�lulas totales
j=1;
for i=1:N
    Ta=A(i,:);
    
    if (sum(Ta)==0)
        
    else
    SR_active(j,:)=Ta;
    j=j+1;
    end
end;

