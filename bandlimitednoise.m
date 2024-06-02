close all;
clear all;
clc;

%% This code resamples the bandlimited noise and illustrates the FFT and bandwidth change

%% Variables
fs = 8e3; % Original sampling rate 
fft_len=256; % Number of FFT points
Time = 2; % Time duration
resampling_rate = 5; % Resampling factor 
t = 0:1/fs:(Time-1/fs); % Time vector

%% Noise construction
noise = randn(1,length(t)); % Noise 
noise_resampled = resample(noise,resampling_rate,1); % Resampled noise

%% FFT of noise before and after resampling
noise_fft = fftshift(fft(noise,fft_len)); % FFT of noise
noise_resampled_fft = fftshift(fft(noise_resampled,fft_len)); % FFT of resampled noise
freq_noise_fft = linspace(-fs/2,fs/2-fs/fft_len,fft_len); % Frequency scale for noise
freq_noise_fft_re = linspace(-fs/2,fs/2-fs/fft_len,fft_len); % Frequency scale for resampled noise

%% Plots
figure;
tiledlayout(1,2);
ax1 = nexttile;
plot(freq_noise_fft,abs(noise_fft)/fft_len);
title("FFT of Noise");
xlabel("Frequency(Hz)");
ylabel("Amplitude");
xlim([-fs/2,fs/2])
ylim([0 max(abs(noise_resampled_fft)/fft_len)])
ax2 = nexttile;
plot(freq_noise_fft_re,abs(noise_resampled_fft)/fft_len);
title("FFT of Resampled Noise");
xlabel("Frequency(Hz)");
ylabel("Amplitude");
xlim([-fs/2,fs/2])
ylim([0 max(abs(noise_resampled_fft/fft_len))])


