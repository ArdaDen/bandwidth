close all;
clear all;
clc;

%% This code is for illustration of changes in frequency domain with width of pulses. It generates two signals with their pulse widths are determined by some factors and these pulses are located randomly in signals. Then, it plots them in time and frequency domains.

%% Variables
fs = 8e5; % Sampling rate
num_pulses = 1000; % Number of pulses to integrate
factor = 100; % Width of pulses in first signal / Width of pulses in second signal
Time = 20; % Time duration of the signals
pulse_len = 3e-3; % Time duration of single pulse in signal 1
chance_of_location_ind = 10; % İncreasing this number increases the possibility to find a place for the pulses
t = 0:1/fs:Time-1/fs; % Time vector

%% Raised Errors
% Error if the number of samples covered by the pulse is smaller than 1 
if  pulse_len/factor*fs<1 || pulse_len*fs<1
    error("Sampling period is greater than the pulse width")
    
end

% Error if the number of samples covered by the pulse is larger than signal length 
if  pulse_len/factor*fs>length(t) || pulse_len*fs>length(t)
    error("Pulse width is greater than the frame")
    
end

%% Empty signal constructions
signal_1 = zeros(1,length(t)); % Empty signal 1 that will be filled
signal_2 = zeros(1,length(t)); % Empty signal 2 that will be filled
location_indexes_1 = randi(length(t)-pulse_len*fs,1,chance_of_location_ind*num_pulses); % Possible loations that pulses can be put in signal 1
location_indexes_2 = randi(length(t)-pulse_len/factor*fs,1,chance_of_location_ind*num_pulses); % Possible loations that pulses can be put in signal 2

%% Loading the signal 1 with pulses
count_1 = 0; % Number of pulses that are integrated in signal 1
% Filling the first signal with pulses according to the empty places
for i = 1:length(location_indexes_1)
    if sum(signal_1(location_indexes_1(i):location_indexes_1(i)+ceil(pulse_len*fs)))>0 % Checking if the interval is empty
        continue
    else
        signal_1(location_indexes_1(i):location_indexes_1(i)+ceil(pulse_len*fs)) = 1;
        count_1 = count_1+1;
        if count_1 == num_pulses
            disp("All pulses are integrated in first signal.")
            break
        end
    end
end

%% Information about number of pulses integrated in signal 1
% Displaying how many pulses are fitted to first signal
if count_1<num_pulses
    fprintf("The number of pulses integrated into first signal : %d\n" , count_1)
end
% Displaying whether all the pulses can be fitted to first signal
if pulse_len*fs*num_pulses>length(t)
    disp("Not enough room to fit all pulses in first signal.")
end

%% Loading the signal 2 with pulses
count_2 = 0; % Number of pulses that are integrated in signal 2
% Filling the second signal with pulses according to the empty places
for i = 1:length(location_indexes_2)
    if sum(signal_2(location_indexes_2(i):location_indexes_2(i)+ceil(pulse_len/factor*fs)))>0 % Checking if the interval is empty
        continue
    else
        signal_2(location_indexes_2(i):location_indexes_2(i)+ceil(pulse_len/factor*fs)) = 1;
        count_2 = count_2+1;
        if count_2 == num_pulses
            disp("All pulses are integrated in second signal.")
            break
        end
    end
end

%% Information about number of pulses integrated in signal 2
% Displaying how many pulses are fitted to second signal
if count_2<num_pulses
    fprintf("The number of pulses integrated into second signal : %d\n" , count_2)
end
% Displaying whether all the pulses can be fitted to second signal
if pulse_len/factor*fs*num_pulses>length(t)
    disp("Not enough room to fit all pulses in second signal.")
end

%% FFT of the signals in normal and log scale
signal_1_fft = abs(fftshift(fft(signal_1))); % FFT of signal 1
signal_2_fft = abs(fftshift(fft(signal_2))); % FFT of signal 2
signal_1_fft_log = 20*log10(abs(fftshift(fft(signal_1)))); % FFT of signal 1 in dB
signal_2_fft_log = 20*log10(abs(fftshift(fft(signal_2)))); % FFT of signal 2 in dB
freq = linspace(-fs/2,fs/2-fs/length(t),length(t)); % Frequency scale

%% Plots
figure;
tiledlayout(2,3);
ax1 = nexttile;
plot(t,signal_1);
title(["First signal with ",num2str(count_1)," pulses and pulse width of ",num2str(pulse_len)]);
xlabel("Time(s)");
ylabel("Voltage(V)");
xlim([0 Time]);
ylim([0 1]);
ax2 = nexttile;
plot(freq,signal_1_fft/length(t));
title("FFT of first signal");
xlabel("Frequency(Hz)");
ylabel("Amplitude");
ax3 = nexttile;
plot(freq,signal_1_fft_log/length(t));
title("FFT of first signal");
xlabel("Frequency(Hz)");
ylabel("Amplitude(dB)");
xlim([-fs/2 fs/2-fs/length(t)]);
ylim([min([signal_2_fft_log/length(t),signal_1_fft_log/length(t)]) max([signal_2_fft_log/length(t),signal_1_fft_log/length(t)])]);
ax4 = nexttile;
plot(t,signal_2);
title(["Second signal with ",num2str(count_2)," pulses and pulse width of ",num2str(pulse_len/factor)]);
xlabel("Time(s)");
ylabel("Voltage(V)");
xlim([0 Time]);
ylim([0 1]);
ax5 = nexttile;
plot(freq,signal_2_fft/length(t));
title("FFT of first signal");
xlabel("Frequency(Hz)");
ylabel("Amplitude");
ax6 = nexttile;
plot(freq,signal_2_fft_log/length(t));
title("FFT of second signal");
xlabel("Frequency(Hz)");
ylabel("Amplitude(dB)");
xlim([-fs/2 fs/2-fs/length(t)]);
ylim([min([signal_2_fft_log/length(t),signal_1_fft_log/length(t)]) max([signal_2_fft_log/length(t),signal_1_fft_log/length(t)])]);
