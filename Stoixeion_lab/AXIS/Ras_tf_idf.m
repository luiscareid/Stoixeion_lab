%TF-IDF LC14 El objetivo es normalizar la matriz del S_index de tal forma
%que solo sea necesario escoger un umbral
%Paso 1: Term frequency 
% TF=numero que aparece cada cell en un vector/total de celulas activas por vector 
% Paso 2: Inverse document freq
% IDF=1+loge(picos/(numero de picos donde aparece una celula))
%par un rasterbin de cellsXframes
%TF es cellsXframes
%IDF es cellsXframes
%TF*IDF no es la multiplicacion de las matrices sino
%Rasterbin(c1,f1)=TF(c1,f1)*IDF(c1,f1)

[cti, fti]=size(Rasterbin);
tf_Rasterbin=zeros(cti,fti);
idf_Rasterbin=zeros(cti,fti);
tf_idf_Rasterbin=zeros(cti,fti);

for cti1=1:cti
    for fti1=1:fti
        tf_Rasterbin(cti1,fti1)=Rasterbin(cti1,fti1)/sum(Rasterbin(:,fti1));
        if (sum(Rasterbin(cti1,:)==1))>0
        idf_Rasterbin(cti1,fti1)=1+log(fti/(sum(Rasterbin(cti1,:)==1)));
        end
        if (sum(Rasterbin(cti1,:)==1))==0
        idf_Rasterbin(cti1,fti1)=1+log(fti);
        end
        tf_idf_Rasterbin(cti1,fti1)=tf_Rasterbin(cti1,fti1)*idf_Rasterbin(cti1,fti1);
    end
end
