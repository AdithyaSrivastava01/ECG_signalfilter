
ecgSignal=load("Subject2453cECG.txt");
Ref=load("Subject2453Ref.txt");
data = load("Subject2453MI.csv");
offset=0.979;
% Slots detection
[Slots_ecg,Slots_Ref]=RPeak(ecgSignal,Ref);

% Logging the errors into a dictionary
filename="Subject2453NOE.csv";
%Filtering
list=[];
thresh=0.0;

while thresh<1.0
    if thresh>0.9
        [Filtered_ecg]=Filtering(data,Slots_ecg,Slots_Ref,thresh);
        noe=NOE(Filtered_ecg,Slots_Ref,offset);
        cell=[thresh noe];
        list=[list ; cell];

        thresh=thresh+0.005;
        disp(['The value of the threshold is: ' num2str(thresh)]);
        disp(['The value of the NOE is: ' num2str(noe)]);



    
    else

    [Filtered_ecg]=Filtering(data,Slots_ecg,Slots_Ref,thresh);
    noe=NOE(Filtered_ecg,Slots_Ref,offset);
    cell=[thresh noe];
    list=[list ; cell];

    thresh=thresh+0.025;
    disp(['The value of the threshold is: ' num2str(thresh)]);
    disp(['The value of the NOE is: ' num2str(noe)]);
    % break
    end
end

writematrix(list,filename);
data=load(filename);
visualnoe(data);

