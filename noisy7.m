% in this experiment we investigate the compressible case (exponent parameter: q) 
% for different values of
% lambda. N, s, m are fixed. We vary 'd' in order change lambda. Then we plot
% 'sigma vs SNR' for different values of lambda including block sparse case.

N=180;
Dim=[4,6,8];
L=length(Dim)
m=45;
s=30;

lambda=zeros(1,L);
mean=zeros(1,L);
lamb_eff=zeros(1,L);

try_q=[0.6:0.2:2];
num=length(try_q)

Recon=zeros(L+1,num); % +1 for block case
trials=15;

 M=zeros(N,1);
    for i=1:N
        M(i)=2;
    end

clear AP;
clear Proj;

for ind=1:L
    ind
    d=Dim(ind);
    
    clear AP;
    clear Proj;
    
    [Frame,Proj]=gen_frame(M,N,d);
    
    [alfa,ALFA]=min_angle(Frame,M,N);
    lambda(ind)=max(alfa);
    mean(ind)=sum(alfa)/length(alfa);
    
    index=[1:s]; % since first s entries are larger..
    lamb_eff(ind)=1+norm(ALFA(:,index),'inf');
    
    groups=zeros(N*d,1);
    for i=1:N
        groups((i-1)*d+1:i*d)=i;
    end

    for j=1:num
        j
        q=try_q(j);
        X0=gen_compress_vec(Frame,M,N,d,q);
        X0=X0/norm(X0);
      
        % find the average SNR for FF setup
        SNR=0;
        for t=1:trials
            clear AP;
            A=randn(m,N)/sqrt(m);
            AP=gen_AP_matrix(Proj,A,m,N,d);
            
            Y=AP*X0;
            
            opts = spgSetParms('verbosity',0);  % Turn off the SPGL1 log output
            X = spg_group(AP,Y,groups,0,opts);
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
M=zeros(N,1);
for i=1:N
    M(i)=1;
end

clear AP;
clear Proj;

[Frame,Proj]=gen_frame(M,N,d);

for j=1:num
    j
    q=try_q(j);
    X0=gen_compress_vec(Frame,M,N,d,q);
    X0=X0/norm(X0);
    
    Xb0=zeros(N,d); %block sparsity vector
    for i=1:N
        Xb0(i,:)=X0((i-1)*d+1:i*d);
    end
    
    % find the average SNR for block sparse setup
    SNR=0;
    for t=1:trials
        A=randn(m,N)/sqrt(m);
        Yb=A*Xb0;
        
        opts = spgSetParms('verbosity',0);  % Turn off the SPGL1 log output
        Xb = spg_mmv(A,Yb,0,opts);
        
        SNR=SNR+norm(Xb-Xb0,'fro');
    end
    'finished block'
    Recon(L+1,j)=SNR/trials; %write average SNR for block
end
