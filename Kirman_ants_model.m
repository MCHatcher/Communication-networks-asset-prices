% Kirman (1993,QJE) -- Stochastic recruitment model

clc; clear;

N = 100;  %No of ants
set = 0:N;  %Set of ants
epsilon = 0.002;
deltta = 0.01;

T_sim = 60000;  %No. of simulated periods
k_t = NaN(T_sim,1);
k_init = 0;  %k_init = randsample(set,1);
k = k_init;
rng(20)

for t=1:T_sim
    
    u = rand;
    p_plus = (1-k/N)*( epsilon + (1-deltta)*k/(N-1) );
    p_minus = k/N*( epsilon + (1-deltta)*(N-k)/(N-1) );
    %p_fix = 1 - p_plus - p_minus;
    
    if u <= p_plus
        k = k+1;
    elseif u > p_plus && u <= p_plus + p_minus
        k = k-1;
    else
        %Do nothing
    end
    
    k_t(t) = k/N;
    
end

figure(1)
subplot(1,2,1), plot(k_t,'k'), title('Simulated value of k_t/N'), xlabel('Time, t') 

