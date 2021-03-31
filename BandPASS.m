clear all;
clc;
close all;
% Intial settings
Fs=10e3;        % Sampling Frequency
t=(0:Fs)/Fs';   % Time Vector
L=8630;         % FFT length
NFFT=2048;      
f=Fs*linspace(0,1,NFFT); % Frequency Vector
%-- Generate composite signal with 586Hz and 863Hz frequency components --%
comp_sig=sin(2*pi*586*t)+sin(2*pi*863*t);
%-- Calculate FFT of composite signa; --%
comp_sig_fft=fft(comp_sig,NFFT)/L;
%-- Generate Filter for 586Hz signal--%
bw=10;      %Bandwith
fc=pi*586;  %Center Frequency
n=1:L;
%Compute Hamming window
for n=1:L
    hamm(n)=(0.54-0.46*cos(2*pi*n/L));
end
%Compute Filter
hsuup=(-(L-1)/2:(L-1)/2);
hideal1=hamm.*(2*(fc+bw)*(sin(2*(fc+bw)*hsuup/Fs)./(2*(2*fc+bw)*hsuup/Fs)));
hideal2=hamm.*(2*(fc-bw)*(sin(2*(fc-bw)*hsuup/Fs)./(2*(2*fc+bw)*hsuup/Fs)));
h_bpf=(hideal1-hideal2);
% Filtering in freq domain
h_bpf_fft=fft(h_bpf,NFFT)/L;
s586_fft=comp_sig_fft.*h_bpf_fft;
s586=real(ifft(s586_fft));
%-- Generate Filter for 863Hz signal --%
bw=10;      %Bandwidth
fc=pi*863;  %center frequency
%Compute Filter
hideal1=hamm.*(2*(fc+bw)*(sin(2*(fc+bw)*hsuup/Fs)./(2*(fc+bw)*hsuup/Fs)));
hideal2=hamm.*(2*(fc-bw)*(sin(2*(fc-bw)*hsuup/Fs)./(2*(fc+bw)*hsuup/Fs)));
h_bpf=(hideal1-hideal2);
% Filtering in freq domain
h_bpf_fft=fft(h_bpf,NFFT)/L;
s863_fft=comp_sig_fft.*h_bpf_fft;
s863=real(ifft(s863_fft));
%-- plot all signals ---%
figure;
subplot(411);
plot(t,comp_sig);grid on
axis([0 0.1 -2 2])
title('Composite signal with 586Hz and 863Hz frequencies')
subplot(412)
plot(f,2*abs(comp_sig_fft));grid on;
axis([0 5000 0 1.5])
title('Frequency components of composite signal')
subplot(413);
plot(s586);hold on
plot(s863,'r');grid on
title('After Filtering')
legend('586Hz','863Hz')
subplot(414);
plot(f,2*abs(s586_fft));hold on;
plot(f,2*abs(s863_fft),'r');grid on;
axis([0 500 0 10])
title('After filtering ini frequency domain')
legend('586Hz','863Hz')
