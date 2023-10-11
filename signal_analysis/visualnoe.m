function []=visualnoe(data)
thresh=data(:,1:1);
NOE_new=data(:,2:2);


plot(thresh,NOE_new);
% xlabel('Threshold');
% ylabel('NOE');
% title('Threshold vs NOE');


