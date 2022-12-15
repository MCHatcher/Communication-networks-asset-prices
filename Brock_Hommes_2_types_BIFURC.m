%Stock market model: bifurcation diagrams 
%(m.c.hatcher@soton.ac.uk)

clear; clc; close all; 

%------------------
%Parameter values
%------------------
H = 2; r = 0.1; a = 1; 
dbar = 0.5; sigma = 1; Zbar = 0;  
pf = (dbar - a*sigma^2*Zbar)/r; %Fundamental price

%----------------------
%Specify belief types
%----------------------
M = 25;  %No. of initial values 
window = 14;  %Sample to plot  
T = 4000+window; 
betta_min = 1.9998; betta_max = 4;

%Two beliefs
b = zeros(H,1); C = b; g = linspace(1.2,1.2,H); g = g'; g(1:H/2) = 0; C(g==0) = 1; 

%Bifurcation parameter
betta_stack = [linspace(betta_min,3.326,75) linspace(3.327,betta_max,300)];
num_betta = length(betta_stack);  dev = NaN(num_betta,1); dev1 = dev; dum = dev;
%LyapExp = NaN(M,1); LyapExp2 = NaN(num_betta,1);

%-----------------
%Dividend shocks
%-----------------
shock = zeros(T,1);  %Deterministic skeleton

%------------------------
%Specify initial values
%------------------------
n_init = 1/H*ones(1,H);

%Baseline case
rng(3); init_stack = pf + 2*rand(M,1);

%----------------------
%Preallocate matrices
%----------------------
brk = zeros(M,1); percent = zeros(length(betta_stack),1); x_stack = NaN(window,M); x_plot=NaN(window*M,1); 
x_plot0=NaN(window*M,1); U = NaN(H,1);  D = NaN(H,1);  %Check1 = D; 

for v=1:num_betta 
    
    betta = betta_stack(v);
    x = NaN(T,1); 
    
for m = 1:M

%Initial price    
p0 = init_stack(m); x0 = p0 - pf; xlag = p0 - pf;

for t=1:T 
    
    Beliefs = NaN(H,1);
    
    if t==1
        Beliefs = b + g*x0;
        n = n_init;
    elseif t==2
        Beliefs = b + g*x(t-1);
        n = n_init;
    elseif t>=3
        Beliefs = b + g*x(t-1);
        if t==3
            Dlag2 = (b + g*x0 + a*sigma^2*Zbar - (1+r)*x(t-2))/(a*sigma^2);
        else
            Dlag2 = (b + g*x(t-3) + a*sigma^2*Zbar - (1+r)*x(t-2))/(a*sigma^2);
        end
        U = exp(betta*( (x(t-1) + a*sigma^2*Zbar + shock(t-1) - (1+r)*x(t-2))*Dlag2 - C) );
        n = transpose(U)/sum(U);
    end    
       
x(t) = n*Beliefs/(1+r);   

%------------------------
%Check market clearing
%------------------------
%D = (Beliefs + a*sigma^2*Zbar - (1+r)*x(t))/(a*sigma^2);
%Check1(t) = abs(n*D - Zbar); 

end

%Store value for bifurc diagram
x_stack(1:window,m) = x(end+1-window:end); 

%Lyapunov exponent 
%LyapExp(m) = lyapunovExponent(x);

%-------------------------------
%Record sims with no attractor
%-------------------------------
%Check for no attractor
%r1 = 1-isreal(x(end)); r2 = isnan(x(end)); r3 = isinf(x(end));

%if (r1+r2+r3)>0
%    brk(m) = 1;  
%end

end

x_plot(:,v) = reshape(x_stack,1,[]);
%LyapExp2(v) = max(LyapExp);

%Percentage of sims with no attractor
%percent(v) = 100*sum(brk)/M;

end

%-----------------
% Plot results
%-----------------
figure(1)
hold on, xlabel('Intensity of choice \beta'), ylabel('Price deviation'), 
axis([betta_min,betta_max,-1,2.4]), set(gca, 'box','on')

for v=1:num_betta
   
plot(betta_stack(v), x_plot(:,v),'o', 'MarkerSize', 2, 'Color','k') %[0.5,0.5,0.5]

end

%figure(2)
%plot(betta_stack,LyapExp2)
        
