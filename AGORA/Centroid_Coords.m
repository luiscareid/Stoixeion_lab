%clear all
%close all
% path(path,'.\AGORA\FUZZCLUST')

%the data
centro_all=zeros(edos,2);
dist_all=zeros(edos,1);

for cc_t1=3  % 1:edos %edos
Cells_coords_temp=Pools_coords(:,[1 2],cc_t1);  %Cell_coords
cc_zeros=find(Cells_coords_temp(:,1)==0);
Cells_coords_temp(cc_zeros,:)=[];
data.X = Cells_coords_temp;

%parameters
param.c=1; %numero de clusters que quiero 
param.m=2;
param.e=1e-6;
param.ro=ones(1,param.c);
%normalization
% data=clust_normalize(data,'range');
param.val=3;

result = FCMclust(data,param);
% result = validity(result,data,param); %modvalidity para todos los parametros
figure;
plot(data.X(:,1),data.X(:,2),'bo',result.cluster.v(:,1),result.cluster.v(:,2),'rX');
hold on
%draw contour-map
% new.X=data.X;
% eval=clusteval(new,result,param);
% 
% DI=result.validity.DI;  %Solo DI
centro_coords=result.cluster.v; %Son los centros de masa
%scatter(data.X(:,1),data.X(:,2),'+')
%gname()
%_________________________________________________________________________%
%Para encontrar la dispersion sigma^2/media

cc_dtemp=size(Cells_coords_temp,1);
cc_dist=zeros(cc_dtemp,1);

for ccx=1:cc_dtemp
    cc_dist(ccx)=sqrt((data.X(ccx,1)-result.cluster.v(1,1))^2+(data.X(ccx,2)-result.cluster.v(1,2))^2);  
end

cc_dtemp_tot=(cc_dtemp^2-cc_dtemp)/2; %calculo la el triangulo superior de la matriz
dist_neurons_temp=zeros(cc_dtemp_tot,1);
cc_k1=1;

for ccx1=1:(cc_dtemp-1)
    for ccx2=3 %ccx1+1:(cc_dtemp) %From target cell
        dist_neurons_temp(cc_k1)=sqrt((Cells_coords_temp(ccx2,1)-Cells_coords_temp(ccx1,1))^2+(Cells_coords_temp(ccx2,2)-Cells_coords_temp(ccx1,2))^2);
        cc_k1=cc_k1+1;    
    end
end
%Para graficar el histograma de la distancia entre neuronas de cada estado
figure;
[nelements, centers]=hist(dist_neurons_temp*1,20); %bin size
bar(centers,nelements/size(dist_neurons_temp*1,1));

%Para calcular la distancia con respecto a una celula target
xx=find(dist_neurons_temp==0);
dist_neurons_temp(xx)=[];

%distancia con respecto al centroide de cada estado
dist_coords=mean(cc_dist);%*(317/512); %micras/resolucion pixels para 25X 240/256
% figure;
% [nelements, centers]=hist(cc_dist,25); %bin size
% bar(centers,nelements/size(cc_dist,1));

centro_all(cc_t1,:)=centro_coords; %*(317/512);
dist_all(cc_t1)=dist_coords;
dist_neurons(cc_t1)=mean(dist_neurons_temp); %*(317/512);

end



