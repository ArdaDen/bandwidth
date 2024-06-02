close all;
clear all;
clc;

%% This code is for illustration of changes in frequency domain with number of pulses. It generates two signals with their pulse numbers are determined by some factors and these pulses are located in order in signals. Then, it plots them in time and frequency domains.

%% Variables
fs = 8e3; % Sampling rate
Time = 10; % Time duration of the signals
t = 0:1/fs:Time-1/fs; % Time vector
pulse_width_1 = 1; % Width of a single pulse in first signal
pulse_width_2 = 1e-3; % Width of a single pulse in second signal

%% Raised errors for pulse 1
% Error if the number of samples covered by the pulse is smaller than 1 
if  pulse_width_1*fs<1
    error("Sampling period is greater than the pulse width 1")
end

% Error if the number of samples covered by the pulse is larger than signal length 
if  pulse_width_1*fs>length(t)
    error("Pulse width 1 is greater than the frame")
    
end

%% Constructing the signal 1 and taking the FFT
offset = pulse_width_1/2:pulse_width_1*2:Time; % Offset
signal_1 = pulstran(t,offset,"rectpuls",pulse_width_1); % First signal
signal_1_fft = fftshift(fft(signal_1)); % FFT of first signal
freq_scale = linspace(-fs/2,fs/2-fs/length(t),length(t)); % Frequency scale

%% Raised errors for pulse 2
% Error if the number of samples covered by the pulse is smaller than 1 
if  pulse_width_2*fs<1
    error("Sampling period is greater than the pulse width 2")
end

% Error if the number of samples covered by the pulse is larger than signal length 
if  pulse_width_2*fs>length(t)
    error("Pulse width 2 is greater than the frame")
    
end

%% Constructing the signal 2 and taking the FFT
offset = pulse_width_2/2:pulse_width_2*2:Time; % Offset
signal_2 = pulstran(t,offset,"rectpuls",pulse_width_2); % Second signal
signal_2_fft = fftshift(fft(signal_2)); % FFT of second signal

%% Plots
figure;
tiledlayout(2,2);
ax1 = nexttile;
plot(t,signal_1);
title(["First signal with pulse width of ",num2str(pulse_width_1)]);
xlabel("Time(s)");
ylabel("Voltage(V)");
xlim([0 Time]);
ylim([0 1]);
ax2 = nexttile;
plot(freq_scale,abs(signal_1_fft)/length(t));
title("FFT of first signal");
xlabel("Frequency(Hz)");
ylabel("Amplitude");
ax3 = nexttile;
plot(t,signal_2);
title(["Second signal with pulse width of ",num2str(pulse_width_2)]);
xlabel("Time(s)");
ylabel("Voltage(V)");
xlim([0 Time]);
ylim([0 1]);
ax4 = nexttile;
plot(freq_scale,abs(signal_2_fft)/length(t));
title("FFT of second signal");
xlabel("Frequency(Hz)");
ylabel("Amplitude");
