%Creado por Luisca En2014. Para hacer objetivo el proceso de
%analisis y para hacer automatica la eleccion de los estados
%Se necesita un archivo Spikes[cellsXframes] y especificar el n�mero de celulas para
%considerar como un pico.
%En esta version se pueden escoger las celulas para considerar como
%pico. 
%Los elementos de Euclides: Stoixeion

%-------------------------------------------------%
%AXIS Primer bloque.
pks=3; %Deberia ser el numero de celulas con correlaciones significativas para un experimento dado 
[Rasterbin,Pks_Frame_Ren,Pks_Frame]=PksFrame(Spikes,pks); 
S_index=sindex(Rasterbin);
S_Ras=SRas(S_index,Rasterbin);
S_Ras_active=SRactive(S_Ras);
S_Ras_Ren=SRasRen(S_Ras);
Ras_tf_idf; %rutina para normalizar el Rasterbin basada en busquedas de palabras genera tf_idf_Rasterbin
% tf_idf_Rasterbin_N=tf_idf_Rasterbin'*tf_idf_Rasterbin; %Genera matriz simetrica. Ayuda para solo tener un corte
S_index_ti=sindex(tf_idf_Rasterbin); %Primer momento del sindex esta relacionado con el numero de celulas de cada pico LC15en14
scut=0.24; %este quita el ruido esta relacionado directamente con el numero de celulas
%que forman parte de los picos de sincronia. 
%x_pks=150*pks/size(Spikes,1);
%scut=0.4755*exp(0.00747*x_pks)-0.4588*exp(-0.07993*x_pks);
% LC Dec 2013. Para celulas activas e inactivas: 0.22/5% 0.31/10% 0.38/15%
% 0.44/20% 0.55/30% 0.7/50% Por ejemplo scut=0.23 esta tomando como corte los
% vectores con al menos ~6% de celulas coactivas. Para una red con 100 neuronas activas
%esto significa que los picos que forman los estados al menos comparten 6
%celulas
%La funcion del scut es una exponencial de segundo orden 
%scut(porcentaje de celulas) especificar el porcentaje de celulas del total que formaran un edo

S_indexb=S_index_ti>scut; %Despues de este porcentaje de similitud las estructuras se ven mas claras. LC Dec13
S_indexb=S_indexb*1;
S_indexc=sindex(S_indexb); %Segundo momento del sindex
scut_c=0.35;
S_indexc=S_indexc>(scut_c); %este define mejor las estructuras para cc
%es funcion del numero de picos totales, para 1000fr/350pks ~0.4 funciona
S_indexc=S_indexc*1;
S_indexc=S_indexb;
%Esto significa que los vectores que pertenecen a un estado deben compartir al menos cierto porcentaje de elementos similares
%Para 100 vectores significativos (arriba del corte de pks) el valor de
%corte de (scut*1.7) 0.44 significa que al menos ~20%  del total de vectores debe ser similar. independiente de scut 


H_index=1-Hdist(S_indexc); %Genera estructuras definidas dependiendo de el costo que se necesita para
%convertir un elemento en otro. 
hcut=0.25; %Hay que cambiar el 70% de los elementos para convertirlo en otro edo
% H_indexb=((H_index>hcut)*1); %LC03Feb14
H_indexb=1-Hdist((H_index>hcut)*1); %LC03Feb14
S_indexp=(H_indexb>hcut)*1; %Segundo momento (Similitud de Hamilton) Define mejor las estructuras y quita el ruido

% S_indexp=S_indexc; %Datos optogenetica LC 26May14

% S_indexp=S_index_ti; %LC03Feb14
S_Ras_Ren_active=S_indexp;
figure(1)
imagesc(S_index_ti);

figure(2)
imagesc(S_indexp==0) %Para blanco y negro LC Ag14

% %--------------------------------------------------%
% %AGORA Tercer bloque.
% %But if at first the idea is not absurd, there's no hope for it...
%Encuentra los picos que hay en los estados y las celulas en los estados
% Edos_from_Sindex; %Enero 2014 encuentra los estados a partir de componentes conectados indice 4. 
%Genera C_edos y sec_Pk_edos. 
%Los centroides alineados en el mismo renglon forman estados similares
%Aproximacion geometrica para resolver los eigen vectors en n dimensiones

% Edos_from_Sindex_eig; %Enero 2014 encuentra los estados a partir de los 
% %eigenvalues y eigenvectors mayores. La ventaja es que solo se necesita
% %indicar el valor del eigenvalue menor para ser considerado como una
% %solucion. El codigo es mas rapido porque hay menos operaciones e
% %iteraciones.
Edos_from_Sindex_svd; %Febrero 2014 encuentra los estados a partir de las 
%propiedades dadas por la descomposicion de la matrix tf_idf_Rasterbin en
%SVD (single value decomposition). Basicamente proyecto la matriz original
%sobre un espaio formado por vectores ortonormales y sus eigenvalues. La
%ventaja conceptual sobre Edos_from_Sindex_eig es que la matriz de entrada
%puede no ser singular. Conceptualmente es mas sencillo de explicar.


[Pk_edos,Cells_edos]=Pkedos(C_edos,Rasterbin);
Cells_edos_active=SRactive(Cells_edos);
[Shared_Cells]=SharedCells(Cells_edos_active);

%--------------------------------------------------%
%PLEGADES Quinto bloque.
% path(path,'.\PLEGADES')
%Encuentra la secuencia entre los estados
sec_Pk_edos_act=SRactive(sec_Pk_edos');
sec_Pk_edos_act=sec_Pk_edos_act';
sec_Pk_edos_Ren=SRasRen(sec_Pk_edos_act);

%Para encontrar sec_Pk_frames dado que no todos los picos fueron asignados
%a un estado
C_edos_temp=zeros(size(C_edos));
edos=size(C_edos,2);
for sii=1:edos
    C_edos_temp(:,sii)=C_edos(:,sii)*sii;
end;

sec_Pk_frames=sum(C_edos_temp');
Hist_Edos=HistEdos(Spikes,Pks_Frame,sec_Pk_frames,pks); 

% path(path,'.\PLEGADES')
[Ciclos_nums,Ciclos_H_E]=CyFolds(sec_Pk_edos_Ren(1,29:end));

%Para encontrar las celulas mas significativas de cada estado LC18En14
csi_cut=0.15; %Porcentaje de corte para determinar las celulas que pesan mas 
%en cada estado. 0.25 me da ~15 celulas en el estado mas grande
% Spikes_sort=Spikes;
csi_num_temp=zeros(size(Cells_edos));
for csi=1:edos
    csi_fr=find(sec_Pk_frames==csi); %Encuentra los frames/sindex de cada edo
%     csi_hist_spk=sum(Spikes(:,Pks_Frame(csi_fr))); %Encuentra los frames
%     en Spikes
%     csi_hist=sum(Rasterbin(:,csi_fr)'); %Suma las celulas de cada edo en Rasterbin
    tf_idf_csi_hist=sum(tf_idf_Rasterbin(:,csi_fr)'); %Suma las celulas de cada edo en tf_idf_Rasterbin
%     figure; imagesc(Rasterbin(:,csi_fr));
%     csi_hist_norm=csi_hist/max(csi_hist); %Normaliza a 1 para tener solo un parametro de corte
    tf_idf_csi_hist_norm=tf_idf_csi_hist/max(tf_idf_csi_hist); %Noramliza a 1 para tener solo un parametro de corte
%      figure;plot(csi_hist_norm); %graficar para escoger csi_cut
%       figure;plot(tf_idf_csi_hist_norm); %graficar para escoger csi_cut
    csix=find(tf_idf_csi_hist_norm>csi_cut);
    csi_num_temp(1:size(csix,2),csi)=csix';
end

csi_ren=max(sum(csi_num_temp>0));
csi_num=zeros(csi_ren,edos);
csi_num=csi_num_temp(1:csi_ren,:); %Celulas mas representativas de cada estado
[S_index_significant, sis_query]=Search_significant(csi_num,tf_idf_Rasterbin,Rasterbin);
figure (8); plot(S_index_significant');
figure (9); imagesc(sortrows(sis_query));
%     Spikes_sort=sortrows(Spikes_sort,csi_num(find(csi_num>0)));
%     figure; imagesc(Spikes_sort);

%---------------------------------
%Para buscar y graficar todos los vectores de cada estado. Con esto la
%visualizacion de los estados es mas clara. Basicamente es la
%descomposicion del S_index en 3D en sus componentes mas representativas

for siq=1:edos
    query=Rasterbin(:,Pk_edos(find(Pk_edos(:,siq)>0),siq));
    [S_index_query]=sindex_query(query,tf_idf_Rasterbin,Rasterbin);
%     figure(11+siq);
%     plot(S_index_query');
end

P_transition=P_sec(sec_Pk_edos_act);%Encuentra la matriz de Markov que define
%las transiciones entre estados. sec_Pk_edos_Ren para no considerar
%recursividad
[Cells_coords,Pools_coords]=Search_edos_coords(Cells_edos,sis_query,Coord_active);
%Encuentra las coordenadas de las celulas que pertenecen a cada estado y de
%las que pertenecen a los pools mas representativos

c_path_times=c_pathways(Pks_Frame,sec_Pk_edos); %Encuentra las rutas distintas
c_pi=0;
for c_p=1:size(Spikes,2)
    if find(c_path_times(:,3)==c_p)
        c_pi=c_pi+1;
    end
    cumulative(c_p)=c_pi;
end;

[ states_corr, states_lag ] = xcorr_states( Pools_coords, Spikes,200 );
figure(3); plot((states_corr'));

[ sequences_corr, sequences_lag ] = xcorr_sequences( Pools_coords, Spikes,200 );
figure(5); plot((sequences_corr'));

%xcorrc para calcular los intervalos de confianza 
[xcorrel_temp up lo]=xcorrc(Spikes(41,:),Spikes(43,:),'coeff',100,0.99);
mean(up)

%Para graficar las celulas de cada estado y las celulas base

for n_base=1:edos
    figure(11+n_base); scatter(Cells_coords(:,1,n_base),Cells_coords(:,2,n_base));
    hold on; scatter(Pools_coords(:,1,n_base),Pools_coords(:,2,n_base),'fill');hold off
end;

%orientation_pools AGORA
%Centroid_Coords AGORA

Pools_edos=zeros(size(sis_query));
for sp_t=1:edos
    Pools_edos(:,sp_t)=sis_query(:,sp_t)*sp_t;
end

[Shared_Pools]=SharedCells(Pools_edos);

%Para encontrar la media de los OSIs de cada ensamble
%OSI es una matriz [1,numero de celulas] con el OSI de cada celula
[Pools_OSI, Cells_OSI] = orientation_pools(sis_query,OSI,Cells_edos);
mean_Cells_OSI=zeros(edos,1);

for omt=1:edos
    oxt1=find(Cells_OSI(:,omt)==0);
    COSI=Cells_OSI(:,omt);
    COSI(oxt1)=[];
    mean_Cells_OSI(omt)=mean(COSI);
end

mean_Pools_OSI=zeros(edos,1);

for omt2=1:edos
    oxt2=find(Pools_OSI(:,omt2)==0);
    POSI=Pools_OSI(:,omt2);
    POSI(oxt2)=[];
    mean_Pools_OSI(omt2)=mean(POSI);
end


