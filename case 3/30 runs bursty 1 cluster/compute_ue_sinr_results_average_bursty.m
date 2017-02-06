innerCells = [ 5 6 7 10 11 12 16];
innerCells = [innerCells innerCells+19 innerCells+19*2];


%% Initial simulation parameters
numberUEs = 1425;
numberCells = 57;
epochDuration = 0.001;
bandwidth = 20*10^6/2;
clear TPcdf SINRcdf scountMat scount
sampleSize = 30;
totInnerTP = 0;
datacontrolRatio = 14/11; %includes control bits as otherwise throughput only includes data bits from frame
myArray= [1, 2, 3, 6, 7, 8, 10, 11, 12, 14, 15, 16, 17, 18, 19];

innerUEsTP = [];
innerRX=[];
innerTX=[];
for ff = 1:sampleSize
    kk=ff;%myArray(ff);
    dlrlcFile = ['run_' num2str(kk) '_DlRlcStats.txt'];
   
    temp = load (dlrlcFile);
   % cd '../..'
    DlRxBytes = temp(:,15);
    noUEs = size(DlRxBytes,1);
    DlAverageThroughputKbps = sum (DlRxBytes) * 8 / 1000 / epochDuration;

    normTp = DlRxBytes * 8 /epochDuration;%*(numberUEs/numberCells);
    [f,x]=ecdf(normTp);

    %figure_config_3gpp_standard_measurements_tp(x,f)

    MeanTp =  mean(DlRxBytes) * 8 / epochDuration;
    meanEff = mean(DlRxBytes) * 8/ epochDuration/ bandwidth; %*(numberUEs/numberCells);

    cells=zeros(57,1);
    innerTP=0;
    i=1;
    while i <= noUEs
         if any( temp(i,3) == innerCells)
            innerUEsTP = [innerUEsTP temp(i,15)];
        	innerTP = innerTP + temp(i,15);
            innerTX = [innerTX temp(i,8)];
            innerRX = [innerRX temp(i,10)];
         end
        cells(temp(i,3)) = cells(temp(i,3)) + temp(i,15);
        i = i+1;
    end
    cellTp=cells*8/epochDuration ;
    speceff=mean(cellTp/bandwidth) ;
    inner_ues_and_cells_comp
    TPcdf{ff} = selnormTP*datacontrolRatio;
    scountMat(ff) = scount;
    
    totInnerTP = totInnerTP + innerTP;
end

totTPcdf=[];
for i=1:sampleSize
       totTPcdf= [totTPcdf TPcdf{i}];
end

trueInnerTP = innerUEsTP*8/epochDuration*datacontrolRatio;

%% Downlink Cell Spectral efficiency
%multiply by 8 to get bits from bytes
%cell_spectral_eff = totInnerTP * 8 / bandwidth * datacontrolRatio  / sampleSize / length(innerCells) 


%% Normalized User Throughput CDF
[f,x]=ecdf(trueInnerTP/10^6);
figure_config_3gpp_standard_measurements_tp(x,f)

%% Computing lowest 5% users normalised throughput (Cell-edge User Spectral Efficiency)
sorted = sort(trueInnerTP);
lowest_5percent_mean_tp = sorted( floor ( length(sorted) * 5 / 100 ) );

%% Mean Throughput
mean_throughput = mean(trueInnerTP)

%% Median Throuhgput 
median_throughput = sorted( floor ( length(sorted) * 50 / 100 ) )

%% Percentage of users with 1% or more dropped packets
delta = (innerTX-innerRX)./innerTX;
perc_dropped = length( find(delta >= 0.01 ) )/length(delta) * 100




    


