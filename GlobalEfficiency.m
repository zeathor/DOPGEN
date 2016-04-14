function [data] = GlobalEfficiency(signal)
    
    if (size(signal,2)< size(signal,1))
        signal = signal';
    end
    
    if (size(signal,1) > 100)
        signal = signal(1:100,:);
    end
    
    Fs = 100;
    nSamples = max(size(signal));
    nChans = min(size(signal));
    %% Determine parameters values
    % Creates a struct to hold all the GE time parameters, stored in GE_tp structure
    trial_length = 10;                 % sec, from Lee et al 2011 (Assumes 12s interval of EEG data is stationary)
    segment_length = 4;
    trial_shift  = 5;
    seg_shift = 0.5;
    
    % Calculate the above variables in samples
    N_samples_trial = trial_length*Fs;
    N_samples_segment = segment_length*Fs;
    N_samples_seg_shift = seg_shift*Fs;
    N_samples_trial_shift = trial_shift*Fs;
    
    % Set trial array calculation attributes
    beg_trial = 1:N_samples_trial_shift:(nSamples-N_samples_trial+1);
    end_trial = beg_trial + N_samples_trial - 1;
    N_trials = numel(beg_trial);
    
    subseg_beg = 1:N_samples_seg_shift:(N_samples_trial-N_samples_segment+1);
    subseg_end = subseg_beg + N_samples_segment - 1;
    
    % Set surrogate calculation attributes
    N_sseg = numel(subseg_beg);
    N_surr_per_ss = 50;                                   % Set 50 surrogate data points per sub-segment
    N_surr = N_sseg*N_surr_per_ss;            % Set number of surrogate data points overall
    
    ind_diag = 1:(nChans+1):(nChans^2);
    
    % Array creation and initialisation
    data.S_G = zeros(1,N_trials);
    data.S_R = zeros(1,N_trials);
    data.S_T = zeros(1,N_trials);
    data.E_W = zeros(1,N_trials);
    data.E_U = zeros(1,N_trials);
    data.E_A = ones(1,N_trials);
    data.e_str = zeros(1,N_trials);
    data.e_top = zeros(1,N_trials);
    bonferroni_alpha = 2*0.05/(nChans*(nChans-1));
    Salpha = 0.001;
       
    %% START THE MOTHERFUCKING GE ANALYSIS!!!
    % for loop of each trial (i.e. segment) and compute steps under (2) above.
    C_orig = zeros(nChans,nChans,N_sseg);
    C_surr = zeros(nChans,nChans,N_surr);

    LamdaT=zeros(N_trials,nChans,N_sseg);
    LamdaR=zeros(N_trials,nChans,N_sseg*N_surr_per_ss);
    
    for k = 1:N_trials
        disp([ 'time = ' num2str(k/N_trials*100) '%'])
        % (2a) Create subsegments and shift surrogate data
        % (2b) For each original and surrogate subsegment calculate Pearson’s equal-time cross correlation co-efficient matrix
        % NOTE: this is dealing with the TRANSPOSE of reref_signal
        segment = signal(:,beg_trial(k):end_trial(k))';
        good_trials(k) = 1;
        
        for p = 1:N_sseg
            % Calculate Pearson’s equal-time cross correlation for current subsegment: of the original data
            subsegment = segment(subseg_beg(p):subseg_end(p),:);
            
            % Creating the pearson's coefficient of our subsegment
            C_orig(:,:,p) = corrcoef(subsegment);
            
            LamdaT(k,:,p) = eig(C_orig(:,:,p));
           
            % Create surrogates and compute C_surr
            for s = 1:N_surr_per_ss
                i_s = (p-1)*N_surr_per_ss + s;

                surrsegment = generate_FT(subsegment);

                C_surr(:,:,i_s) = corrcoef(surrsegment);
                LamdaR(k,:,i_s) = eig(C_surr(:,:,i_s));
            end
        end
        
        % (2c) for the segment, compute the genuine correlation matrix, random correlation matrix, and total correlation matrix
        mu = median(abs(C_orig),3);
        mu_surr = median(abs(C_surr),3);
        v = median(C_orig,3);
        M_T = sign(v).*mu;
        M_R = sign(v).*mu_surr;
        mu_surr(ind_diag) = zeros(1,nChans);
        S = zeros(nChans,nChans);
        for i = 1:nChans
            for j = 1:nChans
                if (i ~= j)
                    [~,S(i,j)] = ranksum(abs(permute(C_orig(i,j,:),[ 3 1 2 ])),abs(permute(C_surr(i,j,:),[ 3 1 2 ])),'alpha',bonferroni_alpha);
                end
            end
        end
        M_G = S.*(M_T-M_R)./(1-mu_surr);
        M_G(ind_diag) = ones(1,nChans);
        
        % (2d) For the segment, compute genuine, random and total correlation strengths     
        data.S_R(k) = (1/(2*(nChans-1)))*sum(abs(mean(LamdaR(k,:,:),3)-1),2);
        data.S_T(k) = (1/(2*(nChans-1)))*sum(abs(mean(LamdaT(k,:,:),3)-1),2);
        bottom = nChans - mean(LamdaR(k,end,:),3) + sum(mean(LamdaR(k,1:(end-1),:),3),2);
        top = 0;
        for c = 1:nChans
            [~,h] = ranksum(squeeze(LamdaT(k,c,:)), squeeze(LamdaR(k,c,:)), 'alpha',Salpha);
            top = top + h*abs(mean(LamdaT(k,c,:),3)-mean(LamdaR(k,c,:),3));
        end
        data.S_G(k) = top/bottom;
              
        % (2e) Compute the weighted, unweighted and all-to-all networks
        invd_W = abs(M_G);
        invd_U = (abs(M_G) > 0);
        
        invd_W(ind_diag) = zeros(1,nChans);
        invd_U(ind_diag) = zeros(1,nChans);
        
        % (2g) Compute the global efficiency for all networks
        % (2h) Compute the contribution of connection strength to global efficiency for all networks
        % (2i) Compute the contribution of network structure to global efficiency for all networks. See eqn 4, 5, 6 on pg 5 PLOS ONE paper
        data.E_W(k) = (1/(nChans*(nChans-1)))*sum(invd_W(:));
        data.E_U(k) = (1/(nChans*(nChans-1)))*sum(invd_U(:));
        data.e_str(k) = data.E_W(k)/data.E_U(k);
        data.e_top(k) = data.E_U(k)/data.E_A(k);
        
    end
end

