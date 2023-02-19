function [ ]=gmrotwrite2019(arg,file,phi,nc,nsteps,dtacc)
%arg is the acceleration time history, a vector of 1 column and as may rows as the number of points in the time history
%file is the name of the file, it is a string with the name of the time history. EXAMPLE:char(file(ii)) is a possible input
%where filenamegm = 'listado.txt', file = importdata(filenamegm), and listado.txt is a text file containing a list of ground motion names;
%phi is a dummy parameter it can have the value of 1 always or any number.
%nc is the number of columns, 5 for the ngawest2 format
%nsteps is the number of points in the time history
%dtacc is the time step in the time history

%file = importdata(filenamegm);

d=zeros(2,1);
out2=char(zeros(length(arg),13));% store arg in scientific notation
 
for i=1:length(arg)
	sgn(i) = sign(arg(i));%sign of acc, 1, 0, -1
	expnt(i) = fix(log10(abs(arg(i))));
	mant(i) = sgn(i) * 10^(log10(abs(arg(i)))-expnt(i));% mantissa is the decimal part
	
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
ll=0;
for jj=1%:1:ncopies;
	%seismo='P0106E05';
	ll=ll+1;
	temp=char(file);
	texto=fopen([temp(1:length(temp)) num2str(ll) '_' num2str(phi) '.AT2'],'w');%into AT2?
	%texto=fopen([char(seismo) '_' '.txt'],'w');

	%%fprintf(texto,['PEER NGA STRONG MOTION DATABASE RECORD' '\n']);
	%%fprintf(texto,['CHECK THE PEER METADATA FOR INFO' '\n']);
	%%fprintf(texto,['ACCELERATION TIME SERIES IN UNITS OF G' '\n']);
	%%fprintf(texto,['NPTS=  ' num2str(nsteps) ', DT=  ' num2str(dtacc) ' SEC,   0 POLE @    30.00000 HZ,  -5 POLE @      .12000' '\n']);
	
	for kk=1:1:nsteps	  
		if rem(kk,nc)==0
			if out2(kk,1)=='-'
				fprintf(texto,[' ' ' ' char(out2(kk,1)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) char(out2(kk,9)) '0' 'E' char(out2(kk,11)) char(out2(kk,12)) char(out2(kk,13)) '\n']); 
			else
				fprintf(texto,[' ' ' ' ' ' char(out2(kk,2)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) '0' 'E' char(out2(kk,10)) char(out2(kk,11)) char(out2(kk,12)) '\n']);
            end
		else
			if out2(kk,1)=='-'
                fprintf(texto,[' ' ' ' char(out2(kk,1)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) char(out2(kk,9)) '0' 'E' char(out2(kk,11)) char(out2(kk,12)) char(out2(kk,13))]); 
            else
                fprintf(texto,[' ' ' ' ' ' char(out2(kk,2)) char(out2(kk,3)) char(out2(kk,4)) char(out2(kk,5)) char(out2(kk,6)) char(out2(kk,7)) char(out2(kk,8)) '0' 'E' char(out2(kk,10)) char(out2(kk,11)) char(out2(kk,12))]);
			end            	
        end
	end
	fclose(texto); 
end
