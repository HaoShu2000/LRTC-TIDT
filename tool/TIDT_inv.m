
function [X] = TIDT_inv(C)
dim=size(C);
X=C(:,1,:,:);
X=reshape(X,dim(1),dim(3),dim(4));
X=sqrt(dim(2))*X;
% dim=size(C);
% X=C(1,:,:,:);
% X=reshape(X,dim(2),dim(3),dim(4));
end

