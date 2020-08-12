load("rf_data.mat");
fs = 20*10^6; %Sampling rate
T0 = 10^-5;  %Duration of chirp pulse
N=8; %window size
step = 2; %Step size
indices = zeros(21,1); %Stores result starting indices
zxor = dsp.ZeroCrossingDetector(); %Zero crossing detection object
for k = 1:21
    sig = rf_data(:,k);
    %dc = mean(sig);
    %sig = sig - dc;
    
    sig = awgn(sig, 5, 'measured'); %Adds White Gaussian noise
    %sig = bandpass(sig, [1.4*10^6 4.6*10^6], fs);
     
    %z = double(zeros(300));
    j=1;
    zr = zeros(300,1);
    %ZCR for all windows
    for i = 1:step:300
            test = sig(i:i+N);
            n = zxor(test);
            zr(j,1) = double(n)/double(N); %Calculates zero crossing rate in the specified window
            j = j+1;
    end
    
    %Mean for all windows
    m = zeros(300,1);
    j=1;
    for i = 1:step:300
        test = sig(i:i+N);
        m(j,1) = mean(abs(test));
        j = j+1;
    end
    
    noise = sig(1:20);
    noise1 = sig(470:500);
    noise = [noise; noise1]; %Stores background noise of recieved signal
    noise_avg_mag = mean(abs(noise)); %Computes threshold value of magnititude
    dev = std(noise);
    %Setting threshold for mean
    meanUT = 3*noise_avg_mag;    
    meanLT = noise_avg_mag + dev;
    
    %Threshold for zero crossing rate
    ZT = double(zxor(noise)) / double(length(noise));
    j=0;
    start = 3; %Starting from 3rd sample       
    avg_last3pts = 0; %Average value of last 3 sample points
    
    %Checking average against threshold to compensate for noise
    while avg_last3pts < meanUT
      start = start + 1;
      avg_last3pts = (m(start) + m(start-1) + m(start-2))/3; %Using averaging filter to account for noise 
    end
    
    while m(start) > meanLT
      start = start - 1;
    end
    
    below_ZT_count = 0;
    first_below = -999;
    
    if start > 25  %Checking previous 25 frames for dropping of ZCR
      for i = start:-1:start-25
        if zr(i) < ZT
          below_ZT_count = below_ZT_count + 1;
          if first_below == -999
    	first_below = i;
          end
        end
      end
      if below_ZT_count >= 3
        start = first_below;
      end
    end
    
    start = start*step; %Calculate correct index from step size
    indices(k,1) = start;
end
figure
plot(timestamp, z(indices));

indices1 = [1; indices];
timestamp1 = [0; timestamp];
vel = zeros(21,1); %Stores velocity values
for i = 1:21
    vel(i) = (z(indices1(i+1)) - z(indices1(i)))/(timestamp1(i+1) - timestamp1(i)); 
end

figure
plot(timestamp(2:21), vel(2:21));