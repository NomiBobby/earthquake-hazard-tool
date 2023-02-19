clc
clear
tic
mainfolder = 'C:\Users\Stardust\OneDrive - Georgia Institute of Technology\Earthquake Project\ConditionalModels\NGAWest2\2496 GM data\2649 GM data';
cd(mainfolder);
%% get the folder name (RSN)
files = dir;
dirFlags = [files.isdir];
subFolders = files(dirFlags); % returns a struct of [n x 1], where struct(name, parent, ....)
numRSN = size(subFolders, 1) - 2; % ".", ".."
RSN = zeros(numRSN, 1);
for i = 1 : numRSN
    RSN(i,1) = str2num(subFolders(i+2).name);
end
%% read in xlxs file as cell matrix

cd 'C:\Users\Stardust\OneDrive - Georgia Institute of Technology\Course\CEE 6445 Earthquake Engineering\II Earthquakes and seismic design concepts'
flatfilename = "Updated_NGA_West2_Flatfile_RotD50_d050_public_version.xlsx";
[numbers, strings, raw] = xlsread(flatfilename);
disp('Flat File Processed');
cd(mainfolder);

%% create table 1: fetch corresponding RSN data
table1 = cell(1 + numRSN, 274);
table1(1,:) = raw(1,:);
for i = 1 : numRSN
    table1(i+1,:) = raw(RSN(i)+1,:);
end
% create table 2: store parameters
table2 = cell(1 + numRSN, 16);
table2(1, :)= {'PGA','PGV','CAV5','CAVstd','D5','D95','durav','D75','D575','AIav','SIR','Tm','Tp','CAVstdjm','CAV','CAVdp'};
%% read each folder
for i = 1776%1:numRSN %*****************************************
    fprintf('No. %d folder\r\n', i);
    folderpath = subFolders(i+2).name;
    cd(folderpath);
    List_of_GM=ls('*.AT2*');% return a [n x 1] char array
    [N_GM,~]=size(List_of_GM);
    f_list_name = strjoin({'GM-List','.txt'},'');
    % dlmwrite(f_list_name,List_of_GM,'')% write the string in to GM-list.txt file
    % FolderName = 'Reshape Data';%this folder will be used to save time histories with a format change if needed
    % mkdir(pwd, FolderName);
    scalf= ones(1,N_GM);%[2.2,1,1.5,1.25,1,1,3.0,1,1.30,1,2.0,1.5];
    dellines=zeros(1,N_GM);%[0,0,500,0,0,0,1800,0,0,4000,0,0];%Number of lines to be deleted for each GM
    %%
    %ignore this, it is used for flac
    %nyy=21;
    % GMdir='D:\FlacRun\GMotions\12mod\';
    % Outfigdir='D:\FlacRun\Case32\';
    %GMdir='C:\Users\Macedo\Desktop\Building Disp Project\Parametric\GMotions\';
    %Outfigdir='C:\Users\Macedo\Desktop\Building Disp Project\Parametric\Analysis01\Test\change of steps 4_5\Results_16m_5firstNoLiq\';
    %%
    for i_GM=1:N_GM
        pos = i_GM;
        posext = find(List_of_GM(pos,:)=='.');
        f_name_d = List_of_GM(pos,1:posext-1);
        f_name_out=strjoin({f_name_d,'R.txt'},'');
        f_name_output=strjoin({';',f_name_d,'R'},''); % what is this?
        %a=importdata(List_of_GM(pos,:));
        delimiterIn = ' ';
        headerlinesIn = 4;
        a=importdata(List_of_GM(pos,:),delimiterIn,headerlinesIn);%---------------------------------IMPORT DATA-------------

        %convert cell a into integers vector

        Data_ACC=a.data;
        Data_ACC=Data_ACC .* scalf(pos);%-----------
        name=char(List_of_GM(pos,:));
        [npt,dt]=dt_npt2019(name);
        %%%%
        del=dellines(pos);
        fadjust=1;
        if dt<0.02
            %fadjust=0.02/dt;
            fadjust=1;%this changes only when we want to change the time step, not the case for this project
            nptr(pos)=npt/fadjust;
            dtr(pos)=dt*fadjust;
        else
            nptr(pos)=npt;
            dtr(pos)=dt;

        end
        %%%
        %dt=0.010;
        %% previous version used for the buildingds project ignore it
        % [ar,V,TGMP(pos,1),TGMP(pos,2),TGMP(pos,3),TGMP(pos,4),TGMP(pos,5),TGMP(pos,6),TGMP(pos,7),TGMP(pos,8),TGMP(pos,9),TGMP(pos,10),TGMP(pos,11),TGMP(pos,12),TGMP(pos,13)] = GM_Parameters_Reshape( Data_ACC, dtr(pos),del,fadjust);  
        % TGMP(pos,14)=length(ar);%nptr(pos);
        % TGMP(pos,15)=dtr(pos);
        % nptr(pos)=TGMP(pos,14);
        % TGMP(pos,16)=nptr(pos)*dtr(pos);
        %%
        [TGMP(pos,1),TGMP(pos,2),TGMP(pos,3),TGMP(pos,4),TGMP(pos,5),TGMP(pos,6),TGMP(pos,7),TGMP(pos,8),TGMP(pos,9),TGMP(pos,10),TGMP(pos,11),TGMP(pos,12),TGMP(pos,13),TGMP(pos,14),TGMP(pos,15),ListT,RS2] = GM_Parameters2019( Data_ACC, dtr(pos),del,fadjust);  %del = 0 --- no deleted lines; dtr(pos) is actually dt
        %TGMPr1(pos,1:1+110)=RS';
        TGMP(pos,16:16+104)=RS2';
        %RS2=RS2';%JUST FOR PLOTTING IF NEEDED (DEACTIVATED NOW)
        %TGMP(pos,121)=RSN(ii);
        %TGMP(pos,122)=phi;
        %TGMP(pos,123)=npts1-npts2;
        %TGMP(pos,124)=dt1-dt2;
        TGMP(pos,121)=npt;
        TGMP(pos,122)=dt;

        % current_directory=pwd;
        % mainfolder=strjoin('summary');
        % mkdir(pwd, mainfolder);
        % path = [current_directory '\' mainfolder];
        % cd(path);
        headers1={'PGA','PGV','CAV5','CAVstd','D5','D95','durav','D75','D575','AIav','SIR','Tm','Tp','CAVstdjm','CAV','T0.010S','T0.020S','T0.022S','T0.025S','T0.029S','T0.030S','T0.032S','T0.035S','T0.036S','T0.040S','T0.042S','T0.044S','T0.045S','T0.046S','T0.048S','T0.050S','T0.055S','T0.060S','T0.065S','T0.067S','T0.070S','T0.075S','T0.080S','T0.085S','T0.090S','T0.095S','T0.100S','T0.110S','T0.120S','T0.130S','T0.133S','T0.140S','T0.150S','T0.160S','T0.170S','T0.180S','T0.190S','T0.200S','T0.220S','T0.240S','T0.250S','T0.260S','T0.280S','T0.290S','T0.300S','T0.320S','T0.340S','T0.350S','T0.360S','T0.380S','T0.400S','T0.420S','T0.440S','T0.450S','T0.460S','T0.480S','T0.500S','T0.550S','T0.600S','T0.650S','T0.667S','T0.700S','T0.750S','T0.800S','T0.850S','T0.900S','T0.950S','T1.000S','T1.100S','T1.200S','T1.300S','T1.400S','T1.500S','T1.600S','T1.700S','T1.800S','T1.900S','T2.000S','T2.200S','T2.400S','T2.500S','T2.600S','T2.800S','T3.000S','T3.200S','T3.400S','T3.500S','T3.600S','T3.800S','T4.000S','T4.200S','T4.400S','T4.600S','T4.800S','T5.000S','T5.500S','T6.000S','T6.500S','T7.000S','T7.500S','T8.000S','T8.500S','T9.000S','T9.500S','T10.000S','Npts','Dt'};
        %csvwrite_with_headers('GMParametersjm2.csv',TGMP,headers1)
        %cd ..;


        %activate the code below only to write the acceleration and velocity time
        %histories to a different file
        %%
        % fi = fopen([pwd '\' FolderName '\' f_name_out], 'w'); 
        % 
        % fprintf(fi,'%s\n',char(f_name_output)); 
        % 
        % nd=length(ar);
        % gm_properties=strjoin({num2str(nd),', ',num2str(dtr(pos))},'');
        % 
        % fprintf(fi,'%s\n',char(gm_properties)); 
        % 
        % format long
        % for i=1:nd
        % fprintf(fi,'%s\n',char(num2str(ar(i)))); 
        % end
        % fclose(fi);
        % 
        % nd=length(V);
        % gm_properties=strjoin({num2str(nd),', ',num2str(dtr(pos))},'');
        % f_name_out=strjoin({f_name_d,'RV.txt'},'');
        % fid = fopen([pwd '\' FolderName '\' f_name_out], 'w'); 
        % fprintf(fid,'%s\n',char(f_name_output));
        % fprintf(fid,'%s\n',char(gm_properties)); 
        % format long
        % for i=1:length(V)
        % fprintf(fid,'%s\n',char(num2str(V(i)))); 
        % end
        % fclose(fid);

        %%

    end
    table3 = cell(1, 15);
    for j = 1 : 15
        table3(1,j)= {(sqrt(TGMP(1, j)* TGMP(2, j)))};
    end
    table2(i+1,1:15) = table3(1,:);
	
%%------------add CAVdp--------------
	% ***CAVstd Check***
	if max(TGMP(1, 4), TGMP(2, 4)) > 0.16 % TGMP(1, 4) is the CADstdjm for the first Horizontal Component, TGMP(2, 4) is for the second Hrozontal Comnponent
		table2(i+1, 16) = table2(i+1,14); % if the check is satisfied, CAVdp = CAVstdjm
	else
		table2(i+1, 16) = {num2str(0)}; % if both are less than 0.16, set CAVdp to 0
	end
    cd(mainfolder);
end
%%
output = [table1,table2];
xlswrite('FinalTable.xlsx',output,'Sheet1','A1');
time = toc;
fprintf('Time elapsed: %f\n', time);
%xlswrite('Summary_Table2019.xlsx',TGMP,'Sheet1','B2')
%TGMP=xlsread('Summary_Table.xlsx','Sheet1','B2:Q21');

