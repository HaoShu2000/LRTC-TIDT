addpath(genpath('high-order tensor-SVD Toolbox'));
addpath(genpath('tool'));
addpath(genpath('Pomega'));
addpath(genpath('data'));
dataRoad = ['data/','Pacific'];
load(dataRoad);
X0=Pacific;
dim=size(X0);
k=20;
lambda=1e10;
transformation='fft';
for P_t=[4,6,8,10]
disp(['P_t=' num2str(P_t)]);
Pomega=zeros(dim(1),dim(2),dim(3));
Pomega(1:dim(1)-P_t,:,:)=ones(dim(1)-P_t,dim(2),dim(3));  
Y=X0;%%noise_set:Y=X0+E;
[X] =LRTC_TIDT(Y,Pomega,lambda,k);
Pomegac=1-Pomega;
missingrate=sum(Pomegac,'all')/(dim(1)*dim(2)*dim(3));
MAE=(1/(prod(dim)*missingrate))*sum(abs(Pomegac.*X0-Pomegac.*X),'all');
RMSE=1/sqrt(prod(dim)*missingrate)*sqrt(sum((Pomegac.*X0-Pomegac.*X).^2,'all'));
disp(['MAE=' num2str(MAE)]);
disp(['RMSE=' num2str(RMSE)]);
end


 
