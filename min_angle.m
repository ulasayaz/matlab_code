function [alfa,ALFA]=min_angle(Frame,M,N); 
% min_angle finds the mutual angles 
% of the vectors (or subspaces) in a 
% frame and writes them into an
% array. the frame vector (or
% subspaces) should be consist of
% orthonormal components.  

tot=N*(N-1)/2;
%tot
alfa=zeros(1,tot);
ALFA=zeros(N,N);
% 
% L=0;
% 
% for i=1:N-1
%     for j=i+1:N
%         s=svd(subfr(Frame,M,i)'*subfr(Frame,M,j));
%         a = max(s);
%         if a > L
%             L=a;
%         end
%     end
% end
% 
% L

count=0;

for a=1:N-1
    for b=a+1:N
        count=count+1;
        s=svd(subfr(Frame,M,a)'*subfr(Frame,M,b));
        ang = max(s);
        alfa(count)=ang;
        ALFA(a,b)=ang; ALFA(b,a)=ang;
    end
end
%count