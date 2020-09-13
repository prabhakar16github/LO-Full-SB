global class MonthlyNotificationtoProfileUsers implements schedulable
{
     public static String CRON_EXP = '0 0 0 1 * ? *';

    global static String scheduleIt() {
        MonthlyNotificationtoProfileUsers sm = new MonthlyNotificationtoProfileUsers();
        return System.schedule('Monthly Reconciliation', CRON_EXP, sm);
    }

  global void execute(SchedulableContext sc)
   {
      Date d = System.today();
      Datetime dt = (DateTime)d;
      String dayOfWeek = dt.format('EEEE');
      system.debug('dayOfWeek-->'+dayOfWeek);
      system.debug('dt-->'+dt);
      if(dayOfWeek!='Saturday' && dayOfWeek!='Sunday'){
          EmailTemplate et = [SELECT id FROM EmailTemplate WHERE Id = '00X0B0000011zml'];
          List<Profile> userProfile = [select id from profile where Name='CC - User Access'];
          OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lcsalesforceadmin@mcmcg.com'];
          List<User> userList = new List<User>();
          userList = [Select id,IsActive from user where ProfileID IN:userProfile AND IsActive = TRUE];
          system.debug('userList-->'+userList);
          system.debug('userListsize-->'+userList.size());

          List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage> ();

          if(userList.size() >0 && userList != Null)
          {
            for(User user : userList)
              {
                system.debug('user-->'+user);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(user.Id);
                        mail.setSaveAsActivity(false);
                        mail.setTemplateId(et.id);
                        mail.setSaveAsActivity(false);
                        mails.add(mail);
              }
                        Messaging.sendEmail(mails);
          }
       }
    else{
        String CRON_EXP_NEXT_MONDAY='0 0 0 ';
        if(dayOfWeek=='Saturday'){
            CRON_EXP_NEXT_MONDAY=CRON_EXP_NEXT_MONDAY+'3';
            }
        else if(dayOfWeek=='Sunday'){
            CRON_EXP_NEXT_MONDAY=CRON_EXP_NEXT_MONDAY+'2';
            }
        CRON_EXP_NEXT_MONDAY=CRON_EXP_NEXT_MONDAY+' '+d.month() +' ?';
        MonthlyNotificationtoProfileUsers sm = new MonthlyNotificationtoProfileUsers();
        System.schedule('Monthly Reconciliation', CRON_EXP_NEXT_MONDAY, sm);
        }
   }
}