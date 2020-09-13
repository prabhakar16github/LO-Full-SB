trigger CMF_DateofBirthTrigger on Consumer_Master_File__c (before insert) 
{
    /* Depricated and Code has been merged in ConsumerMasterFileTrigger. */
    /* Need to remove. */
    List<Consumer_Master_File__c> consumer = new List<Consumer_Master_File__c>();
    consumer = [Select id,Consumer_First_Name__c,Consumer_Last_Name__c,Date_of_Birth__c,SSN__c FROM Consumer_Master_File__c];
    system.debug('consumer-->'+consumer);
    
    for(Consumer_Master_File__c cmf : Trigger.new)
    {
        for(Consumer_Master_File__c cmfile : consumer)
        {
                DateTime dt1 = system.today();
            Date d1 = dt1.date();
            DateTime dt2 = cmf.Date_of_Birth__c;
            Date d2 = dt2.date();
            Date myDate = date.newInstance(1900, 01, 01);
            system.debug('myDate-->'+myDate);
            system.debug('d1-->'+d1);
            system.debug('d2-->'+d2);
            
            if(cmfile.Consumer_First_Name__c == cmf.Consumer_First_Name__c && cmfile.Consumer_Last_Name__c == cmf.Consumer_Last_Name__c && cmfile.Date_of_Birth__c == cmf.Date_of_Birth__c
                && cmfile.SSN__c == cmf.SSN__c && cmf.SSN__c != '000-00-0000')
            {
                system.debug('cmfile.Consumer_First_Name__c'+cmfile.Consumer_First_Name__c);
                system.debug('cmf.Consumer_First_Name__c'+cmf.Consumer_First_Name__c);
                
                cmf.addError('A Consumer Master File record already exists for a Consumer with the same first & last name, DOB and SSN.');
            }
            /*if(cmfile.Consumer_Last_Name__c == cmf.Consumer_Last_Name__c)
            {
                system.debug('cmfile.Consumer_Last_Name__c'+cmfile.Consumer_Last_Name__c);
                system.debug('cmf.Consumer_Last_Name__c'+cmf.Consumer_Last_Name__c);
                
                cmf.Consumer_Last_Name__c.addError('A record cannot be created with the duplicate Last Name');
            }
            if(cmfile.Date_of_Birth__c == cmf.Date_of_Birth__c)
            {
                system.debug('cmfile.Date_of_Birth__c'+cmfile.Date_of_Birth__c);
                system.debug('cmf.Date_of_Birth__c'+cmf.Date_of_Birth__c);
                
                cmf.Date_of_Birth__c.addError('A record cannot be created with the duplicate Date of Birth');
            }
            if(cmfile.SSN__c == cmf.SSN__c)
            {
                system.debug('cmfile.SSN__c'+cmfile.SSN__c);
                system.debug('cmf.SSN__c'+cmf.SSN__c);
                
                cmf.SSN__c.addError('A record cannot be created with the duplicate Date of SSN');
            }*/
            else if(d2 == d1)
            {
                cmf.Date_of_Birth__c = myDate ;
            }
        }
    }
}