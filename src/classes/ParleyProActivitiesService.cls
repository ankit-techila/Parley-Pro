@RestResource(urlMapping='/activities/*')
global with sharing class ParleyProActivitiesService
{
    static Map<String,String> subjectMap = new Map<String,String>{
        'NEW' => 'In Draft',
        'REVIEWING' => 'In Internal Review', 
        'SIGNING' => 'In Signature', 
        'SIGNED' => 'Signed',
        'EXECUTED' => 'Completed',
        'CANCELLED' => 'Cancelled',
        'NEGOTIATING' => 'In Negotiation',
        'NAPPROVING' => 'In Approval',
        'NAPPROVED' => 'Approved',
        'NSIGNING' => 'In Signature',
        'NSIGNED' => 'Signed',
        'NEXECUTED' => 'Completed',
        'NCANCELLED' => 'Cancelled'};
        
   @HttpPost 
     global static void addActivity(String subject, String opportunityId, String ownerId){
         
        List<Opportunity> opps = new List<Opportunity>();
        List<Account> accts = new List<Account>();  
        list<Contract> listCon = new list<Contract>();
        list<Parley_Pro_Contract__c> listparleyCon = new list<Parley_Pro_Contract__c>();
        String sObjectName = '';
        String IdPrefix = String.valueOf(opportunityId).substring(0,3);
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
        
         for(Schema.SObjectType stype : gd.values()){        
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String prefix = r.getKeyPrefix();            
            if(prefix!=null && prefix.equals(IdPrefix)){
                    sObjectName = r.getName();                   
                    break;
                }
            }
            Parley_Pro_Checkbox_Setting__c objParleyParleyProCheckboxSetting  = Parley_Pro_Checkbox_Setting__c.getinstance('IsContract');          
            if(objParleyParleyProCheckboxSetting.IsContract__c == true){
                  if(sObjectName == 'Opportunity'){
                      listCon = new list<Contract>();
                        opps = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :opportunityId];      
                        listCon = [Select Id, Status from Contract where Opportunity__c =:opportunityId order by createddate desc Limit 1];
                        system.debug('listCon'+listCon[0]);
                        listCon[0].Status = translate(subject);
                         system.debug('listCon'+listCon);
                        update listCon;
                  }else if (sObjectName == 'Account'){
                        listCon = new list<Contract>();
                        accts = [SELECT Id, OwnerId FROM Account WHERE Id = :opportunityId];              
                        listCon = [Select Id, Status from Contract where AccountId =:opportunityId order by createddate desc Limit 1];
                        listCon[0].Status = translate(subject);
                        update listCon;
                    }
            } else{
                 if(sObjectName == 'Opportunity'){
                         listparleyCon = new list<Parley_Pro_Contract__c>();
                        opps = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :opportunityId];      
                        listparleyCon = [Select Id, Status__c from Parley_Pro_Contract__c where Opportunity__c =:opportunityId order by createddate desc Limit 1];
                        listparleyCon[0].Status__c = translate(subject);
                        update listparleyCon;
                  }else if (sObjectName == 'Account'){
                          listparleyCon = new list<Parley_Pro_Contract__c>();
                        accts = [SELECT Id, OwnerId FROM Account WHERE Id = :opportunityId];              
                        listparleyCon = [Select Id, Status__c from Parley_Pro_Contract__c where Account__c =:opportunityId order by createddate desc Limit 1];
                        listparleyCon[0].Status__c = translate(subject);
                        update listparleyCon;
                    }
            }                           
                Task objTask = new Task();
            if(sObjectName == 'Account'){
                objTask.whatID = accts[0].Id;
                objTask.Ownerid = accts[0].OwnerID;
            }else if(sObjectName == 'Opportunity'){
                objTask.whatID = opps[0].Id;
                objTask.Ownerid = opps[0].OwnerID;
            }            
            objTask.Subject = translate(subject);
            objTask.Type = 'Parley Pro';
            objTask.Status = 'Action Completed';
            objTask.ActivityDate = date.today();
            //insert objTask;
        }        
    public static String translate(String subject) {
        return subjectMap.get(subject);
    }
}