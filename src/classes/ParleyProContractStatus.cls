@RestResource(urlMapping='/ContractStatus/*')
global with sharing class ParleyProContractStatus
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
    global static void addContractStatus(String subject, String ownerId, String sfdcContractId){   
        try{
        String body='';
         body += 'subject '+subject;
         body += ' ownerId '+ownerId;
         body += ' sfdcContractId '+sfdcContractId;
        if(sfdcContractId.subString(0,3) == '800'){
            List<Contract> stdConList = new List<Contract>(); 
            if(Schema.sObjectType.Contract.fields.Id.isAccessible() && Schema.sObjectType.Contract.fields.Status.isAccessible()) {
                stdConList = [Select Id, Status from Contract where Id =: sfdcContractId]; 
            }  
            if(stdConList.size() > 0)
                if(Schema.sObjectType.Contract.fields.Status.isAccessible() || Schema.sObjectType.Contract.fields.Status.isCreateable() || Schema.sObjectType.Contract.fields.Status.isUpdateable()) {
                    stdConList[0].Status = translate(subject);
                }
                body += ' stdConList '+stdConList;
            update stdConList;
        }else if (sfdcContractId.subString(0,3) != '800'){
            List<Parley_Pro_Contract__c> ppConList = new List<Parley_Pro_Contract__c>(); 
            if(Schema.sObjectType.Parley_Pro_Contract__c.fields.Id.isAccessible() && Schema.sObjectType.Parley_Pro_Contract__c.fields.Status__c.isAccessible()) {           
                ppConList = [Select Id, Status__c from Parley_Pro_Contract__c WHERE Id =: sfdcContractId];
            }
            if(ppConList.size() > 0){
                if(Schema.sObjectType.Parley_Pro_Contract__c.fields.Status__c.isAccessible() || Schema.sObjectType.Parley_Pro_Contract__c.fields.Status__c.isCreateable() || Schema.sObjectType.Parley_Pro_Contract__c.fields.Status__c.isUpdateable()) {
                    ppConList[0].Status__c = translate(subject);
                }
            }
            body += ' ppConList '+ppConList;
            update ppConList;
        }
       /* List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'ankit@techilaservices.com'};
        message.subject = 'Contract update status email';
        //String body = 'Hi,';
       // body+='\n';
        //body+='\n';
        //body+= mapEmailRes;
        message.setplaintextbody(body);
        mails.add(message);
        if(!Test.isRunningTest())
          Messaging.sendEmail(mails); */  
       }
       catch(Exception e)
       {
          /* List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'ankit@techilaservices.com'};
        message.subject = 'Contract update status email';
        //String body = 'Hi,';
       // body+='\n';
        //body+='\n';
        //body+= mapEmailRes;
        message.setplaintextbody(e.getMessage());
        mails.add(message);
        if(!Test.isRunningTest())
          Messaging.sendEmail(mails);*/
       }      
    }     
    public static String translate(String subject) {
        return subjectMap.get(subject);
    }
}