function [PGA, PGV, CAV5, CAVstd, D5, D95,D5_95,D75,D5_75, Ia, SIR,Tm,Tp,CAVstdjm,CAV,ListT,RS2 ] = GM_Parameters2019( a, dt,dellines,fadjust) % fadjust is assumed to be 1
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
a(isnan(a))=0; % a is the acceleration series
[nf, nc]=size(a);
%%%
arin=reshape(a',nf*nc,1); % reshape a into a nf*nc by 1 vector
totsize=length(arin); % get the total number of acceleration data
arin2=zeros(totsize-dellines,1);
for iii=1:1:totsize-dellines;
	arin2(iii)=arin(iii+dellines); % delete lines in ain to get arin2
end
totsizef= fix((totsize-dellines)/fadjust);%+1; fix() round towards zero
ar=zeros(totsizef,1);
kkk=1;
for jjj=1:1:totsizef;
    ar(jjj)=arin2(kkk);
    kkk=kkk+fadjust; % what is fadjust -- scale factor which is 1 in this case
end  
%%%
a=ar;
Nd=length(a); % number of dots
t=(0:Nd-1)*dt; % duration
v=cumtrapz(t,a); %cumulative velocity
CAV5=0;
CAVstd=0;
CAV=0;
ThresholdKM=0.005;
ThresholdCB=0.025;
%Nd=length(a);
aCAVstd=abs(a);
aCAV5=abs(a);
aCAV=abs(a);
aCAV5(find(aCAV5<ThresholdKM))=0;
aCAVstd(find(aCAVstd<ThresholdCB))=0;

%----------------------------
aCAV51=aCAV5(1); % first element of cav
aCAVstd1=aCAVstd(1);
aCAV1=aCAV(1);
%----------------------------

grav=9.81;
suma=zeros(Nd,1);
%%%
suma_ai=zeros(Nd,1);
%%%
ratios=zeros(Nd,1);
suma(1) = a(1)^2; % get the cumulative value of acceleration squared
suma_ai(1)=suma(1)*0.5*pi*grav*dt;

    for f=2:Nd
		suma(f) = suma(f-1) + a(f)^2;
        suma_ai(f)=suma(f)*0.5*pi*grav*dt; % calculatee arias intensity
    end 
    for f=1:Nd
		ratios(f) = suma(f)/suma(Nd);
    end 
    for f=2:Nd
	
		% get acc at this step
        aCAV52=aCAV5(f); % acceleration at time f
        aCAVstd2=aCAVstd(f);
        aCAV2=aCAV(f);
		
		% calculate mean value
        aCAV5m=(aCAV51+aCAV52)/2;
        aCAVstdm=(aCAVstd1+aCAVstd2)/2;
        aCAVm=(aCAV1+aCAV2)/2;
		
		% calculate CAV
        CAV5=CAV5+aCAV5m*dt;
        CAVstd=CAVstd+aCAVstdm*dt;
        CAV=CAV+aCAVm*dt;
		
		% switch to next step
        aCAV51=aCAV52;
        aCAVstd1=aCAVstd2;
        aCAV1=aCAV2;
    end
%%%%%%%%%%%%%%%%%    
ninter=round(Nd*dt/1); % round duration to integer
ni=ninter;
extra_time=Nd*dt-ni;
CAVstdjm=0;

% standardized version of CAV; function 3 in campbel paper
for iii=1:1:ninter
    timestart=iii-1;
    timeend=iii;
    lista=find(t>=timestart);
    listb=find(t<timeend);
    idstart=lista(1);
    if iii<ninter
    idend=listb(end)+1;
    else
    idend=listb(end);    
    end
    atemp=abs(a(idstart:idend));
    PGAtemp=max(abs(atemp)); %find PGA in certain period
    
    if PGAtemp>=0.025
       aCAVstd1jm=atemp(1);
        for jjj=2:length(atemp)
            aCAVstd2jm=atemp(jjj);
            aCAVstdmjm=(aCAVstd1jm+aCAVstd2jm)/2;
            CAVstdjm=CAVstdjm+aCAVstdmjm*dt;
            aCAVstd1jm=aCAVstd2jm;
        end 
    end
    
end

if extra_time>0
    listae=find(t<=ninter);
    idstarte=listae(end);
    atemp=a(idstarte:end);
    PGAtemp=max(abs(atemp));
    
    if PGAtemp>=0.025
       aCAVstd1jm=atemp(1);
        for jjj=2:length(atemp)
            aCAVstd2jm=atemp(jjj);
            aCAVstdmjm=(aCAVstd1jm+aCAVstd2jm)/2;
            CAVstdjm=CAVstdjm+aCAVstdmjm*dt;
            aCAVstd1jm=aCAVstd2jm;
        end 
    end
end
%%%%%%%%%%%%%%%%%    
    PGV=981*max(abs(v));
    PGA=max(abs(a));
    D5Pos=find(ratios<=0.05,1,'last');
    D5=D5Pos*dt;
    D95Pos=find(ratios<=0.95,1,'last');
    D95=D95Pos*dt;
    D5_95=D95-D5;
    D75Pos=find(ratios<=0.75,1,'last');
    D75=D75Pos*dt;
    D5_75=D75-D5;
    Ia=0.5*pi*grav*suma(Nd)*dt;
    SIR=Ia/D5_75;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%this function is added from Brian Carlton for Tm
% FOURIER AMPLITUDE SPECTRUM
[fa,U]=FAS(dt,a);

% MEAN PERIOD (Rathje et al, 2004)
fi = fa(fa>0.25 & fa<20);
Ci = U(fa>0.25 & fa<20);
Tm = ((Ci(:)'.^2)*(1./fi(:)))/(Ci(:)'*Ci(:));

%changed below before it was returning only Tp
%     [Tp,ListT,RS] = Predominant_Period2( a, dt);
     [Sa,Sv,Sd,ListT]=rs(a,dt,0.05,0.10,(1/dt)/2);
     RS2=Sa;
     Pos_Tp=find(RS2==max(RS2));
     Tp=ListT(Pos_Tp);
end

function[f,U]=FAS(dt,acc)
Ny = (1/dt)/2; %Nyquist frequency (highest frequency)
L  = length(acc); %number of points in acc
NFFT = 2^nextpow2(L); % Next power of 2 from length of acc
df = 1/(NFFT*dt); %frequency spacing

U = abs(fft(acc,NFFT))*dt; %Fourier amplitudes 

U = U(2:Ny/df+1); %single sided FAS
f = linspace(df,Ny,Ny/df)'; %[small, large, number] frequencies
end


function [Sa,Sv,Sd,T]=rs(acc,dt,damp,LUF,HUF)
Acccms=acc*981;%convert from g to cm/s^2
if dt > .005;
     beta = .25;
else beta = 1/6;
end

gamma= 0.5; %parameters for Newmark's method
%average acceleration method gamma = 0.5, beta = .25, linear acceleration 
%method gamma = 0.5, beta = 1/6.  Average acceleration method is
%unconditionally stable, but less accurate.  Linear acceleration method is
%stable for dt/T < 0.551 but more accurate (Chopra, 2011)

Tlong = LUF^-1; %lowest usable frequency = 1/max period
Tshort = HUF^-1; %highest usable frequency = 1/min period
%T = 10.^linspace(log10(Tshort),log10(Tlong),150); %150 points
T=[0.010,0.020,0.022,0.025,0.029,0.030,0.032,0.035,0.036,0.040,0.042,0.044,0.045,0.046,0.048,0.050,0.055,0.060,0.065,0.067,0.070,0.075,0.080,0.085,0.090,0.095,0.100,0.110,0.120,0.130,0.133,0.140,0.150,0.160,0.170,0.180,0.190,0.200,0.220,0.240,0.250,0.260,0.280,0.290,0.300,0.320,0.340,0.350,0.360,0.380,0.400,0.420,0.440,0.450,0.460,0.480,0.500,0.550,0.600,0.650,0.667,0.700,0.750,0.800,0.850,0.900,0.950,1.000,1.100,1.200,1.300,1.400,1.500,1.600,1.700,1.800,1.900,2.000,2.200,2.400,2.500,2.600,2.800,3.000,3.200,3.400,3.500,3.600,3.800,4.000,4.200,4.400,4.600,4.800,5.000,5.500,6.000,6.500,7.000,7.500,8.000,8.500,9.000,9.500,10.000];
umax = zeros(1,length(T));
for j=1:length(T)
    wn = 2*pi/T(j);
    m = 1;%then c and k are in terms of damping and natural period
    k = wn^2;
    c = 2*wn*damp;
    khat = k+gamma/beta/dt*c+m/beta/dt^2;
    a = m/beta/dt+gamma*c/beta;
    b = 1/2/beta*m+dt*(gamma/2/beta-1)*c;
    u = zeros(length(Acccms),1); %oscillator starting from rest
    udot = zeros(length(Acccms),1);%pre-allocate for speed
    uddot = zeros(length(Acccms),1);
    du = zeros(length(Acccms)-1,1);
    dudot = zeros(length(Acccms)-1,1);
    duddot = zeros(length(Acccms)-1,1);
    for i = 1:length(Acccms)-1
       du(i) = (Acccms(i+1)-Acccms(i)+a*udot(i)+b*uddot(i))/khat;
       u(i+1) = u(i)+du(i);
       dudot(i) = gamma*du(i)/beta/dt-gamma*udot(i)/beta+dt*(1-gamma/2/beta)*uddot(i);
       udot(i+1) = udot(i)+dudot(i);
       duddot(i) = du(i)/beta/dt^2-udot(i)/beta/dt-uddot(i)/2/beta;
       uddot(i+1) = uddot(i)+duddot(i);
    end
    umax(j) = max(abs(u));%max displacement for every period T (cm) 
end

Sd = umax; %displacement in cm
Sv=2*pi*Sd./T;%pseudo velocity in cm/s
Sa=2*pi*Sv./T/981;%pseudo acceleration in g

end