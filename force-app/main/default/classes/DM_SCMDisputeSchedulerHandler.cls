/***********************************************************************************
 * Class Name  : DM_SCMDisputeSchedulerHandler
 * Description : This class is a generic class which schedule other schdeuler classes and skip weekends.
 * Created By  : Shivangi Srivastava
 * Created Date: 18-02-2020
 * *******************************************************************************/ 
public class DM_SCMDisputeSchedulerHandler {
	private static Set<String> weekendDays = new Set<String>{ 'Saturday', 'Sunday' };
	private Date d;//Date.newInstance(System.today().year(), System.today().addMonths(4).month(), 1); //System.today();
	
    public DM_SCMDisputeSchedulerHandler(Date todayDate){
        this.d = todayDate;
    }
    public void scheduleJobs() {
        
        Datetime dt = (DateTime) d;
		String dayOfWeek = dt.format('EEEE');

		String CRON_EXP_FOR_INITIAL_CREATION; // run on 1st day of month
		String CRON_EXP_FOR_FIRST_ESC_DAY_FOUR; // run on 4rd day of month
		String CRON_EXP_FOR_SECOND_ESC_DAY_FIVE; // run on 5th day of month
		String CRON_EXP_FOR_SECOND_ESC_DAY_SIX; // run on 6th day of month
		String CRON_EXP_FOR_FINAL_ESC_DAY_SEVEN; // run on 7th day of month
		String CRON_EXP_FOR_FINAL_ESC_DAY_EIGHT; // run on 8th day of month
		String CRON_EXP_FOR_FINAL_ESC_DAY_NINE; //  run on 9th day of month
		String CRON_EXP_FOR_FINAL_ESC_DAY_TEN; // run on 10th day of month
		String CRON_EXP_FOR_NO_RESPONSE_DAY_ELEVEN; // run on 11th day of month


		/******************************************** Initial Creation on day 1 ******************************************************/
		Integer INITIAL_CREATION_DAY;

		if(!isWeekend(dayOfWeek)) {
			INITIAL_CREATION_DAY = 1;
		} else if(dayOfWeek == 'Saturday') {
			INITIAL_CREATION_DAY = 3;
		} else if(dayOfWeek == 'Sunday') {
			INITIAL_CREATION_DAY = 2;
		}

		if(INITIAL_CREATION_DAY != NULL) {
			CRON_EXP_FOR_INITIAL_CREATION = getCRON_Expression(INITIAL_CREATION_DAY);// '0 0 0 ' + INITIAL_CREATION_DAY + '  * ? *';


			/******************************************** First Escalation on day 4 ******************************************************/
			Integer DAY_FOR_FIRST_ESC;
			if(!isWeekend(dt.addDays(3).format('EEEE'))) {
				DAY_FOR_FIRST_ESC = 4;
			} else if(dt.addDays(3).format('EEEE') == 'Saturday') {
				DAY_FOR_FIRST_ESC = 6;
			} else if(dt.addDays(3).format('EEEE') == 'Sunday') {
				DAY_FOR_FIRST_ESC = 5;
			}

			

			if(DAY_FOR_FIRST_ESC != NULL) {
				CRON_EXP_FOR_FIRST_ESC_DAY_FOUR = getCRON_Expression(DAY_FOR_FIRST_ESC);//'0 0 0 ' + DAY_FOR_FIRST_ESC + ' * ? *';


				/******************************************** Second Escalation on day 5/6 ******************************************************/
				Integer FIRST_DAY_FOR_SECOND_ESC;
				if(!isWeekend(dt.addDays(DAY_FOR_FIRST_ESC).format('EEEE'))) {
					FIRST_DAY_FOR_SECOND_ESC = DAY_FOR_FIRST_ESC + 1;
				} else if(dt.addDays(DAY_FOR_FIRST_ESC).format('EEEE') == 'Saturday') {
					FIRST_DAY_FOR_SECOND_ESC = DAY_FOR_FIRST_ESC + 3;
				} else if(dt.addDays(DAY_FOR_FIRST_ESC).format('EEEE') == 'Sunday') {
					FIRST_DAY_FOR_SECOND_ESC = DAY_FOR_FIRST_ESC + 2;
				}

				

				if(FIRST_DAY_FOR_SECOND_ESC != NULL) {
					CRON_EXP_FOR_SECOND_ESC_DAY_FIVE = getCRON_Expression(FIRST_DAY_FOR_SECOND_ESC);//'0 0 0 ' + FIRST_DAY_FOR_SECOND_ESC + ' * ? *';

					Integer SECOND_DAY_FOR_SECOND_ESC;
					if(!isWeekend(dt.addDays(FIRST_DAY_FOR_SECOND_ESC).format('EEEE'))) {
						SECOND_DAY_FOR_SECOND_ESC = FIRST_DAY_FOR_SECOND_ESC + 1;
					} else if(dt.addDays(FIRST_DAY_FOR_SECOND_ESC).format('EEEE') == 'Saturday') {
						SECOND_DAY_FOR_SECOND_ESC = FIRST_DAY_FOR_SECOND_ESC + 3;
					} else if(dt.addDays(FIRST_DAY_FOR_SECOND_ESC).format('EEEE') == 'Sunday') {
						SECOND_DAY_FOR_SECOND_ESC = FIRST_DAY_FOR_SECOND_ESC + 2;
					}

					

					if(SECOND_DAY_FOR_SECOND_ESC != NULL) {
						CRON_EXP_FOR_SECOND_ESC_DAY_SIX = getCRON_Expression(SECOND_DAY_FOR_SECOND_ESC);//'0 0 0 ' + SECOND_DAY_FOR_SECOND_ESC + ' * ? *';


						/******************************************** Final Escalation on day 7/8/9/10 ******************************************************/

						Integer FIRST_DAY_FOR_FINAL_ESC;
						if(!isWeekend(dt.addDays(SECOND_DAY_FOR_SECOND_ESC).format('EEEE'))) {
							FIRST_DAY_FOR_FINAL_ESC = SECOND_DAY_FOR_SECOND_ESC + 1;
						} else if(dt.addDays(SECOND_DAY_FOR_SECOND_ESC).format('EEEE') == 'Saturday') {
							FIRST_DAY_FOR_FINAL_ESC = SECOND_DAY_FOR_SECOND_ESC + 3;
						} else if(dt.addDays(SECOND_DAY_FOR_SECOND_ESC).format('EEEE') == 'Sunday') {
							FIRST_DAY_FOR_FINAL_ESC = SECOND_DAY_FOR_SECOND_ESC + 2;
						}

						
						if(FIRST_DAY_FOR_FINAL_ESC != NULL) {
							CRON_EXP_FOR_FINAL_ESC_DAY_SEVEN = getCRON_Expression(FIRST_DAY_FOR_FINAL_ESC);//'0 0 0 ' + FIRST_DAY_FOR_FINAL_ESC + ' * ? *';

							Integer SECOND_DAY_FOR_FINAL_ESC;
							if(!isWeekend(dt.addDays(FIRST_DAY_FOR_FINAL_ESC).format('EEEE'))) {
								SECOND_DAY_FOR_FINAL_ESC = FIRST_DAY_FOR_FINAL_ESC + 1;
							} else if(dt.addDays(FIRST_DAY_FOR_FINAL_ESC).format('EEEE') == 'Saturday') {
								SECOND_DAY_FOR_FINAL_ESC = FIRST_DAY_FOR_FINAL_ESC + 3;
							} else if(dt.addDays(FIRST_DAY_FOR_FINAL_ESC).format('EEEE') == 'Sunday') {
								SECOND_DAY_FOR_FINAL_ESC = FIRST_DAY_FOR_FINAL_ESC + 2;
							}


							if(SECOND_DAY_FOR_FINAL_ESC != NULL) {
								CRON_EXP_FOR_FINAL_ESC_DAY_EIGHT = getCRON_Expression(SECOND_DAY_FOR_FINAL_ESC);//'0 0 0 ' + SECOND_DAY_FOR_FINAL_ESC + ' * ? *';

								Integer THIRD_DAY_FOR_FINAL_ESC;
								if(!isWeekend(dt.addDays(SECOND_DAY_FOR_FINAL_ESC).format('EEEE'))) {
									THIRD_DAY_FOR_FINAL_ESC = SECOND_DAY_FOR_FINAL_ESC + 1;
								} else if(dt.addDays(SECOND_DAY_FOR_FINAL_ESC).format('EEEE') == 'Saturday') {
									THIRD_DAY_FOR_FINAL_ESC = SECOND_DAY_FOR_FINAL_ESC + 3;
								} else if(dt.addDays(SECOND_DAY_FOR_FINAL_ESC).format('EEEE') == 'Sunday') {
									THIRD_DAY_FOR_FINAL_ESC = SECOND_DAY_FOR_FINAL_ESC + 2;
								}

								
								if(THIRD_DAY_FOR_FINAL_ESC != NULL) {
									CRON_EXP_FOR_FINAL_ESC_DAY_NINE = getCRON_Expression(THIRD_DAY_FOR_FINAL_ESC);//'0 0 0 ' + THIRD_DAY_FOR_FINAL_ESC + ' * ? *';


									Integer FOURTH_DAY_FOR_FINAL_ESC;
									if(!isWeekend(dt.addDays(THIRD_DAY_FOR_FINAL_ESC).format('EEEE'))) {
										FOURTH_DAY_FOR_FINAL_ESC = THIRD_DAY_FOR_FINAL_ESC + 1;
									} else if(dt.addDays(THIRD_DAY_FOR_FINAL_ESC).format('EEEE') == 'Saturday') {
										FOURTH_DAY_FOR_FINAL_ESC = THIRD_DAY_FOR_FINAL_ESC + 3;
									} else if(dt.addDays(THIRD_DAY_FOR_FINAL_ESC).format('EEEE') == 'Sunday') {
										FOURTH_DAY_FOR_FINAL_ESC = THIRD_DAY_FOR_FINAL_ESC + 2;
									}
                                    
                                    
                                    if(FOURTH_DAY_FOR_FINAL_ESC != NULL) {
										CRON_EXP_FOR_FINAL_ESC_DAY_TEN = getCRON_Expression(FOURTH_DAY_FOR_FINAL_ESC);//'0 0 0 ' + FOURTH_DAY_FOR_FINAL_ESC + ' * ? *';


										/******************************************** No Response ******************************************************/
										Integer DAY_FOR_NO_RESPONSE;
										if(!isWeekend(dt.addDays(FOURTH_DAY_FOR_FINAL_ESC).format('EEEE'))) {
											DAY_FOR_NO_RESPONSE = FOURTH_DAY_FOR_FINAL_ESC + 1;
										} else if(dt.addDays(FOURTH_DAY_FOR_FINAL_ESC).format('EEEE') == 'Saturday') {
											DAY_FOR_NO_RESPONSE = FOURTH_DAY_FOR_FINAL_ESC + 3;
										} else if(dt.addDays(FOURTH_DAY_FOR_FINAL_ESC).format('EEEE') == 'Sunday') {
											DAY_FOR_NO_RESPONSE = FOURTH_DAY_FOR_FINAL_ESC + 2;
										}

										if(DAY_FOR_NO_RESPONSE != NULL) {
											CRON_EXP_FOR_NO_RESPONSE_DAY_ELEVEN = getCRON_Expression(DAY_FOR_NO_RESPONSE);//'0 0 0 ' + DAY_FOR_NO_RESPONSE + ' * ? *';
										}

									}
								}
							}
						}
					}
				}
			}

		}


		if(CRON_EXP_FOR_INITIAL_CREATION != NULL) {
			System.schedule('TEST_DM_SCMD_Monthly_CREATION_DAY 1', CRON_EXP_FOR_INITIAL_CREATION, new DM_SCMD_Monthly_CreationScheduler());
		}

		if(CRON_EXP_FOR_FIRST_ESC_DAY_FOUR != NULL) {
			System.schedule('TEST_DM_SCMD_FIRST_ESCALATION_DAY 4', CRON_EXP_FOR_FIRST_ESC_DAY_FOUR, new DM_SCMD_FirstEscalation_Scheduler());
		}

		if(CRON_EXP_FOR_SECOND_ESC_DAY_FIVE != NULL) {
			System.schedule('TEST_DM_SCMD_SECOND_ESCALATION_Day 5', CRON_EXP_FOR_SECOND_ESC_DAY_FIVE, new DM_SCMD_SecondEscalation_Scheduler());
		}
		if(CRON_EXP_FOR_SECOND_ESC_DAY_SIX != NULL) {
			System.schedule('TEST_DM_SCMD_SECOND_ESCALATION_Day 6', CRON_EXP_FOR_SECOND_ESC_DAY_SIX, new DM_SCMD_SecondEscalation_Scheduler());
		}
		if(CRON_EXP_FOR_FINAL_ESC_DAY_SEVEN != NULL) {
			System.schedule('TEST_DM_SCMD_FINAL_ESCALATION_Day 7', CRON_EXP_FOR_FINAL_ESC_DAY_SEVEN, new DM_SCMD_FinalEscalation_Scheduler());
		}
		if(CRON_EXP_FOR_FINAL_ESC_DAY_EIGHT != NULL) {
			System.schedule('TEST_DM_SCMD_FINAL_ESCALATION_Day 8', CRON_EXP_FOR_FINAL_ESC_DAY_EIGHT, new DM_SCMD_FinalEscalation_Scheduler());
		}
		if(CRON_EXP_FOR_FINAL_ESC_DAY_NINE != NULL) {
			System.schedule('TEST_DM_SCMD_FINAL_ESCALATION_Day 9', CRON_EXP_FOR_FINAL_ESC_DAY_NINE, new DM_SCMD_FinalEscalation_Scheduler());
		}
		if(CRON_EXP_FOR_FINAL_ESC_DAY_TEN != NULL) {
			System.schedule('TEST_DM_SCMD_FINAL_ESCALATION_Day 10', CRON_EXP_FOR_FINAL_ESC_DAY_TEN, new DM_SCMD_FinalEscalation_Scheduler());
		}
		if(CRON_EXP_FOR_NO_RESPONSE_DAY_ELEVEN != NULL) {
			System.schedule('TEST_DM_SCMD_NO_RESPONSE_Day 11', CRON_EXP_FOR_NO_RESPONSE_DAY_ELEVEN, new DM_SCMD_NoResponse_Scheduler());
		}
	}

	private String getCRON_Expression(Integer day) {
		return '0 0 0 ' + day +' '+d.month()+ ' ? *';
	}

	private static Boolean isWeekend(String day) {
		return weekendDays.contains(day);
	}
}