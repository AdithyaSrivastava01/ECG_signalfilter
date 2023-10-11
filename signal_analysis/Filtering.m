function [Filtered_ecg]=Filtering(data,Slots_ecg,Slots_Ref,thresh)

%Extract the data column
MI = data(2:661)';

InverseMI=zeros(1,length(MI));

for i=1:length(MI)
    InverseMI(i)=1.0-MI(i);
end

% The threhold value
if thresh==0
    Slots_MI=[];
    j=1;
    t=length(InverseMI);
else 
    Slots_MI=[0];
    j=2;
    t=length(InverseMI)-1;
end

%Time Slot Values of MI that are below the threhold

for i= 1:t
    if InverseMI(i)<thresh
        Slots_MI(j)=i;
        j=j+1;
    end
end

RemovalPeaks=[];
k=1;
for i=1:length(Slots_MI)
    for j=1:length(Slots_ecg)
        if Slots_MI(i)==round(Slots_ecg(j))

            RemovalPeaks(k)=Slots_ecg(j);
            k=k+1;
        end
    end
end

Filtered_ecg=setdiff(Slots_ecg,RemovalPeaks);
