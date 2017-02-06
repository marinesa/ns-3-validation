%% ##################Inner Rings Selection#############
innerCells = [ 5 6 7 10 11 12 16];
innerCells = [innerCells innerCells+19 innerCells+19*2];
innerUEs=[];
for i = 1:noUEs
    if any(temp(i,3) == innerCells)
        innerUEs = [innerUEs temp(i,4)];
    end
end


%% Initial simulation parameters
numberUEs = 1425;
numberCells = 57;
epochDuration = 0.1;
bandwidth = 20*10^6/2;
clear TPcdf SINRcdf
sampleSize = 30;
totInnerTP = 0;
datacontrolRatio = 14/11; %includes control bits as otherwise throughput only includes data bits from frame

for kk = 1:sampleSize
    
    dlrlcFile = ['run_' num2str(kk) '_DlRlcStats.txt'];
    sinrFile = ['run_' num2str(kk) '_DlRsrpSinrStats.txt'];
   % cd 'results/30 runs full buffer'
    temp = load (sinrFile);
   % cd '../..'
    selection = temp(find(temp(:,1)>=0.4),:);

    uesinr=zeros(numberUEs,1);
    for i=1:size(selection,1)
        uesinr(selection(i,3)) = uesinr(selection(i,3)) + selection(i,6);
    end
    %100 samples per each ue's SINR (one every ms)
    uesinrdb= 10*log10(uesinr/(1000*epochDuration));
    [f,x]=ecdf(uesinrdb);

    %figure_config_3gpp_standard_measurements(x,f)

   % cd 'results/30 runs full buffer'
    clear temp;

    temp = load (dlrlcFile);
    %cd '../..'
    DlRxBytes = temp(:,10);
    noUEs = size(DlRxBytes,1);
    DlAverageThroughputKbps = sum (DlRxBytes) * 8 / 1000 / epochDuration;

    normTp = DlRxBytes * 8 /epochDuration/bandwidth;%*(numberUEs/numberCells);
    [f,x]=ecdf(normTp);

    %figure_config_3gpp_standard_measurements_tp(x,f)

    MeanTp =  mean(DlRxBytes) * 8 / epochDuration;
    meanEff = mean(DlRxBytes) * 8/ epochDuration/bandwidth; %*(numberUEs/numberCells);

    cells=zeros(57,1);
    innerTP=0;
    for i=1:noUEs
         if any( temp(i,3) == innerCells)
        	innerTP = innerTP + temp(i,10);
         end
        cells(temp(i,3)) = cells(temp(i,3)) + temp(i,10);
    end
    cellTp=cells*8/epochDuration ;
    speceff=mean(cellTp/bandwidth) ;
    inner_ues_and_cells_comp
    TPcdf{kk} = selnormTP*datacontrolRatio;
    scountMat(kk) = scount;
   
    
    SINRcdf{kk} = seluesinrdb;
    
    totInnerTP = totInnerTP + innerTP;
end

totTPcdf=[];
for i=1:sampleSize
       totTPcdf= [totTPcdf TPcdf{i}];
end

%% Downlink Cell Spectral efficiency
%multiply by 8 to get bits from bytes
cell_spectral_eff = totInnerTP * 8 / bandwidth * datacontrolRatio  / sampleSize / length(innerCells) / epochDuration


%% Normalized User Throughput CDF
[f,x]=ecdf(totTPcdf);

figure_config_3gpp_standard_measurements_tp(x,f)

%% Computing lowest 5% users normalised throughput (Cell-edge User Spectral Efficiency)
lowest_5percent_mean_tp = x( floor( 5/100 * length(x) ) )
%mean( x( 1:floor( 5/100 * length(x) ) ) )

%% Mean Throughput
mean_throuhgput = mean(x)

%% Median Throuhgput 
median_throughput = x( floor( 1/2 * length(x) ) )


%% DL Per UE Average SINR   
totSINRcdf=[];
for i=1:sampleSize
    totSINRcdf= [totSINRcdf; SINRcdf{i}];
end
[f,x]=ecdf(totSINRcdf);

figure_config_3gpp_standard_measurements(x,f)
    


