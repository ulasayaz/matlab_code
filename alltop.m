d=5; % prime
N=d^2;
m=6;
s=3;

M=zeros(N,1);
% we fix the dimension of each subspace to 1
for k=1:N
    M(k)=1;
end

%%%%% create alltop vector
x=zeros(d,1);

for k=1:d
    x(k)=exp(1i*2*pi*k^3/d)/sqrt(d);
end
%%%%%%  alltop end

%%%%%%%%%  generate frame
Frame=zeros(d,N);
Proj=zeros(d*N,d*N);
for l=1:d
    for k=1:d
        loc=(l-1)*d+k;
        y=modul(trans(x,k),l);
        Frame(:,loc)=y;
        Proj((loc-1)*d+1:loc*d,(loc-1)*d+1:loc*d)=y*y';
    end
end
%%%%%%%%%  end frame

alfa=min_angle(Frame,M,N);
lambda=max(alfa)
mean=sum(alfa)/length(alfa)

%%%%%%  generate sparse vector
X0=zeros(N*d,1);
p=randperm(N);
index=p(1:s);
index=sort(index);
r=complex(randn(s,1),randn(s,1));
for a=1:s
    X0((index(a)-1)*d+1:index(a)*d)=subfr(Frame,M,index(a))*r(a);
end
X0=X0*10;
%%%%%  end sparse vector

%%%%%  generate random AP matrix
A=randn(m,N);
AP=zeros(m*d,N*d);
for a=1:m
    for b=1:N
        AP((a-1)*d+1:a*d,(b-1)*d+1:b*d)=A(a,b)*Proj((b-1)*d+1:b*d,(b-1)*d+1:b*d);
    end
end
%%%%%%  end AP matrix
      
groups=zeros(N*d,1);
for a=1:N
    groups((a-1)*d+1:a*d)=a;
end

Y=AP*X0;

opts = spgSetParms('verbosity',0);  % Turn off the SPGL1 log output
X = spg_group(AP,Y,groups,0,opts);
err=abs(X-X0);
norm(X-X0)

%%% block sparse experiment without frame structure
% p=randperm(N); p=p(1:s);
% Xb0=zeros(N,d);
% Xb0(p,:)=10*randn(s,d);
% 
% Yb=A*Xb0;

%make vector X0 from FF into a block form
Xb0=zeros(N,d);
for a=1:N
    Xb0(a,:)=X0((a-1)*d+1:a*d);
end
Yb=A*Xb0;

opts = spgSetParms('verbosity',0);  % Turn off the SPGL1 log output
Xb = spg_mmv(A,Yb,0,opts);
norm(Xb-Xb0,'fro')

% t=0:0.01:1;
% hist(alfa,t);
% 
% rc=exp(2i*pi*rand(3,1));