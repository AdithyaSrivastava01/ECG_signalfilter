clf()
ecgSignal=load("Subject8876cECG.txt");
Ref=load("Subject8876Ref.txt");
%disp(ecgSignal)
%class(ecgSigna
Ref_new=Ref(242500:244000,3:3);
ecgSignal_new=ecgSignal(242500:244000);
% Step 2: Define the time vector
samplingRate = 500; % Sampling rate in Hz
duration = length(ecgSignal_new) / samplingRate; % Duration of the signal in seconds
time = linspace(0, duration, length(ecgSignal_new));
time_Ref = linspace(0, duration, length(Ref_new));


subplot(2,1,1);
plot(time,ecgSignal_new);
xlabel('Time (s)');
ylabel('Amplitude');
title('cECG Signal');


subplot(2,1,2);

plot(time_Ref,Ref_new);
xlabel('Time (s)');
ylabel('Amplitude');
title('Reference Signal');


% Step 3: Plot the ECG signal
% plot(time(1:1000), ecgSignal_new(1:1000));
% subplot(2,1,1);
% plot(time(1:5000),ecgSignal_new(1:5000));
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('ECG Signal');
% 
% 
% subplot(2,2,1);
% Step 1: Read the CSV file
% data = load("Subject8876MI.csv");
% 
% % Step 2: Extract the data column
% MI = data(483:488);
% 
% % Step 3: Determine the time interval
% timeInterval = seconds(1);
% 
% % Step 4: Create a time vector
% numRows = size(data, 1);
% timeData = (0:timeInterval:(numRows-1)*timeInterval);
% timeData=timeData(480:500);
% plot(timeData,data);
% xlabel('Time (s)');
% ylabel('MI');
% title('Movement');
% % Step 5: Create a timetable
% timetableData = timetable(timeData, dataValues);
% 
% disp(timetableData);

% disp(MI);

InverseMI=zeros(1,length(MI));

for i=1:length(MI)
    InverseMI(i)=1.0-MI(i);
end
% disp(InverseMI);

thresh=0.25;
Slots_MI=[];
j=1;
for i= 1:length(InverseMI)
    if InverseMI(i)<thresh
        Slots_MI(j)=i;
        j=j+1;
    end
end

% disp(timeData);

constant=thresh*ones(length(MI));
% plot(timeData,InverseMI);
% hold on
% plot(timeData,constant,'Color','g');
% hold on
% plot(timeData(Slots_MI),InverseMI(Slots_MI),'ro')
% xlabel('Time (s)');
% ylabel('MI');
% title('Inverse Movement');
