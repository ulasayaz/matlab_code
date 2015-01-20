% in this experiment we investigate the noisy case for different values of
% lambda. N, s are fixed. We vary 'd' in order change lambda. Then we plot
% 'm vs SNR' for different values of lambda including block sparse case.
% we generated "berlin_noisy2_error" figure with this code. 


N=200;
Dim=[3,10,40];
L=length(Dim);
s=20;

lambda=zeros(1,L);
mean=zeros(1,L);
lamb_eff=zeros(1,L);

try_m=[5:5:70];
num=length(try_m)

Recon=zeros(L+1,num); % +1 for block case
trials=15;

sigma=0.06; % noise parameter

M=zeros(N,1);
% we fix the dimension of each subspace to 1
for i=1:N
    M(i)=1;
end

clear AP;
clear Proj;

for ind=1:L
    ind
    d=Dim(ind);
    
    [Frame,Proj]=gen_frame(M,N,d);
    
    [alfa,ALFA]=min_angle(Frame,M,N);
    lambda(ind)=max(alfa);
    mean(ind)=sum(alfa)/length(alfa);
    
    groups=zeros(N*d,1);
    for i=1:N
        groups((i-1)*d+1:i*d)=i;
    end
    
    [X0,index,x_lambda]=gen_sparse_vec(Frame,M,N,d,s); % FF sparse vector
    X0=X0/norm(X0);
    lamb_eff(ind)=1+norm(ALFA(:,index),'inf');
    
    for j=1:num
        j
        m=try_m(j);
        erb=randn(m,d);
        erb=erb/norm(erb,'fro');
        f=erb';
        err=f(:);
        
        % find the average SNR for FF setup
        SNR=0;
        for t=1:trials
            A=randn(m,N)/sqrt(m);
            AP=gen_AP_matrix(Proj,A,m,N,d);
            
            Y=AP*X0+sigma*err;
            
            opts = spgSetParms('verbosity',0);  % Turn off the SPGL1 log output
            X = spg_group(AP,Y,groups,sigma,opts);
            %clear AP;
            SNR=SNR+norm(X-X0);
            %SNR=SNR+20*log10(norm(X0)/norm(X0-X));
        end
        'finished FF'
        Recon(ind,j)=SNR/trials; %write average SNR for FF   
    end   
end

% block sparse case
d=3;

[Frame,Proj]=gen_frame(M,N,d);

[X0,index,x_lambda]=gen_sparse_vec(Frame,M,N,d,s); % FF sparse vector
X0=X0/norm(X0);

Xb0=zeros(N,d); %block sparsity vector
for i=1:N
    Xb0(i,:)=X0((i-1)*d+1:i*d);
end

for j=1:num
    j
    m=try_m(j);
    erb=randn(m,d);
    erb=erb/norm(erb,'fro');
    f=erb';
    err=f(:);
    sigma=0.06;
       
    % find the average SNR for block sparse setup
    SNR=0;
    for t=1:trials
        A=randn(m,N)/sqrt(m);
        Yb=A*Xb0+sigma*erb;
        
        opts = spgSetParms('verbosity',0);  % Turn off the SPGL1 log output
        Xb = spg_mmv(A,Yb,sigma,opts);
        
        SNR=SNR+norm(Xb-Xb0,'fro');
    end
    'finished block'
    Recon(L+1,j)=SNR/trials; %write average SNR for block
end

plot(try_m,Recon(1,:));
hold
plot(try_m,Recon(2,:));
plot(try_m,Recon(3,:));
plot(try_m,Recon(4,:));
