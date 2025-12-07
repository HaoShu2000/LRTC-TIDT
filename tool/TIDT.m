function [C] = TIDT(X,k)

dim=size(X);
dimd=[dim(1) k dim(2) dim(3)];
C=zeros(dimd);

for i=1:dim(2)
    for j=1:dim(3)
       a=X(:,i,j);b=circshift(a,1); AB=hankel(a,b);
        C(:,:,i,j)= AB(:,1:k);
    end
end
C= 1/sqrt(k)*C;
% dim=size(X);
% dimd=[n dim];
% C=zeros(dimd);
% 
% for i=1:dim(2)
%     for j=1:dim(3)
%         for t_n=1:n
%             C(t_n,:,i,j)=X(:,i,j);
%              if t_n < n
%                  X(:,i,j) = circshift(X(:,i,j),1);
%              end
%         end
%     end
% end

end
