// Needed in Utility Box class

public with sharing class LC_FileClass {
		
	public integer total_count;
	public list<FileEntries> FileList;
	public integer offset;
	public integer limit2;
	public list<Orders> OrderList;
	public FileEntries Fe;
	
	public LC_FileClass(){
		total_count = 0;
		Fe = new FileEntries();
		FileList = new list<FileEntries>();
		offset = 0;
		limit2 = 0;
		OrderList = new list<Orders>();
	}
	
	public class FileEntries{
		public string Type;
		public string id;
		public string sequence_id;
		public string etag;
		public string sha1;
		public string name;
		public FileEntries(){
			Type = '';
			id = '';
			sequence_id = '';
			etag = '';
			sha1  = '';
			name = '';			
		}
	}
	
	public class orders{
		public string by1;
		public string direction;
		public orders(){
			by1 = '';
			direction ='';
		}
	}
}