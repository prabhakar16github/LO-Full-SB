global with sharing class ScheduleAccessToken{
    global ScheduleAccessToken(){
        ScheduleAccessToken1 sfc = new ScheduleAccessToken1();
        datetime dt = system.now().addMinutes(2);
        integer sch_Min = dt.minute();
        integer sch_Hour = dt.hour();
        integer minute = sch_Min;
        //string sch = '0 '+minute+' * '+system.today().day()+' '+system.today().month()+' ? '+system.today().year();
        string sch = '0 '+minute+' * * * ? *';
        system.debug('The sch value is'+sch);
        system.schedule('Access Token HTTP Request'+system.now(), sch, sfc);
    }
}