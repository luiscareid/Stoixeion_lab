%Para determinar el numero de veces que coinciden eventos especificos
%relacionados con el estimulo visual. LC enero15

%matches_sfunction


%Para calcular la funcion S_index de busquedas aleatorias
csi_cut=0; %Porcentaje de corte para tomar todas las celulas
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
csi_match=zeros(csi_ren,edos);
csi_match=csi_num_temp(1:csi_ren,:); %Celulas de cada estado
mlc_x=121; %numero de elementos en el estado a randomizar
mlc_t1=randperm(mlc_x)';
mlc_t2=mlc_t1(1:20); %numero de elementos para la busqueda
csi_all=[1:121]';
csi_match_rand=sortrows(csi_all(mlc_t2,1)); %estado para randomizar

[S_index_match, query_match]=Search_significant(csi_match_rand,tf_idf_Rasterbin,Rasterbin);

std(S_index_match)*3
