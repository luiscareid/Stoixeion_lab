%LC2014. Feb 7
%Deteccion de estados usando conceptos de algebra lineal
%La matriz formada por la multiplicacion de los eigenvalues*eigenvectors' 
%indica el conjunto de vectores linealmente independientes que describen el
%comportamiento de la red. 
%Una limitacion es que los patrones deben aparecer varias veces
%para ser considerados como estados. Para solucionar el problema solo es
%necesario concatenar la misma matriz spikes un par de veces y aparecen
%todos los patrones que no aparecian antes
%En esta rutina se genera la grafica de transiciones de estados poniendo
%cada estado de un color diferente
%En esta version uso SVD para proyectar la matriz original en otro espacio
%ortonormal dado por los eigenvalues*eigenvectors'
%X=U*S*V'; Dado que la matriz de entrada es simetrica U=V=V'=U'
%La diferencia con usar los eigenvalues es que para SVD los valores de la
%diagonal principal siempre son positivos. Por otro lado no depende de que
%la matriz original Rasterbin sea no singular.

% edos_svd=floor(edos_size_cut*size(Rasterbin,1)); %numero maximo de estados
% calculado como porcentaje del total de celulas. Si cada celula representa
% un estado entonces el analisis no tiene sentido
% Otra propiedad importante es que X'X=VSV' como X'X es conceptualmente
% igual al producto punto U=V

edos_vec=size(S_indexp,2);
rj0_svd=S_indexp;
[U_svd,S_svd,V_svd]=svd(rj0_svd);
% Ut_X=abs(S_svd*V_svd'); %Proyecto mi matriz original sobre SV'
S_svd_sig=S_svd;
edos_size_cut=20; %Para determinar el numero de valores sigulares significativos
%en general es menor de 20 figure; plot(sum(S_svd)*1)

S_svd_cut=S_svd_sig(edos_size_cut,edos_size_cut); %maximo valor de S calculado 
S_svd_sig(edos_size_cut+1:edos_vec,:)=[]; %quito los valores menores al corte en renglones
S_svd_sig(:,edos_size_cut+1:edos_vec)=[]; %quito los valores menores al corte en columnas
V_svd_tsig=V_svd';
V_svd_tsig(edos_size_cut+1:edos_vec,:)=[]; %quito los valores menores al corte en renglones
svd_fac=zeros(edos_vec,edos_vec,edos_size_cut);

% figure(3)
for efsvd=1:edos_size_cut
    svd_fac(:,:,efsvd)=(abs(V_svd_tsig(efsvd,:)'*V_svd_tsig(efsvd,:))*S_svd_sig(efsvd,efsvd));
end;

edos_svd_cut=0.75; %Corte para los factores del svd. Pensar en una manera de normalizar
svd_fac=(svd_fac>edos_svd_cut)*1;
% implay(svd_fac); %Para visualizar los factores como pelicula
%para graficar las repeticiones arriba del azar 
svd_fac_mag=zeros(edos_size_cut); 
for sftemp=1:20
    svd_fac_mag(sftemp)=sum(sum(svd_fac(:,:,sftemp)));
end
svd_fac_mag=sort(svd_fac_mag,'descend');

%Con esto determino el numero de estados figure; plot((sum(svd_fac(:,:,1))))

rep_svd=20^2-1; %Encuentra los repetidos mas de n veces; n sale de plot(svd_fac_mag)LCR dic15
svd_sig=svd_fac(:,:,find(sum(sum(svd_fac(:,:,:)))>rep_svd)); 
%para grafica de factores figure; imagesc(svd_fac(:,:,10)==0)

%para comprobar que dos vectores no pertenecen al mismo estado la suma de
%todos los vectores no debe ser mayor a 1
edos_rep=size(svd_sig,3);
edos_pks_num=zeros(edos_rep,edos_vec);
edos_pks=zeros(edos_rep,edos_vec);
for epi=1:edos_rep %Numero estados
    edos_pks=find((sum(svd_sig(:,:,epi)))>0);
    edos_pks_num(epi,edos_pks)=1;
end;
 

%Para comprobar que dos edos no se sobrelapan figure; plot(sum(edos_pks_num));
%Si se enciman subir edos_svd_cut
edos_pks_num_sort=sortrows(edos_pks_num);
edos_pks_num_sort=rot90(edos_pks_num_sort');
edos_pks_num_sort_n=zeros(size(edos_pks_num_sort));
for epii=1:edos_rep %Numero estados
    edos_pks_num_sort_n(epii,:)=edos_pks_num_sort(epii,:)*epii;
end;
% RGB_label_svd = label2rgb(edos_pks_num_sort_n, @lines, 'w', 'noshuffle');
figure(4)
% imshow(RGB_label_svd,'InitialMagnification','fit')
imagesc(edos_pks_num_sort_n==0) %Para figura blanco y negro

edos_pks_numb=edos_pks_num';
C_edos_svd=zeros(size(edos_pks_numb));
for epix=1:size(edos_pks_numb,1)
    C_edos_svd(epix,:)=edos_pks_numb(epix,:)*epix;
end;

sec_Pk_frames_svd=sum(edos_pks_num_sort_n);

%Para incorporarlo en Stoixeion
C_edos=edos_pks_num_sort';
sec_Pk_edos=sec_Pk_frames_svd;

