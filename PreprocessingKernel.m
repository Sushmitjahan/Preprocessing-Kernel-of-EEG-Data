%% Loading EEG file
load MDDS1ECR.mat

KeData = double(squeeze( EEG.data) );



%% create and inspect the filter kernel
lowcut = 50; % cutoff frequency for low-pass filter % in Hz
% filter order
filtord = round( 18 * (lowcut*1000/EEG.srate) );

% create filter
filtkern = fir1(filtord,lowcut/(EEG.srate/2),'low');

% inspect the filter kernel
figure(1), clf
subplot(211)
plot((0:length(filtkern)-1)/EEG.srate,filtkern,'k','linew',2)
xlabel('Time (s)')
title('Time domain')


subplot(212)
hz = linspace(0,EEG.srate,length(filtkern));
plot(hz,abs(fft(filtkern)).^2,'ks-','linew',2)
set(gca,'xlim',[0 lowcut*3])
xlabel('Frequency (Hz)'), ylabel('Gain')
title('Frequency domain')



%% filter the data

% make one long trial
supertrial = reshape(KeData,1,[]);

% apply filter
supertrial = filtfilt(filtkern,1,supertrial);
shapedata = reshape(supertrial,size(KeData));
EEG.data=shapedata;



%%
%plot Noise free data
figure(1), clf
plot(EEG.times,EEG.data,'linew',2)
xlabel('Time (ms)'), ylabel('Activity (\muV)')
set(gca,'xlim',[-400 1200])



