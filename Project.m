%% Script for Checking against the saved files
close all
clear all

cd 'C:\Users\Minhaj Ahmed Moin\Documents\MATLAB\';
inputFile = 'Recording (10).m4a';
[inputop,FS] = audioread(inputFile);

%Minimizing the Lower Frequencies
ps = fft(inputop(:,1));
ps(abs(ps)<max(abs(ps))*0.2) = 0;
ps(abs(ps)>max(abs(ps))*0.8) = ps(abs(ps)>(max(abs(ps))*0.8))*1.2;
figure
subplot(2,2,1);
plot(inputop(:,1));
title('Original Signal')
xlabel('Time');
ylabel('Amplitude');

subplot(2,2,2);
t1 = -length(abs(fft(inputop(:,1))))/2:(length(abs(fft(inputop(:,1))))/2)-1;
plot(t1,abs(fft(inputop(:,1))));      
title('Fourier Transform of Original Signal')
xlabel('Freq (Hz)');
ylabel('Amplitude');

improvedSignal = ifft(ps);

subplot(2,2,3);
plot(improvedSignal(:,1));
title('Filtered Signal')
xlabel('Time');
ylabel('Amplitude');

subplot(2,2,4);
t2 = -length(abs(ps))/2:(length(abs(ps))/2)-1;
plot(t2,abs(ps));
title('Fourier Transform of Filtered Signal');
xlabel('Freq (Hz)');
ylabel('Amplitude');

% improvedSignal = inputop(:,1);

if ~strcmp(pwd,['C:\Users\Minhaj Ahmed Moin\Documents\MATLAB\Project Sounds'])
    cd 'C:\Users\Minhaj Ahmed Moin\Documents\MATLAB\Project Sounds'
end

autocorrelation = xcorr(improvedSignal(:,1),improvedSignal(:,1));
maxAuto = max(autocorrelation);
folder = [dir('*.mp3');dir('*.wav');dir('*.m4a')];
corrs = cell(numel(folder),3);
corrs{1,1} = 'AutoCorr';
corrs{1,2} = maxAuto;
corrs{1,3} = 100;

figure('Name','AutoCorrelation','NumberTitle','off')
t = -length(autocorrelation)/2:1:length(autocorrelation)/2-1;
plot(t,autocorrelation);
title('AutoCorrelation of the Input File');
xlabel('Time');
ylabel('Match');

for i = 1:numel(folder)
    [sounds,Fs] = audioread(folder(i).name);
    p = xcorr(inputop(:,1),sounds(:,1));
    [maxVal, index] = max(p(:));
    corrs{i+1,1} = folder(i).name;
    corrs{i+1,2} = maxVal;
    corrs{i+1,3} = ((maxVal/maxAuto)*100);
    figure('Name',folder(i).name,'NumberTitle','off')
    t = -length(p)/2:1:length(p)/2-1;
    plot(t,p);
    title(['Correlation of Input with ' ,folder(i).name]);
    xlabel('Time');
    ylabel('Match');
end

corrs = sortrows(corrs,-2);
maxValue = corrs{1,2};
matchFile = corrs{1,1};

if strcmp(matchFile,'AutoCorr')
    maxValue = corrs{2,2};
    matchFile = corrs{2,1};
end


for i = 1:length(corrs)
    corrs{i,2} = num2str(corrs{i,2});
end 

figurePos = [100 100 470 400];
columns = {'File', 'Maximum Correlation Value','Percentage of the AutoCorrelation'};
% f = figure('Name','Results','NumberTitle','off','Position', figurePos);
f = figure;
f.Name = 'Results';
f.NumberTitle = 'off';
f.Position = figurePos;
tablePos = [2 180 figurePos(3) figurePos(4)];
tablePos(3) = figurePos(3) - tablePos(1);
tablePos(4) = figurePos(4)-tablePos(2)-20;
titlePos = [figurePos(3)/2 figurePos(4)-20 400 20];
titlePos(1) = figurePos(3)/2 - titlePos(3)/2;
result1Pos = titlePos;
result1Pos(4) = 20;
result1Pos(2) = tablePos(2)-result1Pos(4)-40;
t = uitable;
t.Parent = f;
t.Position = tablePos;
t.Data = corrs;
t.ColumnName = columns;
tabletitle = uicontrol;
tabletitle.Style = 'text';
tabletitle.Position = titlePos;
tabletitle.String = 'Match Result';
tabletitle.FontSize = 10;
tabletitle.FontWeight = 'bold';

result1 = uicontrol;
result1.Style = 'text';
result1.Position = result1Pos;
result1.String = [matchFile ' is most closest to the inputfile'];
result1.FontSize = 10;

result2 = uicontrol;
result2.Style = 'text';
result2.Position = result1Pos;
result2.Position(2) = result1Pos(2)-result1Pos(4)-30;
result2.Position(4) = 40;
result2.FontSize = 20;

if maxValue>=(maxAuto*0.75)
    result2.BackgroundColor = 'green';
    result2.String = [matchFile ' matches with input'];
else
    result2.BackgroundColor = 'red';
    result2.String = [matchFile ' does not match with input'];
end 
cd 'C:\Users\Minhaj Ahmed Moin\Documents\MATLAB\';