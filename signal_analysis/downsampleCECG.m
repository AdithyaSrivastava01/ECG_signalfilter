%% Loading data and run Visualizer
% Version 4.2 - Movement Markers implemented
% NOTES: Plux 500Hz - Capical 560Hz
clear all;
addpath(genpath('libs'));

% open Capical file
% [capEcg, samplesRead, capFilename] = ReadGen4;
[capEcg, samplesRead, capFilename] = ReadPlriEcgRecord();
out = calcLeads(capEcg, 5);

% open Plux file
[file, path] = uigetfile('*.txt');
plux_path = strcat(path, file);

fid = fopen(plux_path);
while ~feof(fid)
  l=fgetl(fid);
  if ~isempty(fid), frewind(fid), break, end
  %if ~isempty(strfind(l,'# End of File')), break, end
end
% Sample ID, ??, optical signal, ECG
%a = textscan(fid,'%d %d %d %d %d');
%celldisp(a);
pluxData=cell2mat(textscan(fid,'%d %d %d %d %d %*[^\n]'));

fid=fclose(fid);
% 
% p = double(pluxData(:,3));
% refECG = resample(p, 200, 500);
%% Accessing Plux Data
pluxData = evalin('base','pluxData');

%% Accessing Capical Data
capData = evalin('base','out');
%printf(capData);
capEcg = evalin('base','capEcg');

% temporary names of leads
capLeadNames = 1:28;
% A = pluxData(:,3)
A = capData(:,10);
chairECG = resample(A, 500, 560);
csvwrite('Subject1204cECG_test.txt', chairECG);
plot(chairECG);


