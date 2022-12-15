% Kirman (1993,QJE) -- Stochastic recruitment model

run Kirman_ants_model
T_sim = 5*10^7;  %No. of simulated periods
k_t = NaN(T_sim,1);

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

%figure(1)
hold on, subplot(1,2,2), histogram(k_t,'FaceColor','black'), title('Simulated distribution for large T'), 
xlabel('k_t/N') 

