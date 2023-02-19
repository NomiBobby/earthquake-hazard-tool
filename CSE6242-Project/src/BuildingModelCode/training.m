clc
clear
cd '/Users/stardust/OneDrive - Georgia Institute of Technology/Earthquake Project/ConditionalModels/NGAWest2/2496 GM data/2649 GM data'
filename1 = 'FinalTable.xlsx';

%% Import Parameters
NumberOfGroundMotion = 2496;
NumberOfSaPeriods = 111;
delimiterIn = ' ';
headerlinesIn = 1;
A = importdata(filename1,delimiterIn,headerlinesIn);
A1=A.data;
disp('---Finished Input---')
CAV = log(A1(:, 289));
CAV5 = log(A1(:, 277));
CAVstd = log(A1(:, 278));
CAVstdjm = log(A1(:, 288));
CAVdp = log(A1(:, 290));
PGA = log(A1(:, 275));
PGV = log(A1(:, 276));
Magnitude = A1(:, 10);
Rup = log(A1(:, 48));
Vs30 = log(A1(:, 81));
Sa = log(A1(:, 135:245));
T = [0.010,	0.020,	0.022,	0.025,	0.029,	0.030,	0.032,	0.035,	0.036,	0.040,	0.042,	0.044,	0.045,	0.046,	0.048,	0.050,	0.055,	0.060,	0.065,	0.067,	0.070,	0.075,	0.080,	0.085,	0.090,	0.095,	0.100,	0.110,	0.120,	0.130,	0.133,	0.140,	0.150,	0.160,	0.170,	0.180,	0.190,	0.200,	0.220,	0.240,	0.250,	0.260,	0.280,	0.290,	0.300,	0.320,	0.340,	0.350,	0.360,	0.380,	0.400,	0.420,	0.440,	0.450,	0.460,	0.480,	0.500,	0.550,	0.600,	0.650,	0.667,	0.700,	0.750,	0.800,	0.850,	0.900,	0.950,	1.000,	1.100,	1.200,	1.300,	1.400,	1.500,	1.600,	1.700,	1.800,	1.900,	2.000,	2.200,	2.400,	2.500,	2.600,	2.800,	3.000,	3.200,	3.400,	3.500,	3.600,	3.800,	4.000,	4.200,	4.400,	4.600,	4.800,	5.000,	5.500,	6.000,	6.500,	7.000,	7.500,	8.000,	8.500,	9.000,	9.500,	10.000,	11.000,	12.000,	13.000,	14.000,	15.000,	20.000];

%% Multi-Linear Regression
R2=zeros(NumberOfSaPeriods,1);
RMSE=zeros(NumberOfSaPeriods,1);% square root of MSE
disp('---Regression Started---');
for i = 1:1:NumberOfSaPeriods
    Sa_T_i = Sa(:, i);
	IM = [PGA, Magnitude, Rup, Vs30, Sa_T_i];
    X = [ones(NumberOfGroundMotion, 1), IM];
	Y = CAV;
	%b is the coefficients, bint is matrix of 95% confidentce intervals, r is a vector of residuals, rint is a matrix of intervals to diagnose outliers, stats returns R2+Fstatistic+p-value + estimation of error variance
	[b,bint,r,rint,stats] = regress(Y,X);
	R2(i,1)=stats(1);
	RMSE(i,1)=sqrt(stats(4));
end

%% plot std and R2
figure
subplot(1,2,1);
plot(T, R2);
title("R2");
ylabel("R2");
xlabel("Period (s)");
subplot(1,2,2);
plot(T, RMSE);
ylabel("RMSE");
xlabel("Period (s)");
title("RMSE");

%% Plot CAVs & PGA against CAV
figure
subplot(2, 3, 1);
scatter(980*exp(CAV), 980*exp(CAV5), 5);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('CAV, cm/s');
ylabel('CAV5, cm/s');
title('CAV5 - CAV');
axis([10^-1 10^4 10^-1 10^4]);

subplot(2, 3, 2);
scatter(980*exp(CAV), 980*exp(CAVstd), 5);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('CAV, cm/s');
ylabel('CAVstd, cm/s');
title('CAVstd - CAV');
axis([10^-1 10^4 10^-1 10^4]);

subplot(2, 3, 3);
scatter(980*exp(CAV), 980*exp(CAVstdjm), 5)
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('CAV, cm/s');
ylabel('CAVstdjm, cm/s');
title('CAVstdjm - CAV');
axis([10^-1 10^4 10^-1 10^4]);

subplot(2, 3, 4);
scatter(980*exp(CAV), 980*exp(CAVdp), 5);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
xlabel('CAV, cm/s');
ylabel('CAVdp, cm/s');
title('CAVdp - CAV');
axis([10^-1 10^4 10^-1 10^4]);

subplot(2, 3, 5);
scatter(980*exp(CAV), 980*exp(PGA), 5);
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');
title("PGA - CAV");
ylabel("PGA, cm/s^2");
xlabel("CAV, cm/s");

%% Check Imput Parameters
% Plot Distance
figure
subplot(2,4,1)
histogram(exp(Rup));
title("Distance");
xlabel("Rup (km)");
% Plot Vs30
subplot(2,4,2)
histogram(exp(Vs30));
title("Vs30");
xlabel("Vs30 (m/s)");
% Plot CAV
subplot(2,4,3)
histogram(exp(CAV));
title("CAV");
xlabel("CAV (g/s)");
% Plot CAV5
subplot(2,4,4)
histogram(exp(CAV5));
title("CAV5");
xlabel("CAV5 (g/s)");
% Plot CAVstd
subplot(2,4,5)
histogram(exp(CAVstd));
title("CAVstd");
xlabel("CAVstd (g/s)");
% Plot CAVstdjm
subplot(2,4,6)
histogram(exp(CAVstdjm));
title("CAVstdjm");
xlabel("CAVstdjm (g/s)");
% Plot CAVdp
subplot(2,4,7)
histogram(exp(CAVdp));
title("CAVdp");
xlabel("CAVdp (g/s)");

%% Find the best period for SA(T)
[M, I] = max(R2);
Optimum_Period = T(I);
I= 27;%-----1.0 s
Sa_T_i = Sa(:, I); % I = 27
IM = [PGA, Magnitude, Rup, Vs30, Sa_T_i];
X = [ones(NumberOfGroundMotion, 1), IM];
Y = CAV;
% b is the coefficients, bint is matrix of 95% confidentce intervals, 
% r is a vector of residuals, rint is a matrix of intervals to diagnose 
% outliers, stats returns R2+Fstatistic+p-value + estimation of error variance
[b,bint,r,rint,stats] = regress(Y,X);
R2 = stats(1);
RMSE = sqrt(stats(4));
residual = r;
%%  plot residuals against Magnitude
binbar(Magnitude, residual, 10, 'Magnitude', 'Mw');
binbar(exp(Rup), residual, 10, 'Rup', 'km');
binbar(exp(Vs30), residual, 10, 'Vs30', 'm/s');
binbar(exp(PGA), residual, 10, 'PGA', 'g');
binbar(exp(PGV), residual, 10, 'PGV', 'm/s');

binbar(exp(Sa_T_i), residual, 10, 'Sa', 'g');