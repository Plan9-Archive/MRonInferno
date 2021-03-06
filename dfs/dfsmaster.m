########################################
#
#	The Master side of the distributed file system.
#	Maintain the infomation of every file, chunk and node in the file system.
#	These infomation are stored in the metadata.
#	DFSMaster provide some functions for clients to get and change the metadata.
#
#	@author Xinyang Shao(daniel)
#
########################################

DFSMaster : module {
	PATH : con "/appl/MR/dfs/dfsmaster.dis";

	init : fn();

	MetaData : adt {
		nodes : list of ref DFSUtil->DFSNode;
		fileIndex : ref Hash->HashTable;
		files : ref Tables->Table[ref DFSUtil->DFSFile];
		chunks : ref Tables->Table[ref DFSUtil->DFSChunk];
 	};

	createFile : fn(fileName : string, replicas : int);
	getFile : fn(fileName : string) : ref DFSUtil->DFSFile;
	listFiles : fn() : list of string;
	deleteFile : fn(fileName : string) : int;	

	createChunk : fn(fileName : string, offset : big, size : int) : int;

	updateNode : fn(node : ref DFSUtil->DFSNode);
	removeNode : fn(node : ref DFSUtil->DFSNode) : int;
 };	
