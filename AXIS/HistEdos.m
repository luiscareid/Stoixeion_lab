%Creado por LC.
%Grafica el histograma de la actividad global y pone encima de cada pico el
%numero del estado al que pertenece.


function [Hist_Edos]=HistEdos(Spikes,Pks_Frame,sec_Pk_Frame,pks)

Hist_Edos=sum(Spikes);

figure(7)
plot(Hist_Edos)

H=size(Pks_Frame,2);
hg=max(sum(Spikes));


for hh=1:H
    if sec_Pk_Frame(hh)>0
text(Pks_Frame(hh),sec_Pk_Frame(hh)*2.5+(hg-pks)/5,[num2str(sec_Pk_Frame(hh))],'FontSize',10)
    end
end;

hi=size(Spikes,2);
Pks_Frame_plot=zeros(hi,1);
%para hacer la grafica de transiciones en funcion del numero de frames
%reales
for hh=1:H
    if sec_Pk_Frame(hh)>0
    Pks_Frame_plot(Pks_Frame(hh))=sec_Pk_Frame(hh);
    end
end;