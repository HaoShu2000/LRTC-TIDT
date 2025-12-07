function [X] = LRTC_TIDT(Y,Pomega,lambda,k)

dim =size(Y);
C_dim=[dim(1),k,dim(2),dim(3)];

rho    = 1.1;
mu     = 1e-6;
tol        = 1e-3; 
max_iter   = 400;
max_mu     = 1e10;
transformation='fft';

%% variables initialization
X            = Pomega.*(Y);
Z            = zeros(C_dim); 
N            = zeros(C_dim); 
%% main loop
iter = 0;
while iter<max_iter
    iter = iter + 1;  
    %% Update Z
    switch transformation
         case 'fft'
              Z = prox_htnn_F(TIDT(X,k)-N/mu,1/mu);
         case 'dct'
              Z = prox_htnn_C(TIDT(X,k)-N/mu,1/mu);        
         case 'ddt'
            for i = 3:4
                  [VVV,~]=eig(double(tenmat(TIDT(X,k)-N/mu,i))*double(tenmat(TIDT(X,k)-N/mu,i))');
                  transform_matrice{i-2} =VVV'; 
             end
     [Z,~] = prox_htnn_U(transform_matrice,TIDT(X,k)-N/mu,1/mu);
    end
    %% Updata X -- proximal operator of TNN
    X=(TIDT_inv(mu*Z+N)+lambda*Pomega.*Y)./(lambda*Pomega.*ones(dim)+mu*ones(dim));
    
    %% Stop criterion
    dY   =  Z-TIDT(X,k);    
    chg  = max(abs(dY(:)));
    if chg < tol
         break;
    end    
    %% Update detail display
        if iter == 1 || mod(iter, 30) == 0
%             err = norm(dY(:),'fro');
%             err = norm(dY(:),'fro');
            disp(['iter= ' num2str(iter) ', mu=' num2str(mu) ...
                   ', chg=' num2str(chg)]); 
        end
     
    %% Update mulipliers
    N = N+mu*(Z-TIDT(X,k));
    mu = min(rho*mu,max_mu);
end
end
