public Class checkRecursive{
    private static boolean run = true;
    public static void stopTrigger(){
       run = false;
    }
    public static boolean runOnce(){
    
     return run;
    
    }
}