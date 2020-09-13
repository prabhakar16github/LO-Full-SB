/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "LC_ScheduleConsumerInquiryCreation"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: This "LC_Box_Utility" class will be called in each 10 minutes from LC_ScheduleConsumerInquiryCreation class to create folder on BOX
# BOX Sequence..........: 09 Consumer Inquiry Level - Needed
###############################################################################################################################################
*/  

public with sharing class LC_Box_Utility {

	public static Access_Token__c gats;	
	public static ErrorResponse erp;
	public cfts cftsVar;
	public CI CIvar;
	public ErrorResponse errResVar; 
	public list<orders> ordVar;
	public list<FileEntries> feVar; 
	public captureFileElements cfeVar; 
	public displayAttachments daVar;

	public LC_Box_Utility(){
		feVar = new list<FileEntries>();
		ordVar = new list<orders>();
		FileEntries feTestVar = new FileEntries();
		orders ordTestVar = new orders();
		cfeVar = new captureFileElements(1,feVar,1,1,ordVar); 
		daVar = new displayAttachments();
	}

	public static void getAccess(){
		gats = new Access_Token__c();
		gats = [Select Id, Name, Token__c, Refresh_Token__c, LastmodifiedDate From Access_Token__c];
	}
	
	@future(callout=true)
	public static void createFolder2(string ParentID, Id CIID, string FolderName){
		try{
			getAccess();
			system.debug('The ATT Values are'+gats);
			FolderWrapper fc = new FolderWrapper();
			HTTPRequest req = new HTTPRequest();
			req.setTimeout(120000);
			req.setEndpoint('https://api.box.com/2.0/folders');
			req.setHeader('Authorization', 'Bearer '+gats.token__c);
			req.setBody('{"name":"'+FolderName+'","parent":{"id":"'+ParentID+'"}}');
			req.setMethod('POST');
			HTTPResponse res = new HTTPResponse();
			HTTP get_Access_Token = new HTTP();
			res = get_Access_Token.send(req);
			string bodystring = res.getBody();
			if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
				fc = (FolderWrapper)JSON.deserialize(bodyString,FolderWrapper.class);
				system.debug('The response body is '+res.getBody());
				system.debug('The response body is '+fc.Id);
	
				if(fc.Id != Null && fc.Id != ''){
					HTTPRequest req1 = new HTTPRequest();
					req1.setEndpoint('https://api.box.com/2.0/folders/'+fc.Id);
					req1.setHeader('Authorization', 'Bearer '+gats.token__c);
					req1.setBody('{"shared_link": {"access": "company"}}');
					req1.setMethod('PUT');
					req1.setTimeout(120000);
					HTTPResponse res1 = new HTTPResponse();
					HTTP Create_Shared_Link = new HTTP();
					res1 = Create_Shared_Link.send(req1);
				}
				if(fc.Id != Null && fc.Id != ''){
					Box_Folder_ID_Map__c Folder = new Box_Folder_ID_Map__c();
					Folder.Folder_ID__c = fc.Id;
					Folder.Id = CIID;
					update Folder;
				}
			}else if(res.getStatusCode() == 409){
				erp = new ErrorResponse();
				erp = (ErrorResponse)JSON.deserialize(bodyString,ErrorResponse.class);
				if(erp.status == 409){
					system.debug('Hello The Status is'+erp.status);
					if(erp.context_info != Null){
						CI CInfo = new CI();
						CInfo = erp.context_info;
						if(CInfo.conflicts != Null && CInfo.conflicts.size() > 0){
							cfts conf = new cfts();
							conf = CInfo.conflicts[0];
							if(conf.id != Null && conf.id != ''){
								Box_Folder_ID_Map__c Folder = new Box_Folder_ID_Map__c();
								Folder.Folder_ID__c = conf.id;
								Folder.Id = CIID;
								update Folder;
							}
						}
					}
				}
			}
		}catch(Exception e){
			system.debug('Exception Message == '+e.getMessage());
			system.debug('Exception Line Number == '+e.getLineNumber());
		}
	}
	
	@future(callout=true)
	public static void createFolder3(string ParentID, Id CIID, string FolderName){
		try{
			getAccess();
			system.debug('The ATT Values are'+gats);
			FolderWrapper fc = new FolderWrapper();
			HTTPRequest req = new HTTPRequest();
			req.setTimeout(120000);
			req.setEndpoint('https://api.box.com/2.0/folders');
			req.setHeader('Authorization', 'Bearer '+gats.token__c);
			req.setBody('{"name":"'+FolderName+'","parent":{"id":"'+ParentID+'"}}');
			req.setMethod('POST');
			HTTPResponse res = new HTTPResponse();
			HTTP get_Access_Token = new HTTP();
			res = get_Access_Token.send(req);
			string bodystring = res.getBody();
			if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
				fc = (FolderWrapper)JSON.deserialize(bodyString,FolderWrapper.class);
				system.debug('The response body is '+res.getBody());
				system.debug('The response body is '+fc.Id);
	
				if(fc.Id != Null && fc.Id != ''){
					HTTPRequest req1 = new HTTPRequest();
					req1.setEndpoint('https://api.box.com/2.0/folders/'+fc.Id);
					req1.setHeader('Authorization', 'Bearer '+gats.token__c);
					req1.setBody('{"shared_link": {"access": "company"}}');
					req1.setMethod('PUT');
					req1.setTimeout(120000);
					HTTPResponse res1 = new HTTPResponse();
					HTTP Create_Shared_Link = new HTTP();
					res1 = Create_Shared_Link.send(req1);
				}
				if(fc.Id != Null && fc.Id != ''){
					Firm_s_Child__c Folder = new Firm_s_Child__c();
					Folder.Box_Folder_ID__c = fc.Id;
					Folder.Id = CIID;
					update Folder;
				}
			}else if(res.getStatusCode() == 409){
				erp = new ErrorResponse();
				erp = (ErrorResponse)JSON.deserialize(bodyString,ErrorResponse.class);
				if(erp.status == 409){
					system.debug('Hello The Status is'+erp.status);
					if(erp.context_info != Null){
						CI CInfo = new CI();
						CInfo = erp.context_info;
						if(CInfo.conflicts != Null && CInfo.conflicts.size() > 0){
							cfts conf = new cfts();
							conf = CInfo.conflicts[0];
							if(conf.id != Null && conf.id != ''){
								Firm_s_Child__c Folder = new Firm_s_Child__c();
								Folder.Box_Folder_ID__c = conf.id;
								Folder.Id = CIID;
								update Folder;
							}
						}
					}
				}
			}
		}catch(Exception e){
			system.debug('Exception Message == '+e.getMessage());
			system.debug('Exception Line Number == '+e.getLineNumber());
		}
	}

	public string createFolder(string ParentID){
		getAccess();
		system.debug('The ATT Values are'+gats);
		FolderWrapper fc = new FolderWrapper();
		HTTPRequest req = new HTTPRequest();
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/folders');
		req.setHeader('Authorization', 'Bearer '+gats.token__c);
		req.setBody('{"name":"Archived","parent":{"id":"'+ParentID+'"}}');
		req.setMethod('POST');
		HTTPResponse res = new HTTPResponse();
		HTTP get_Access_Token = new HTTP();
		res = get_Access_Token.send(req);
		string bodystring = res.getBody();
		fc = (FolderWrapper)JSON.deserialize(bodyString,FolderWrapper.class);
		system.debug('The response body is '+res.getBody());
		system.debug('The response body is '+fc.Id);
		if(fc.Id != Null && fc.Id != ''){
			return fc.Id;
		}
		return Null;
	}

	public void searchFolder(string sourcestr, string deststr){
		getAccess();
		HTTPRequest req = new HTTPRequest();
		HTTPResponse res = new HTTPResponse();
		SearchWrapper sw1 = new SearchWrapper();
		SearchWrapper sw2 = new SearchWrapper();
		
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/search?query='+sourcestr);
		req.setMethod('GET');
		system.debug('The access token is'+gats.Token__c);
		req.setHeader('Authorization', 'Bearer '+gats.Token__c);
		HTTP getFolderDetail = new http();
		res = getFolderDetail.send(req);
		sw1 = (SearchWrapper)JSON.deserialize(res.getBody(),SearchWrapper.class);
		system.debug('The sw is'+sw1);
		system.debug('The sw is'+sw1.entries[0].id);
		
		
		req.setEndpoint('https://api.box.com/2.0/search?query='+deststr);
		req.setMethod('GET');
		req.setHeader('Authorization', 'Bearer '+gats.Token__c);
		getFolderDetail= new http();
		res = getFolderDetail.send(req);
		sw2 = (SearchWrapper)JSON.deserialize(res.getBody(),SearchWrapper.class);
		system.debug('The sw is'+sw2);
		system.debug('The sw is'+sw2.entries[0].id);
		if(sw1.entries[0].id != Null && sw1.entries[0].id != '' && sw2.entries[0].id != Null && sw2.entries[0].id != ''){
			CopyFolderElements(sw1.entries[0].id,sw2.entries[0].id,'Copy');
		}
	}
	
	@future(callout = true)
	public static void CopyFolderElements(string SourceID, string DestinationID, string Type){
		if(SourceID != Null && SourceID != '' && DestinationID != Null && DestinationID != ''){
			getAccess();
			//Retrieve a Folder’s Items from Source ID
			LC_FileClass cfe = new LC_FileClass();
			HTTPResponse res = new HTTPResponse();
			HTTPRequest req = new HTTPRequest();
			req.setTimeout(120000);
			req.setEndpoint('https://api.box.com/2.0/folders/'+SourceID+'/items');
			req.setHeader('Authorization','Bearer '+gats.Token__c);
			req.setMethod('GET');
			HTTP getFolderItems = new HTTP();
			res = getFolderItems.send(req);
			string bodyString = res.getBody();
			cfe = (LC_FileClass)JSON.deserialize(bodyString,LC_FileClass.class);
			if(cfe.total_count > 0){
				map<string,object> m = (map<string,object>)JSON.deserializeUntyped(bodystring);
				list<object> pricing = (list<object>)m.get('entries');
				string str = '';
				list<string> stringlist;
				str = string.valueof(m.get('entries'));
				if(str != Null && str != ''){
					stringlist = new list<string>();
					stringlist =  str.split(',');
					
					system.debug(stringlist);
					system.debug(stringlist.size());
					
					string FileID;
					if(stringlist != null && stringlist.size() > 0){
						integer count = 0;
						for(string str2 : stringlist){
							system.debug('the str is'+str2);
							count++;
							if(str2.trim().startsWith('id=')){
								FileID = str2.substring(4,str2.length());
								if(FileID != Null && FileID != ''){
									if(Type == 'Copy'){
										system.debug('The FILEID is'+FileID);
										changeParentIDS(FileID, DestinationID, gats.Token__c);
									}else if(Type == 'Move'){
										ChangeParentIDS(FileID, DestinationID, gats.Token__c);
										DeleteParentIDS(FileID, DestinationID, gats.Token__c);
									}	
								}	
							}
						}
					}
				}	
			}	
		}	
	}
	
	@future(callout=true)
	public static void changeParentIDS(string FileID, string DestID, string AccessToken){
		getAccess();
		HTTPResponse res = new HTTPResponse();
		HTTPRequest req = new HTTPRequest();
		system.debug('The source ID is'+FileID);
		system.debug('The source ID is'+DestID);
		system.debug('The source ID is'+AccessToken);
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/files/'+FileID+'/copy');
		req.setHeader('Authorization','Bearer '+gats.Token__c);
		req.setMethod('POST');
		req.setBody('{"parent": {"id" : '+DestID+'}}');
		HTTP CopyFolderElements = new HTTP();
		res = CopyFolderElements.send(req);
		system.debug('The response body is'+res.getBody());
	}
	
	@future(callout=true)
	public static void changeFolderDestination(string FolderID, string DestID){
		getAccess();
		HTTPResponse res = new HTTPResponse();
		HTTPRequest req = new HTTPRequest();
		system.debug('The source ID is'+FolderID);
		system.debug('The source ID is'+DestID);
		system.debug('The source ID is'+gats.Token__c);
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/folders/'+FolderID);
		req.setHeader('Authorization','Bearer '+gats.Token__c);
		req.setMethod('PUT');
		req.setBody('{"parent": {"id" : '+DestID+'}}');
		HTTP changeFolderDestination = new HTTP();
		res = changeFolderDestination.send(req);
		system.debug('The response body is'+res.getBody());
	}
	
	@future(callout = true)
	public static void DeleteParentIDS(string FileID, string DestID, string AccessToken){
		getAccess();
		HTTPResponse res = new HTTPResponse();
		HTTPRequest req = new HTTPRequest();
		system.debug('The source ID is'+FileID);
		system.debug('The source ID is'+DestID);
		system.debug('The source ID is'+AccessToken);
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/files/'+FileID);
		req.setHeader('Authorization','Bearer '+gats.Token__c);
		req.setMethod('DELETE');
		HTTP CopyFolderElements = new HTTP();
		res = CopyFolderElements.send(req);
		system.debug('The response body is'+res.getBody());
	}
	
	public static void CollabirateFolder(string FolderID, string AccessToken){
		getAccess();
		HTTPResponse res = new HTTPResponse();
		HTTPRequest req = new HTTPRequest();
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/collaborations');
		req.setHeader('Authorization', 'Bearer '+AccessToken);
		req.setMethod('POST');
		req.setBody('{"item": { "id": "'+FolderID+'", "type": "folder"}, "accessible_by": { "id": "226652277", "type": "user" }, "role": "viewer"}');
		//req.setBody('{"name":"New Folder11","parent":{"id":"'FolderID'"}}');
		HTTP get_Access_Token = new HTTP();
		res = get_Access_Token.send(req);
		system.debug('the response is'+res.getBody());
		
	}
	
	@future(callout=true)
	public static void ChangeFileName(string FileID,string FileName){
		getAccess();
		HTTPResponse res = new HTTPResponse();
		HTTPRequest req = new HTTPRequest();
		req.setTimeout(120000);
		req.setEndpoint('https://api.box.com/2.0/files/'+FileID);
		req.setHeader('Authorization', 'Bearer '+gats.Token__c);
		req.setMethod('PUT');
		req.setBody('{"name":"'+FileName+'"}');
		HTTP get_Access_Token = new HTTP();
		res = get_Access_Token.send(req);
		system.debug('the response is'+res.getBody());
	}
	
	public class SearchWrapper{
		public integer total_count;
		public integer limit2;
		public integer offset;
		public list<FolderWrapper> entries;
		public SearchWrapper(){
			total_count = 0;
			limit2 = 0;
			offset = 0;
			entries = new list<FolderWrapper>();
		}
	}
	
	public class FolderWrapper{
		public string type;
		public string id;
		public string sequence_id;
		public string etag;
		public string sha1;
		public string name;
		public string description;
		public integer size;
		public string created_at;
		public string modified_at;
		public string trashed_at;
		public string purged_at;
		public string content_created_at;
		public string content_modified_at;
		public string shared_link;
		public string item_status;
		public FolderWrapper(){
			type = '';
			id = '';
			sequence_id = '';
			etag = '';
			sha1 = '';
			name = '';
			description = '';
			size = 0;
			created_at = '';
			modified_at = '';
			trashed_at = '';
			purged_at = '';
			content_created_at = '';
			content_modified_at = '';
			shared_link = '';
			item_status = '';
		}
	}
	
	public class displayAttachments{
		public boolean Check{get;set;}
		public string Attachment_Name{get;set;}
		public string FileID{get;set;}
		public string Type{get;set;}
		
		public displayAttachments(){
			Check = false;
			Attachment_Name = '';
			FileID = '';
			Type = '';
		}
	}
	
	/* File Wrapper*/
	
	public class captureFileElements{
		public integer total_count;
		public list<FileEntries> entries;
		public integer offset;
		public integer limit2;
		public list<Orders> Order;
		
		public captureFileElements(integer cnt, list<FileEntries> fle, integer ofst, integer limt, list<Orders> ords){
			total_count = cnt;
			entries = fle;
			offset = ofst;
			limit2 = limt;
			Order = ords;
		}
	}
	
	/* File Wrapper*/
	
	/* File Wrapper*/
	
	public class FileEntries{
		public string Type;
		public string id;
		public string sequence_id;
		public string etag;
		public string sha1;
		public string name;
		
		public FileEntries(){
			
		}
	}
	
	/* File Wrapper*/
	/* File Wrapper*/
	
	public class orders{
		public string by1;
		public string direction;
		
		public orders(){
			
		}
	}
	/* File Wrapper*/
	/*Error Response*/
	public class ErrorResponse{
		public string type;
		public integer status;
		public string code;
		public string help_url;
		public string message;
		public string request_id;
		public CI context_info;
	}
	
	public class CI{
		public list<cfts> conflicts;
	}
	
	public class cfts{
		public string type;
		public string id;
		public string sequence_id;
		public string etag;
		public string name;
	}
	/*Error Response*/
}