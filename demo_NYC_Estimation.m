addpath(genpath('high-order tensor-SVD Toolbox'));
addpath(genpath('tool'));
addpath(genpath('Pomega'));
addpath(genpath('data'));
dataRoad = ['data/','nyctaxiyellow202160'];
load(dataRoad);
X0=nyctaxiyellow202160;
dim=size(X0);
noise_sigma = 1;
seed = 1000;
rng(seed);
noise_X0 = X0 + noise_sigma * randn(dim);
k = 20;
lambd = -2;
lambda = 10^lambd;
for samplingpattern=[1,2,3]
        switch (samplingpattern)
            case 1
                dataRoad = ['Pomega/','P_nyctaxiyellow202160_t_nonrandon1_30%'];         
            case 2          
                dataRoad = ['Pomega/','P_nyctaxiyellow202160_t_nonrandon2_30%'];  
            case 3            
                dataRoad = ['Pomega/','P_nyctaxiyellow202160_t_nonrandon3_30%'];                        
        end
        load(dataRoad); 
        Y=noise_X0;%%noise_set:Y=X0+E;
        [X] =LRTC_TIDT(Y,Pomega,lambda,k);
        Pomegac=1-Pomega;
        missingrate=sum(Pomegac,'all')/(dim(1)*dim(2)*dim(3));
        MAE=(1/(prod(dim)*missingrate))*sum(abs(Pomegac.*X0-Pomegac.*X),'all');
        RMSE=1/sqrt(prod(dim)*missingrate)*sqrt(sum((Pomegac.*X0-Pomegac.*X).^2,'all'));
        fprintf('MAE: %.4f\n', MAE);
        fprintf('RMSE: %.4f\n', RMSE);
end