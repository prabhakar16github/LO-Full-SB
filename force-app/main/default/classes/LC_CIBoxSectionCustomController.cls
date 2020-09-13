/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: class : "LC_CIBoxSectionCustomController"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: This class helps in retrieving the Hash Key so that the wizard can be displayed in related Page on CI Detail.
# BOX Sequence..........: 01 Controller Class for CIBoxSectionCustom.page 
###############################################################################################################################################
*/
public with sharing class LC_CIBoxSectionCustomController {

	public Consumer_Inquiries__c CI;
	public Access_Token__c gats;

	public FolderWrapper FC;
	public FileEntry Entry;
	public sharedlink sh;
	public string FinalURL{get;set;}
	public string source{get;set;}
	public string str;
	
	//public list<displayAttachments> Box_Attachments{get;set;}
	public list<FileEntries> Files;
	public FileEntries fe;
	
	public LC_CIBoxSectionCustomController(apexpages.standardController sc){
		gats = new Access_Token__c();
		CI = new Consumer_Inquiries__c();

		fc = new FolderWrapper();
		Entry = new FileEntry();
		fe = new FileEntries();
		sh = new sharedlink();
		source = '';
		
		gats = [Select Id, Name, Token__c, Refresh_Token__c, LastmodifiedDate From Access_Token__c];
		//Box_Attachments = new list<displayAttachments>();
		Files = new list<FileEntries>();
		Id CIID = apexpages.currentPage().getParameters().get('ID');
		list<Firm_s_Child__c> FolderMapList = new list<Firm_s_Child__c>();
		FolderMapList = [Select Id, Name, Box_Folder_ID__c from Firm_s_Child__c Where Reference_ID__c =: CIID and Type__c = 'Consumer Inquiry'];
		if(FolderMapList != Null && FolderMapList.size() > 0 && FolderMapList[0].Box_Folder_ID__c != Null && FolderMapList[0].Box_Folder_ID__c != ''){
			str = FolderMapList[0].Box_Folder_ID__c;//Folder Id is picked up from Box Folder ID Map Table
			FolderDetail();
		}else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please try after some time as the folder has not yet created.'));
		}
	}
	
	public pageReference FolderDetail(){
		if(str != Null && str != ''){
			HTTPRequest req = new HTTPRequest();
			HTTPResponse res = new HTTPResponse();
			
			req.setEndpoint('https://api.box.com/2.0/folders/'+str);//Request URL to get Folder Information
			req.setMethod('GET');
			req.setHeader('Authorization', 'Bearer '+gats.Token__c);
			HTTP getFolderDetail = new http();
			res = getFolderDetail.send(req);//Sending the request to get the actual response
			string bodystring = res.getBody();
			system.debug('The body string is'+bodystring);
			
			fe = (FileEntries)JSON.deserialize(bodyString,FileEntries.class);// Parsing the above request
			system.debug('The actual output is'+fe);

			
			if(fe == Null){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please try after some time as the folder has not yet shared.'));
				return null;
			}else{
				if(fe.shared_link != Null){//extracting the shared link
					string FinalURL = fe.shared_link.url;
					integer FinalIndex = FinalURL.lastIndexOf('/');
					string FinalString =  FinalURL;
					FinalURL = FinalString.substring(FinalIndex,FinalString.length());
					system.debug('The final URL is'+FinalURL);
					//Framing the Hash Key
					source = 'https://encorecapital.app.box.com/embed_widget/p7nrlheardsg/s/'+FinalURL+'?view=list&sort=name&direction=ASC&theme=blue';
				}else{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Now, no folder exists in box with this name.'));
				}
				return null;
			}
		}else{
			
		}		
		return null;
	}
/*
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
*/	
	/* File Wrapper*/
	public class FileEntries{
		public string Type;
		public string id;
		public string sequence_id;
		public string etag;
		public string sha1;
		public string name;
		public string created_at;
		public string modified_at;
		public string description;
		public integer size;
		
		//public PC path_collection;
		//public createdby created_by;
		//public modifiedby modified_by;
		//public ownedby owned_by;
		public sharedlink shared_link;
	}
	/* File Wrapper*/
	/* File Wrapper*/
	/*
	public class orders{
		public string by1;
		public string direction;
	}
	*/
	/* File Wrapper*/
	
	public class FolderWrapper{
		public integer total_count;
		public integer limit1;
		public integer offset;
		public list<FileEntry> Entries;
	}

	/*
	public class PC{
		integer total_count;
		public list<FileEntry> entries;
	}
	*/
		
	public class FileEntry{
		public string type;
		public string id;
		public string sequence_id;
		public string etag;
		public string name;
	}
	/*	
	public class createdby{
		public string type;
		public string id;
		public string name;
		public string login;
		public createdby(){
			type = '';
			id = '';
			name = '';
			login = '';
		}
	}

	public class modifiedby{
		public string type;
		public string id;
		public string name;
		public string login;
		public modifiedby(){
			type = '';
			id = '';
			name = '';
			login = '';
		}
	}
	
	public class ownedby{
		public string type;
		public string id;
		public string name;
		public string login;
		public ownedby(){
			type = '';
			id = '';
			name = '';
			login = '';
		}
	}
	*/
	public class sharedlink{
		public string url;
		public string download_url;
		public string vanity_url;
		public string effective_access;
		public boolean is_password_enabled;
		public string unshared_at;
		public integer download_count;
		public integer preview_count;
		public string access;
		public list<permissions> permission;
		public sharedlink(){
			
		}
	}
	
	public class permissions{
		public boolean can_download;
		public boolean can_preview;
	}
}