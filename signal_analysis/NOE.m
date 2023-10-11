function noe=NOE(Filtered_ecg,Slots_Ref,offset)

Slots_Ref_copy=Slots_Ref;
Filtered_ecg_copy=Filtered_ecg;
l1=[];
k1=1;
% NOE class2: if peak exists in cECG but not in Reference
for i=1:length(Slots_Ref)
    for j=1:length(Filtered_ecg_copy)
        if Filtered_ecg_copy(j)-offset<=Slots_Ref(i) && Slots_Ref(i)<=Filtered_ecg_copy(j)+offset
        
            Filtered_ecg_copy(j)=[];
            break;
        end
     
    end
    
end

%  left out peaks
for j=1:length(Filtered_ecg_copy)
    l1(k1)=Filtered_ecg_copy(j);
    k1=k1+1;
end

l2=[];
k2=1;
% NOE class1: if peak exists in Reference but not in cECG
for i=1:length(Filtered_ecg)
    for j=1:length(Slots_Ref_copy)
        if Filtered_ecg(i)-offset<=Slots_Ref_copy(j) && Slots_Ref_copy(j)<=Filtered_ecg(i)+offset
            
            Slots_Ref_copy(j)=[];

            break;
        end
     
    end
    
end
for j=1:length(Slots_Ref_copy)
    l2(k2)=Slots_Ref_copy(j);
    k2=k2+1;
end
disp(['The value of the NOE I is: ' num2str(length(Slots_Ref_copy))]);
disp(['The value of the NOE II is: ' num2str(length(Filtered_ecg_copy))]);
noe=length(Filtered_ecg_copy)+length(Slots_Ref_copy);
