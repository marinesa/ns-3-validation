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
clear selTP selnormTP
i=1;
for i=1:noUEs
    if any( temp(i,4) == innerUEs)
        selnormTP(scount) = normTp(i);
       % selTP( temp(i,3) ) = selTP( temp(i,3) )
        scount = scount + 1;
    end
end
%14/11 factor for considering control bits as part of data
[UE_tp_cdf,UE_tp_x]=ecdf(selnormTP*14/11);
%[f,x]=ecdf(selnormTP);

%figure_config_3gpp_standard_measurements_tp(x,f)


%figure_config_3gpp_standard_measurements(x,f)


