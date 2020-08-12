load("rf_data.mat");
fs = 20*10^6; %Sampling rate
sig = rf_data; %Given data
%sig = bandpass(sig, [1.4*10^6 4.6*10^6], fs);
T0 = 10^-5; %Duration of chirp pulse
t = 0:1/fs:T0; 
%Chirp parameters
c = 3*10^11; 
f0 = 1.5*10^6;

chip = sin(pi*c*t.^2 + 2*pi*f0*t); 
chip = chip';
%Generates sinusoidal chirp signal of required duration, bandwidth and central frequency. 

sig = awgn(sig, 3, 'measured'); %adds White Gaussian noise to the signals in rf_data
%chip = awgn(chip, 10, 'measured', 'dB');
%chip = bandpass(chip, [1.4*10^6 4.6*10^6], fs);

% w1 = 0;
% w2 = 0;
% fftest = ff(:,12);
% for i = 1:500
%     if(abs(fftest(i)) > 0.1)
%         w1 = i;
%         break;
%     end
% end

% for j = 200:-1:1
%     if(abs(fftest(j)) > 0.1)
%         w2 = j;
%         break;
%     end
% end
%w2 = 104;
%w1 = 39;

%figure
%plot(abs(ff));

y = zeros(999,21);
for i = 1:21
    y(:,i) = xcorr(sig(:,i), chip);  %computes cross correlation sequence of each signal in rf_data with input
end

[~,ind] = max(abs(y)); %Extracts peak of the seq.
ind = ind-500; %to compute delay indices

figure
plot(timestamp, z(ind));

indices1 = [1 ind];
timestamp1 = [0; timestamp];
vel = zeros(21,1);
%Computes velocity profile
for i = 1:21
    vel(i) = (z(indices1(i+1)) - z(indices1(i)))/(timestamp1(i+1) - timestamp1(i)); 
end

figure
plot(timestamp(2:21), vel(2:21));
