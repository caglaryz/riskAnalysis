%% Configurable‑RiskCase MCDM   --------------------------------------
clc; clear;

%% 1)   Crisp Decision Matrix 

% Adjust X, isCost, alts and crits as you want specific to your case

% 	C1  C2 C3  C4   C5 C6  C7
X = [ 0.75  4  5   30   60  8  5 ;      % A  Alternative 1
      0.60  3  7   35   50  6  7 ;      % B  Alternative 2
      0.45  2  9   90  110  4  8 ];     % C  Alternative 3

isCost = [1 1 0 1 1 1 0];                % 1 = cost, 0 = benefit
alts   = {'A','B','C'};
crits  = {'C1_Name' 'C2_Name' 'C3_Name' 'C4_Name' 'C5_Name' 'C6_Name' 'C7_Name'};
n      = numel(isCost);

%% 2)   AHP weights (crisp)

% Matrix A is created using expert judgements in 1-9 Saaty Scale

% Adjust A as you want specific to your case, it must be an nxn matrix.

A = [1 2 2 2 3 4 4;
     .5 1 2 1 2 2 2;
     .5 .5 1 1 2 2 2;
     .5 1 1 1 2 2 2;
     1/3 .5 .5 .5 1 1 1;
     .25 .5 .5 .5 1 1 1;
     .25 .5 .5 .5 1 1 1];
     
[wA_col,CR] = ahp_eig(A);    wA = wA_col';
fprintf('AHP  weights : '); disp(wA);  fprintf('CR = %.3f\n',CR);

%% 3)   FAHP weights (Buckley)
% build TFN pair‑wise matrices
saaty   = 1:9;
TFN_tbl = [1 1 1;1 2 3;2 3 4;3 4 5;4 5 6;5 6 7;6 7 8;7 8 9;8 9 9];
L=zeros(n);
M = L;
U = M;
for i=1:n
 for j=1:n
   v=A(i,j); invv=1/v;
   if     v==1, t=[1 1 1];
   elseif v>1 , t=TFN_tbl(saaty==v,:);
   else        t=1./fliplr(TFN_tbl(saaty==round(invv),:));
   end
   L(i,j)=t(1); M(i,j)=t(2); U(i,j)=t(3);
 end
end
wF = fahp_buckley(L,M,U);    fprintf('FAHP weights : '); disp(wF);

%% 4)   Select global weight vector
w = wF;      % <- can replace w/ wA (AHP) if want to change crit. weight source

%% 5)   Scores by MCDM methods
scoreAHP  = saw(X,wA,isCost);
scoreFAHP = saw(X,w ,isCost);
Ci        = topsis(X,w,isCost);
CiF       = ftopsis(X,w,isCost);
[gamma,gradeG]= gra(X,w,isCost);
Qi        = vikor(X,w,isCost,0.5);
Ki        = aras(X,w,isCost);

Results = table(alts',scoreAHP,scoreFAHP,Ci,CiF,gradeG,Qi,Ki, ...
   'VariableNames',{'Alt' 'AHP' 'FAHP' 'TOPSIS' 'FTOPSIS' 'GRA' 'VIKOR' 'ARAS'});
disp(Results)
