   
function [nsteps,dtacc] = dt_npt2019(name)

fid=fopen([char(name)]);
    
    if fid<0
        error('##### unable to open record file ####')
    end;
    
    skipline=3;
    nsteps=0;
    dtacc=0;
    for i=1:skipline+1
        tline = fgetl(fid);
    end;
    match1 = find(tline=='=');
    match2 = find(tline=='N');
    match3 = find(tline=='S');
    match4 = find(tline==',');
    
    nsteps=str2num(tline(match1(1)+1:match4(1)-1));%THIS WAS ACTIVE
    dtacc=str2num(tline(match1(2)+1:match3(2)-1));
  
    if nsteps<=0
        disp('ERROR: not able to find DT or NPTS');
        return;
    end;
    if dtacc<=0
        disp('ERROR: not able to find DT or NPTS');
        return;
    end;    
    fclose(fid);    
end
