global with sharing class SendAccountContractforReviewController{
    public Opportunity opp{get;set;}
    public Account acc{get;set;}
    public Decimal amt;
    public Parley_Pro_Contract__c ppContract;
    public Contract stdContract;
    public String bool {get;set;}
    public String opportunityId ;
    public String accountId;
    public String res ;
    public String templateId {get;set;}
    public String NegId {get;set;}
    public String email {get;set;}
    public String status {get;set;}
    public String opportunityName {get;set;}
    public String attachmentId {get;set;}
    public Attachment objAttachment {get;set;}
    public String accountName {get;set;}
    public boolean Spinnerbool {get;set;}
    public String Message {get;set;}
    global SendAccountContractforReviewController(ApexPages.StandardController controller) {
        //Amount assumed 0
        //Due date assumed 31/05/2018
        bool = 'true';
        res = '';
        email = '';
        Message = '';
        Spinnerbool = false;
        acc = new Account();
        if(ApexPages.currentPage().getParameters().get('accountName') != null)
        accountName = ApexPages.currentPage().getParameters().get('accountName');
        
        status = ApexPages.currentPage().getParameters().get('status');
        
        templateId = ApexPages.currentPage().getParameters().get('templateId');
        
        NegId = ApexPages.currentPage().getParameters().get('chiefNegotiatorId');
        
        email = ApexPages.currentPage().getParameters().get('email');
        
        if(ApexPages.currentPage().getParameters().get('oppId') != null){
            opportunityId = ApexPages.currentPage().getParameters().get('oppId');
        }else if(ApexPages.currentPage().getParameters().get('accId') != null){
            accountId = ApexPages.currentPage().getParameters().get('accId');
        }
        
          if(ApexPages.currentPage().getParameters().get('attId') != null)
            attachmentId = ApexPages.currentPage().getParameters().get('attId');
                       
      
        if(accountId != null){
            acc = [SELECT Id,Name,CreatedDate FROM Account WHERE Id=:AccountId];   
        }                  
    }
    public void createContract(){
        //create contact according to checkbox condition
        system.debug('IN Method');
        Parley_Pro_Checkbox_Setting__c objParleyParleyProCheckboxSetting  = Parley_Pro_Checkbox_Setting__c.getinstance('IsContract');    
        if(objParleyParleyProCheckboxSetting.IsContract__c == false){    
            ppContract =  ParleyProNewContractController.newPPContract(acc.Id,accountName);
        }else{
            stdContract  = ParleyProNewContractController.newContract(acc.Id,accountName);
        }
    }
   
    public PageReference onSamePageLoad()
    {             
            if(ppContract != null && stdContract == null){
              system.debug('1');
                res = ParleyProNewContractController.createContractCallout(accountName,acc.Id,0,acc.Id,acc.CreatedDate.getTime(),ppContract.Id,templateId,NegId,email,Status,attachmentId);
            }else if (ppContract == null && stdContract != null) {
              system.debug('2');
                res = ParleyProNewContractController.createContractCallout(accountName,acc.Id,0,acc.Id,acc.CreatedDate.getTime(),stdContract.Id,templateId,NegId,email,Status,attachmentId);        
            }
            if(res == '' || res == null){
                if(ppContract != null && stdContract == null){
                    List<Parley_Pro_Contract__c> parleyContractList = [SELECT Id,Name,Parley_Pro_Contract_ID__c FROM  Parley_Pro_Contract__c WHERE Id =: ppContract.Id]; 
                     if(Parley_Pro_Contract__c.sObjectType.getDescribe().isDeletable()){  
                delete  parleyContractList;    
                }          
                }else if (ppContract == null && stdContract != null) {
                    List<Contract> standardContractList = [SELECT Id,Name,Contract_ID__c FROM  Contract WHERE Id =: stdContract.Id];  
                    if(Contract.sObjectType.getDescribe().isDeletable()){   
                delete standardContractList;  
                }          
                }
                               
                Message = 'failed';
                Spinnerbool = true;
                 bool = 'false';
                return null;
            }
             else if(res.contains('http')){           
                PageReference sendToPage = new PageReference(res);
                sendToPage.setRedirect(false);
                return sendToPage; 
                
            }
            else{           
                Spinnerbool = true;
                Message = 'Success';
                bool = 'false';
                return null;
            }
    }
    
    public pageReference ReviewContractonParley(){
        
        ParleyProSetups__c objCS = ParleyProSetups__c.getOrgDefaults();
        String urlToParley = objCS.Webapp_URL__c+'/contracts/'+res+'/docs';
        //String urlToParley  = 'https://newlife.parleypro.com/#/contracts/7dcb7e7c-fdaa-4e52-b15c-c026ad13ca06/docs';
        PageReference sendToPage = new PageReference(urlToParley);
        sendToPage.setRedirect(false);
        return sendToPage;
    }
    
     public pageReference backToRecord(){
        
       
        return new Pagereference('/'+accountId);
    }
}