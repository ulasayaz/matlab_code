% investigates the effect of 'd' and 'w' to the parameter 'lambda'.

N=30;

%d=[5:10:85];
d=5;
% S=size(d,2);
% lambda=zeros(S,1);

M=zeros(N,1);

% we fix the dimension of each subspace to 1
for i=1:N
    M(i)=1;
end
Mtot=sum(M);

clear Proj;
% trial=1;
% for i=1:S
%     i
%     for t=1:trial
%         Frame=gen_frame(M,N,d(i));
%         lambda(i)=lambda(i)+min_angle(Frame,M,N);
%     end
%     lambda(i)=lambda(i)/trial;
% end

[Frame,Proj]=gen_frame(M,N,d);
S=min_angle(Frame,M,N);

x=0:0.01:1;
%hist(S,x);

lambda=max(S)
mean=sum(S)/length(S)
