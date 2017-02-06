%##################Inner Rings#############
innerCells = [ 5 6 7 10 11 12 16];
innerCells = [innerCells innerCells+19 innerCells+19*2];
innerUEs=[];
for i = 1:noUEs
    if any(temp(i,3) == innerCells)
        innerUEs = [innerUEs temp(i,4)];
    end
end

scount=1;
for i = 1:noUEs
    if any( temp(i,4) == innerUEs)
        selnormTP(scount) = normTp(i);
        scount = scount + 1;
    end
end

[f,x]=ecdf(selnormTP);

%figure_config_3gpp_standard_measurements_tp(x,f)

seluesinr=zeros(noUEs,1);
for i=1:size(selection,1)
    if any( selection(i,3) == innerUEs)
       seluesinr(selection(i,3)) = seluesinr(selection(i,3)) + selection(i,6);
    end
end
seluesinr(~any(seluesinr,2),: ) = [];
%1000 samples per second, so needs to be averaged
seluesinrdb= 10*log10(seluesinr/(1000*epochDuration));
[f,x]=ecdf(seluesinrdb);

%figure_config_3gpp_standard_measurements(x,f)


