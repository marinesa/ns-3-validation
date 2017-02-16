from multiprocessing import Pool
from subprocess import call

def f(i):
	dlrlcFile = 'run_' + str(i) + '_DlRlcStats.txt'
	sinrFile = 'run_' + str(i) + '_DlRsrpSinrStats.txt'
	print('Run ' + str(i))
	#configuring each thread with the 3GPP requirements
	wafString = ('./waf --run "lena-dual-stripe' +
		  ' --simTime=0.5 --nMacroEnbSites=19 --nMacroEnbSitesX=4' +
		  ' --epc=1 --epcDl=1 --epcUl=0 --outdoorUeMinSpeed=0.833 --outdoorUeMaxSpeed=0.833' +
		  ' --macroUeDensity=0.00001' +
		  ' --macroEnbBandwidth=100' +
		  ' --ns3::LteEnbNetDevice::DlBandwidth=50' +
		  ' --ns3::LteEnbNetDevice::UlBandwidth=50' +
		  ' --ns3::LteSpectrumPhy::CtrlErrorModelEnabled=true' +
		  ' --ns3::LteSpectrumPhy::DataErrorModelEnabled=true' +
		  ' --ns3::LteAmc::Ber=0.00005' +
		  ' --ns3::LteEnbRrc::DefaultTransmissionMode=1' +
		  ' --macroEnbTxPowerDbm=46' +
		  ' --ns3::LteHelper::Scheduler=ns3::RrFfMacScheduler' +
		  ' --ns3::LteHelper::HandoverAlgorithm=ns3::A2A4RsrqHandoverAlgorithm' +
		  ' --ns3::RadioBearerStatsCalculator::EpochDuration=0.1' +
		  ' --ns3::RadioBearerStatsCalculator::StartTime=0.4' +
		  ' --ns3::RadioBearerStatsCalculator::DlRlcOutputFilename=' + dlrlcFile +
		  ' --ns3::PhyStatsCalculator::DlRsrpSinrFilename=' + sinrFile +
		  ' --RngRun=' + str(i) +
		  ' --generateRem=false --remRbId=-1 --useUdp=true"')
	call(wafString, shell=True)

if __name__ == '__main__':
	#creating pool of numThreads workers  (#numThreads processes)
	#prefferably multiple of 5 to optimally use the max threads allowed
	numThreads = 5
	sampleSize = 30 
	
	p = Pool(numThreads)
	p.map(f, range(1, sampleSize+1) )

