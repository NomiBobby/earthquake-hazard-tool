clear all
clc 
[numeros,seisms]=xlsread('Seisms.xlsx','Sheet1','A1:A838');
%[mag,seisms2]=xlsread('Seismic_Events_Mexico.xlsx','Hoja1','B1:B32');
%[dt,seisms3]=xlsread('Seismic_Events_Mexico.xlsx','Hoja1','C1:C32');
%[npt,seisms4]=xlsread('Seismic_Events_Mexico.xlsx','Hoja1','D1:D32');
ncopies=1;
    nstepsa=zeros(size(seisms,1),1);
    dtacca=zeros(size(seisms,1),1);
    maga=zeros(size(seisms,1),1);
    dist=zeros(size(seisms,1),1);


for ii=1:1:size(seisms,1);%40;
     ll=99;
 
     fid=fopen([char(seisms(ii))]);
     %[char(seisms(i)) num2str(ll) '.txt']
%fid=fopen('P0106E05.txt');
    
    if fid<0
        error('##### unable to open record file ####')
    end;
    
    skipline=16;
    nsteps=0;
    dtacc=0;
    for i=1:skipline+1
        tline = fgetl(fid);
        if i==2
        match1 = find(tline==' ');
        Late=str2num(tline(match1(14)+1:size(tline,2)));
        end
        if i==3
        match1 = find(tline==' ');
        Longe=str2num(tline(match1(13)+1:size(tline,2)));
        end
        if i==5
        match1 = find(tline==' ');
        mag=str2num(tline(match1(14)+1:size(tline,2)));
        end
        if i==7
        match1 = find(tline==' ');
        Lats=str2num(tline(match1(7)+1:size(tline,2)));
        end
        if i==8
        match1 = find(tline==' ');
        Lons=str2num(tline(match1(6)+1:size(tline,2)));
        end
        if i==11
        match1 = find(tline==' ');
        match2=find(tline=='H');
        sampfreq=str2num(tline(match1(2)+1:match2(2)-1));
        end
        if i==12
        match1 = find(tline==' ');
        dur=str2num(tline(match1(3)+1:size(tline,2)));
        end
        if i==14
        match1 = find(tline==' ');
        match2=find(tline=='(');
        match3=find(tline=='/');
        numscal=str2num(tline(match1(7)+1:match2(1)-1));
        denscal=str2num(tline(match3(1)+1:size(tline,2)));
        end
              
        
    end;
    
    
    %nsteps=str2num(tline(match1(1)+2:match4(1)));%THIS WAS ACTIVE
    %dtacc=str2num(tline(match1(6)+1:match3(2)-1));
    nsteps=dur*sampfreq;
    dtacc=1/sampfreq;
    nstepsa(ii)=nsteps;
    dtacca(ii)=dtacc;
    maga(ii)=mag;
    dist(ii)=111*sqrt((Longe-Lons)^2+(Late-Lats)^2);
    %nsteps=str2num(tline(1:match1(1)));
    %dtacc=str2num(tline(match1(1)+1:match2-1));
    if nsteps<=0
        disp('ERROR: not able to find DT or NPTS');
        return;
    end;
    if dtacc<=0
        disp('ERROR: not able to find DT or NPTS');
        return;
    end;
        frewind(fid);
    icount=0;
    idt=0;
   acc=char(zeros(nsteps,8));
   acc1=zeros(nsteps,1);
   %acc2=char(zeros(nsteps,13));
    %acc=zeros(nsteps,1,'double');
    while feof(fid) == 0
        tline = fgetl(fid);
        icount=icount+1;
        if icount > skipline+1
            
            if tline(1)~=' '
            tline=[' '  tline];
            end
            % do the search in the string
            aa=isspace(tline);
            daa=zeros(length(aa)-1,1);
            for i=1:(length(aa)-1)
                daa(i)=aa(i+1)-aa(i);
            end
            daa=[daa ; 1];
            % to sting arxizei sto -1 kai teleiwnei sto 1
            ss=find(daa==-1);
            %if tline(1)=='-'
            %    ss=[1 ; ss];
            %end
            ee=find(daa==1);
            
            for i=1:length(ss)
                idt=idt+1;
                jj=0;
                while jj < ee(i)-ss(i);
                    jj=jj+1;
                acc(idt,jj)= tline(ss(i)+jj);
                end
                %acc(idt)=str2double(tline(ss(i):ee(i)));
            end;
            
        end;
    end;
 fclose(fid);   
     for hh=1:1:nsteps;
       acc1(hh)=str2double(acc(hh,:))*numscal/denscal*1/981;
       bb=num2str(acc1(hh),'%6.7E');
      % for nn=1:1:13;
       %    acc2(hh,nn)=bb(nn);
       %end
    end
  
    for gg=1:1:nsteps;
        if acc1(gg)==0;
            acc1(gg)=0.00000000000001;
        end
    end

  
arg = acc1';%[-0.0127 -0.1711 -0.0327 -0.0015 0.0035 -0.0186]
%d=zeros(2,length(arg));
d=zeros(2,1);
out2=char(zeros(length(arg),13));
  for i=1:length(arg)
sgn(i) = sign(arg(i));
expnt(i) = fix(log10(abs(arg(i))));
mant(i) = sgn(i) * 10^(log10(abs(arg(i)))-expnt(i));
if abs(mant(i)) < 1
    mant(i) = mant(i);
    expnt(i) = expnt(i);%-2;
end
if abs(mant(i)) >= 1
    mant(i) = mant(i)/10;
    expnt(i) = expnt(i)+1;%-2;
end


%d(i)=[mant;expnt];
%out(i)=sprintf('%fe%+04d\n',d)
d(1,1)=mant(i);
d(2,1)=expnt(i);
out=sprintf('%fe%+03d\n',d);
for kk=1:1:13
    out2(i,kk)=out(kk);
end

end    
    
    
    
    
    
for jj=1:1:ncopies;
%seismo='P0106E05';
ll=ll+1;
dd=char(seisms(ii));
if size(dd,2)==20
texto=fopen([char(dd(1)) char(dd(2)) char(dd(3)) char(dd(4)) char(dd(5)) char(dd(6)) char(dd(7)) char(dd(8)) char(dd(9)) char(dd(10)) char(dd(18)) char(dd(19)) char(dd(20)) '.txt'],'w');
else
texto=fopen([char(dd(1)) char(dd(2)) char(dd(3)) char(dd(4)) char(dd(5)) char(dd(6)) char(dd(7)) char(dd(8)) char(dd(9)) char(dd(10)) char(dd(18)) char(dd(19)) '.txt'],'w');    
end
%texto=fopen([char(seisms(ii)) num2str(ll) '.txt'],'w');
%texto=fopen([char(seismo) '_' '.txt'],'w');

fprintf(texto,[num2str(dtacc) ' ' ' ' ',' num2str(nsteps) '\n']);
for kk=1:1:nsteps;
              if out2(kk,1)=='-';
%fprintf(texto,[' ' ' ' char(out2(kk,:)) '\n']); 
fprintf(texto,[' ' ' ' char(out2(kk,1)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) char(out2(kk,9)) '0' 'E' char(out2(kk,11)) char(out2(kk,12)) char(out2(kk,13)) '\n']); 

              else

%fprintf(texto,[' ' ' ' ' ' char(out2(kk,1)) char(out2(kk,2)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) char(out2(kk,9)) char(out2(kk,10)) char(out2(kk,11)) char(out2(kk,12)) '\n']);
fprintf(texto,[' ' ' ' ' ' char(out2(kk,2)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) '0' 'E' char(out2(kk,10)) char(out2(kk,11)) char(out2(kk,12)) '\n']);
 

              end
end
fclose(texto); 
end
end


    filename= 'Inputs.xlsx'
    xlswrite(filename,seisms,1,'A1')
     xlswrite(filename,maga,1,'B1')
    xlswrite(filename,dtacca,1,'C1')
    xlswrite(filename,nstepsa,1,'D1')
xlswrite(filename,dist,1,'E1')


    
    
%     acc2=char(zeros(nsteps,13));
%     for kk=1:1:nsteps;
%     
%         if acc(kk,1)=='-';
%                         acc2(kk,:)=acc(kk,:);
%             
%         end
%     end