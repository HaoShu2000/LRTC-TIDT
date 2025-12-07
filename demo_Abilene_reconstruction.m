addpath(genpath('high-order tensor-SVD Toolbox'));
addpath(genpath('tool'));
addpath(genpath('Pomega'));
addpath(genpath('data'));
dataRoad = ['data/','Abilene'];
load(dataRoad);
X0=Abilene;
dim=size(X0);
k=50;
lambda=1e10;
for samplingrate=[0.2,0.4,0.6,0.8,0.3,0.7,0.5]%0.2,0.4,0.6,0.8,0.3,0.7,0.5
    switch (samplingrate)
        case  0.2
             dataRoad = ['Pomega/','P_Abilene_t_nonrandon_20%'];
        case  0.4
             dataRoad = ['Pomega/','P_Abilene_t_nonrandon_40%'];         
        case  0.6
             dataRoad = ['Pomega/','P_Abilene_t_nonrandon_60%'];  
        case  0.8
              dataRoad = ['Pomega/','P_Abilene_t_nonrandon_80%'];             
        case  0.9
              dataRoad = ['Pomega/','P_Abilene_t_nonrandon_90%']; 
        case  0.7
             dataRoad = ['Pomega/','P_Abilene_t_nonrandon2_70%']; 
        case  0.3
             dataRoad = ['Pomega/','P_Abilene_t_nonrandon2_30%']; 
        case  0.5
             dataRoad = ['Pomega/','P_Abilene_t_nonrandon3_50%'];        
    end
load(dataRoad); 
disp(['samplingrate=' num2str(samplingrate)]);
Y=X0;%%noise_set:Y=X0+E;
[X] =LRTC_TIDT(Y,Pomega,lambda,k);
Pomegac=1-Pomega;
missingrate=sum(Pomegac,'all')/(dim(1)*dim(2)*dim(3));
MAE=(1/(prod(dim)*missingrate))*sum(abs(Pomegac.*X0-Pomegac.*X),'all');
RMSE=1/sqrt(prod(dim)*missingrate)*sqrt(sum((Pomegac.*X0-Pomegac.*X).^2,'all'));
disp(['MAE=' num2str(MAE)]);
disp(['RMSE=' num2str(RMSE)]);
end







% disp("LRTC_THT_Abilene_t_nonrandon")
% addpath(genpath('tool'));
% addpath(genpath('Pomega'));
% addpath(genpath('data'));
% addpath(genpath('noise_X0'));
% dataRoad = ['data/','Abilene'];
% load(dataRoad);
% X0=Abilene;
% dim=size(X0);
% rho    = 1.1;
% mu     = 1e-5;
% k=40;
% for samplingrate=[0.2,0.4,0.6,0.8,0.3,0.7,0.5]%0.2,0.4,0.6,0.8,0.3,0.7,0.5
%     switch (samplingrate)
%         case  0.2
%              dataRoad = ['Pomega/','P_Abilene_t_nonrandon_20%'];
%         case  0.4
%              dataRoad = ['Pomega/','P_Abilene_t_nonrandon_40%'];         
%         case  0.6
%              dataRoad = ['Pomega/','P_Abilene_t_nonrandon_60%'];  
%         case  0.8
%               dataRoad = ['Pomega/','P_Abilene_t_nonrandon_80%'];             
%         case  0.9
%               dataRoad = ['Pomega/','P_Abilene_t_nonrandon_90%']; 
%         case  0.7
%              dataRoad = ['Pomega/','P_Abilene_t_nonrandon2_70%']; 
%         case  0.3
%              dataRoad = ['Pomega/','P_Abilene_t_nonrandon2_30%']; 
%         case  0.5
%              dataRoad = ['Pomega/','P_Abilene_t_nonrandon3_50%']; 
%              
%      end
% load(dataRoad); 
% disp(['samplingrate=' num2str(samplingrate)]);
%  for  noise_sigma=[0]  %0,0.1,0.2,0.4 1ȡ0 %2ȡ-3 %5,10,20ȡ-4%1,2,5
%        disp(['noise_sigma=' num2str(noise_sigma)]);
%   switch  noise_sigma  %noise_X0=X0+noise_sigma*randn(dim);
%          case 0
%              lambd=6;
%              dataRoad = ['noise_X0/','noise_Abilene_0'];
%          case 1
%              lambd=4; 
%              dataRoad = ['noise_X0/','noise_Abilene_1'];
%          case 2
%              lambd=4;   
%              dataRoad = ['noise_X0/','noise_Abilene_2'];
%          case 5
%              lambd=4; 
%              dataRoad = ['noise_X0/','noise_Abilene_5'];
%          case 10
%               lambd=4;
%               dataRoad = ['noise_X0/','noise_Abilene_10'];
%          case 20
%               lambd=4;
%               dataRoad = ['noise_X0/','noise_Abilene_20'];     
%               
%   end
% load(dataRoad);
% lambda=10^lambd;
% transformation='fft';
% [X,MAE,RMSE] =LRTC_THT3(X0,noise_X0,lambda,k,rho,mu,Pomega,transformation);  
% disp(['MAE=' num2str(MAE)]);
% disp(['RMSE=' num2str(RMSE)]);
%   end
% end
