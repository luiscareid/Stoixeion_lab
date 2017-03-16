%Para calcular la recurrencia de ciclos y de transiciones LCFeb15

%randperm (n,m) n posibles estados m vertices de cada ciclo


%Para encontrar una secuencia dado cierto numero de estados
for sec_edt=2:8 %para todos los vertices
for sec_rect=1:10

    Ht=[1 2];      %Ht1; %[2 3]; %Ciclo que quiero encontrar
    rec_cont=0; %Numero de veces que aparece en un enunciado
    for rt=1:1000 %numero de veces para hacer la distribucion
    %    for rt1=1:rec_s/10 %numero de veces que podria aparecer en el enunciado
            Cycle_temp=randperm(sec_edt,2); %edos,vertices

            if isequal(Ht,Cycle_temp)
                rec_cont=rec_cont+1;
            end

     %   end
      %  rec_contb=rec_contb+rec_cont;
    end
    rec_seq(sec_edt,sec_rect)=rec_cont/1000;
end
end

count=log(rec_seq);
 y = mean(count,2);
 e = std(count,1,2);
 errorbar(y,e,'xr')
 
 
%----------------------------------------------------------------
%Para buscar un ciclo especifico generado aleatoriamente
%rec_s=size(sec_Pk_edos_Ren,2);

for rc_cy=1:size(Ciclos_nums,1);
    
    xxrec=find(Ciclos_nums(rc_cy,:)==0); %numero de renglon para H o E
    Ht1=Ciclos_nums(rc_cy,:);
    Ht1(xxrec)=[];

    Ht=[1 2 3 1];%Ht1;    %Ciclo que quiero encontrar
    rec_cont=0; %Numero de veces que aparece en un enunciado
    %rec_contb=0; %Numero de veces en el total de busquedas
    rec_vert=size(Ht,2);
    if rec_vert==4 %numero de vertices
    
        Cycle_temp=zeros(1,rec_vert-1);
    %     Cycle_temp2=zeros(1,rec_vert);

        for rt=1:1000 %numero de veces para hacer la distribucion
        %    for rt1=1:rec_s/10 %numero de veces que podria aparecer en el enunciado
                Cycle_temp=randperm(rec_vert); %edos,vertices
    %             Cycle_temp2=cat(2,Cycle_temp,Cycle_temp(1));
                if isequal(Ht,Ht(Cycle_temp))
                    rec_cont=rec_cont+1;
                end

         %   end
          %  rec_contb=rec_contb+rec_cont;
        end
    %     mean(log(rec_cont/1000))


        closed_cy_match(rc_cy)=rec_cont/1000;
        xcym=find(closed_cy_match==0);
        matches_all=closed_cy_match;
        matches_all(xcym)=[]
    end
end

% %para figura P_Cycles_mx
% count=log(P_Cycles_mx);
%  y = mean(count,2);
%  e = std(count,1,2);
%  errorbar(y,e,'xr')
% %rec_contb/(rec_s^2*1000)
% 
%--------------------------------------------------------------------
%Para contestar la pregunta de si en un enunciado aleatorio aparecen ciclos
%hamiltonianos o eurelianos
rec_nat_rand=size(sec_Pk_edos_Ren(1,1:end),2);

for rt2=1:100

xxrec_nat=randperm(rec_nat_rand);
sec_pk_random_nat=sec_Pk_edos_Ren(xxrec_nat);
sec_pk_random_ren=SRasRen(sec_pk_random_nat);

[Ciclos_nums,Ciclos_H_E]=CyFolds(sec_pk_random_nat);
ciclos_nat_rand(rt2)=size(Ciclos_nums,1);

% mean(ciclos_nat_rand)

end

mean(ciclos_nat_rand)

%----------------------------------------------------------------------
%Para encontrar las transiciones que son diferentes en un tiempo
%determinado
% c_path_times=c_pathways(Pks_Frame,sec_pk_random); %Encuentra las rutas distintas
% c_pi=0;
% for c_p=1:size(Spikes,2)
%     if find(c_path_times(:,3)==c_p)
%         c_pi=c_pi+1;
%     end
%     cumulative(c_p)=c_pi;
% end;



%----------------------------------------------------------------
%Para generar un ciclo aleatoriamente y luego buscarlo en el enunciado
%original
%rec_s=size(sec_Pk_edos_Ren,2);

for rc_cy=1:size(Ciclos_nums,1);
    
    xxrec=find(Ciclos_nums(rc_cy,:)==0); %numero de renglon para H o E
    Ht1=Ciclos_nums(rc_cy,:);
    Ht1(xxrec)=[];

    Ht=Ht1;    %[1 2 3 1];%Ciclo que quiero comparar
    rec_cont=0; %Numero de veces que aparece en un enunciado
    rec_vert=size(Ht,2);   
        Cycle_temp=zeros(1,rec_vert-1);
        Cycle_temp2=zeros(1,rec_vert);

        for rt=1:1000 %numero de veces para hacer la distribucion
                Cycle_temp=randperm(edos,rec_vert-1); %edos,vertices
                Cycle_temp2=cat(2,Cycle_temp,Cycle_temp(1));
                if isequal(Ht,Cycle_temp)
                    rec_cont=rec_cont+1;
                end

        end

        closed_cy_match(rc_cy)=rec_cont/1000;
        xcym=find(closed_cy_match==0);
        matches_all=closed_cy_match;
        matches_all(xcym)=[]
end


%-----------------------------------------------------------------------
%Para buscar las mismas secuencias en la actividad evocada y espontanea que
%han sido movidas al azar y que forman parte de ciclos H o E
for rect1=1:100
rec_nat_rand=size(sec_Pk_edos_Ren(1,1:41),2);

for rt2=1:1   %numero de repeticiones que quiero

xxrec_nat=randperm(rec_nat_rand);
sec_pk_random_nat=sec_Pk_edos_spont(xxrec_nat); %aqui determino cual usar
%sec_pk_random_ren=SRasRen(sec_pk_random_nat); %tengo que conservar los mismos

[Ciclos_nums_rand,Ciclos_H_E_rand]=CyFolds(sec_pk_random_nat); %tengo que tomar los mismos elementos para que sea significativo
ciclos_nat_rand(rt2)=size(Ciclos_nums_rand,1);

end

mean(ciclos_nat_rand)

 Ciclos_nums_spont=Ciclos_nums_rand; %el que estoy cambiando

%-----------------------------------------------------------------
%Para calcular cuantas secuencias evocadas tambien aparecen en la 
%actividad espontanea

M_adj_nat=zeros(edos,edos); %genero la matriz adyacente global

for rc_cy=1:size(Ciclos_nums_nat,1); %tomo todos los ciclos
    
    xxrec=find(Ciclos_nums_nat(rc_cy,:)==0); %numero de renglon para H o E
    Ht1=Ciclos_nums_nat(rc_cy,:);
    Ht1(xxrec)=[];
    
    for ma_t1=1:(size(Ht1,2)-1);
        if M_adj_nat(Ht1(ma_t1),Ht1(ma_t1+1))==0;
            M_adj_nat(Ht1(ma_t1),Ht1(ma_t1+1))=1;
        elseif M_adj_nat(Ht1(ma_t1),Ht1(ma_t1+1))>0;
            M_adj_nat(Ht1(ma_t1),Ht1(ma_t1+1))=M_adj_nat(Ht1(ma_t1),Ht1(ma_t1+1))+1;
        end
    end
    
end

M_nat_rec=(M_adj_nat>1)*1;

%------------------------------------------

M_adj_spont=zeros(edos,edos); %genero la matriz adyacente global

for rc_cy=1:size(Ciclos_nums_spont,1); %tomo todos los ciclos
    
    xxrec=find(Ciclos_nums_spont(rc_cy,:)==0); %numero de renglon para H o E
    Ht1=Ciclos_nums_spont(rc_cy,:);
    Ht1(xxrec)=[];
    
    for ma_t1=1:(size(Ht1,2)-1);
        M_adj_spont(Ht1(ma_t1),Ht1(ma_t1+1))=1;
        
    end
    
end


M_nat_spont=(M_nat_rec&M_adj_spont)*1;
M_total=or(M_nat_rec,M_adj_spont)*1;
M_nat_edges=sum(sum(M_adj_nat));
M_spont_edges=sum(sum(M_adj_spont));
M_nat_spont_edges=sum(sum(M_nat_spont))
M_total_edges=sum(sum(M_total));
M_nat_rec_edges=sum(sum(M_nat_rec));


recurrence_random=M_nat_spont_edges/M_nat_rec_edges;

end
mean(recurrence_random)

%----------------------------------------------
%Para encontrar el intervalo entre las secuencias recurrentes antes y
%durante la estimulacion

% M_nat_spont %dice cuales son las secuencias recurrentes
% M_nat_spont_edges %numero de secuencias recurrentes
% sec_Pk_edos_Ren %para encontrar las secuencias
% sec_Pk_frames %para encontrar los frames


recurrent_sequences=zeros(M_nat_spont_edges,2);
[row, col]=find(M_nat_spont==1);
recurrent_sequences(:,1)=row;
recurrent_sequences(:,2)=col;
recurrent_sequences=sortrows(recurrent_sequences); %secuencias recurrentes
rec_seq_max=size(sec_Pk_edos_Ren(1,:),2); %numero total de elementos
rec_seq_loc=zeros(M_nat_spont_edges,rec_seq_max);


for recseqt=1:M_nat_spont_edges
    first_seqt=find(sec_Pk_edos_Ren==recurrent_sequences(recseqt,1));
    for rct2=1:size(first_seqt,2)-1;
        if sec_Pk_edos_Ren(first_seqt(rct2)+1)==recurrent_sequences(recseqt,2)
%            recseqt      %indica la secuencia
%            first_seqt(rct2) %indica el indice en sec_Pk_edos_Ren
            rec_seq_loc(recseqt,rct2)=first_seqt(rct2); 
        end
    end    
end


for hh=1:984 %para encontrar los frames
    if sec_Pk_frames(hh)>0
rec_seq_frame(hh,:)=[Pks_Frame(hh) sec_Pk_frames(hh)];
    end
end;
xxt=find(rec_seq_frame(:,1)==0);
rec_seq_frame(xxt,:)=[];

%------------------------------------------------------
%Para encontrar a partir de que valor son significativamente diferentes

(size(find(S_index_ti<0.99))-size(find(S_index_ti<0.9)))/955^2 %para cada intervalo


% count=log(P_Cycles_mx);
%  y = mean(count,2);
%  e = std(count,1,2);
%  errorbar(y,e,'xr')

