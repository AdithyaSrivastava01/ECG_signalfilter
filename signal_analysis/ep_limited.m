function [R_peaks_eplimited, delay] = ep_limited(ecg,fs)

    if ~isvector(ecg)
      error('ecg must be a row or column vector');
    end

    ecg = ecg(:); % vectorize

    %% Initialize
    qrs_c =[]; %amplitude of R
    qrs_i =[]; %index
    SIG_LEV = 0; 
    nois_c =[];
    nois_i =[];
    delay = 0;
    skip = 0; % becomes one when a T wave is detected
    not_nois = 0; % it is not noise when not_nois = 1
    selected_RR =[]; % Selected RR intervals
    m_selected_RR = 0;
    mean_RR = 0;
    qrs_i_raw =[];
    qrs_amp_raw=[];
    ser_back = 0; 
    test_m = 0;
    SIGL_buf = [];
    NOISL_buf = [];
    THRS_buf = [];
    SIGL_buf1 = [];
    NOISL_buf1 = [];
    THRS_buf1 = [];

    %% Noise cancelation (Filtering) % Filters (Filter in between 8-16 Hz)
    %% bandpass filter for Noise cancelation of other sampling frequencies(Filtering)
    f1=4; %cuttoff low frequency to get rid of baseline wander
    f2=20; %cuttoff frequency to discard high frequency noise
    Wn=[f1 f2]*2/fs; % cutt off based on fs
    N = 3; % order of 3 less processing
    [a,b] = butter(N,Wn); %bandpass filtering
    ecg_h = filtfilt(a,b,ecg);
    ecg_h = ecg_h/ max( abs(ecg_h));

    %% derivative filter H(z) = (1/8T)(-z^(-2) - 2z^(-1) + 2z + z^(2))
    h_d = [-1 -2 0 2 1]*(1/8); %1/8*fs
    ecg_d = conv (ecg_h ,h_d);
    ecg_d = ecg_d/max(ecg_d);
    delay = delay + 2; % delay of derivative filter 2 samples

    %% not squaring here, but just taking the abs value
    ecg_s = abs(ecg_d);

    %% Moving average Y(nt) = (1/N)[x(nT-(N - 1)T)+ x(nT - (N - 2)T)+...+x(nT)]
    ecg_m = conv(ecg_s ,ones(1 ,round(0.080*fs))/round(0.080*fs));
    delay = delay + 8;

    buffered_ecg = vertcat(zeros(delay,1), ecg_s);
    
    R_peaks_eplimited = QRSDet(ecg_m, buffered_ecg, fs);
    
    
