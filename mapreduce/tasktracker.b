#######################################
#
#	The implemention of the TaskTracker module.
#	MapperAddrList stores addresses of mapper results. When mapperTasks are all succeed, these addresses will be sent to ReducerWorkers.
#
#	@author Yang Fan(fyabc) 
#
########################################

implement TaskTracker;

include "sys.m";
include "tasktracker.m";
include "ioutil.m";
include "mrutil.m";
include "reducerworker.m";
include "mapperworker.m";

include "tables.m";

sys : Sys;
ioutil : IOUtil;
mrutil : MRUtil;
tables : Tables;
mapperworker : MapperWorker;
reducerworker : ReducerWorker;

Table : import tables;
MapperTask : import mrutil;
ReducerTask : import mrutil;
TaskTrackerInfo : import mrutil;

MapperAddrList : adt {
	items : list of string;
};

m2rTable : ref Tables->Table[ref MapperAddrList];

init()
{
	sys = load Sys Sys->PATH;
	mrutil = load MRUtil MRUtil->PATH;
	tables = load Tables Tables->PATH;
	mapperworker = load MapperWorker MapperWorker->PATH;
	reducerworker = load ReducerWorker ReducerWorker->PATH;

	mapperworker->init();
	reducerworker->init();

	m2rTable = Tables->Table[ref MapperAddrList].new(100, nil);
}

runMapperTask(mapper : ref MapperTask) : int
{
	mapperworker->run(mapper);
	return 0;
}

runReducerTask(mapperFileAddr : string, reducer : ref ReducerTask) : (int, string)
{
	mapperAddrList := m2rTable.find(reducer.id);
	sys->print("tracker get %s\n", mapperFileAddr);
	if (mapperAddrList == nil) {
		mapperAddrList = ref MapperAddrList(mapperFileAddr :: nil);
		m2rTable.add(reducer.id, mapperAddrList);
	} else {
		mapperAddrList.items = mapperFileAddr :: mapperAddrList.items;
	}
	if (len mapperAddrList.items < reducer.mapperAmount) 
		return (1, nil);
	
	return reducerworker->run(mapperAddrList.items, reducer);
}


