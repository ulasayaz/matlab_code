N=10;
m=5;
s=5;
d=3;

M=zeros(N,1);

% we fix the dimension of each subspace to 1
for i=1:N
    M(i)=2;
end
Mtot=sum(M);
Frame=zeros(d,Mtot);


teta=5; % fix the minimum angle between subspaces
rad=teta*pi/180;
lambda=cos(rad);

%%% create the subspaces with angles iteratively
e1=[1,0,0]';
e2=[0,1,0]';
Frame(:,1)=e1;
Frame(:,2)=e2;

%rotation matrix about e1 vector
R=eye(3)*cos(rad)+sin(rad)*[0,0,0;0,0,-1;0,1,0] + (1-cos(rad))*[1,0,0;0,0,0;0,0,0];R^2;

count=1;
for j=1:N-1
    c1=count+M(j);
    count=c1;
    Frame(:,c1)=e1;
    Frame(:,c1+1)=R^j*e2;
end

% X=[e1,e2];
% e2r=R*e2;
% e3=e2r+e1;
% e3=e3/norm(e3);
% Y=[e2r,e3];
% 
% s = svd(X'*Y);
% a = acos(min(s,1));


%%%%%%
%subspace(subfr(Frame,M,1),subfr(Frame,M,2))