function [Slots_ecg,Slots_Ref]=RPeak(ecgSignal,Ref)
% clf();
%The Time slots for Reference and ECG signal

ecgSignal_new=ecgSignal(75:330074);

Reference_new=Ref(:,3:3);
fs=500;

R_peaks_transpose_ecg=ep_limited(ecgSignal_new,fs);
R_peaks_ecg=R_peaks_transpose_ecg';

Slots_ecg=zeros(1,length(R_peaks_ecg));
for i= 1:length(R_peaks_ecg)
    Slots_ecg(i)=(R_peaks_ecg(i))/500;
end


R_peaks_transpose=ep_limited(Reference_new,fs);
R_peaks=R_peaks_transpose';

Slots_Ref=zeros(1,length(R_peaks));
for i= 1:length(R_peaks)
    Slots_Ref(i)=(R_peaks(i))/500;
end












