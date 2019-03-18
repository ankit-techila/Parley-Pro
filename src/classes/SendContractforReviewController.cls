global with sharing class SendContractforReviewController{
    public Opportunity opp;
    public Account acc;
    public Decimal amt;
    public Parley_Pro_Contract__c ppContract;
    public Contract stdContract;
    public String bool {get;set;}
    public String opportunityId ;
    public String accountId;
    public String res ;
    public String templateId;
    public String NegId;
    public String email;
    public String status;
    public String opportunityName;
    public String fileName;
    public String counterparty;
    public String attachmentId;
    public Attachment objAttachment;
    public boolean Spinnerbool {get;set;}
    public String Message {get;set;}
    
    global SendContractforReviewController(ApexPages.StandardController controller) {
        //Amount assumed 0
        //Due date assumed 31/05/2018
        bool = 'true';
        res = '';
        Message = '';
        Spinnerbool = false;
        status = ApexPages.currentPage().getParameters().get('status');
        if(ApexPages.currentPage().getParameters().get('attId') != null)
            attachmentId = ApexPages.currentPage().getParameters().get('attId');        
    
        templateId = ApexPages.currentPage().getParameters().get('templateId');
        
        NegId = ApexPages.currentPage().getParameters().get('chiefNegotiatorId');
       
        email = ApexPages.currentPage().getParameters().get('email');
        
        opportunityName = ApexPages.currentPage().getParameters().get('opp'); 
            
        if(ApexPages.currentPage().getParameters().get('oppId') != null){
            opportunityId = ApexPages.currentPage().getParameters().get('oppId');
        }else if(ApexPages.currentPage().getParameters().get('accId') != null){
            accountId = ApexPages.currentPage().getParameters().get('accId');
        }
        
        if(opportunityId != null )
            opp = [Select Id, Name, Amount,CloseDate, AccountId, CreatedDate From opportunity Where Id =: opportunityId ];
        if(opp.AccountId != null){
            acc = [SELECT Id,Name FROM Account WHERE Id=:opp.AccountId];   
        }    
        Decimal amtR = opp.Amount; 
        amt = 0; 
        if(amtR == null){ 
            amt = 0; 
        } 
        else { 
            amt = amtR; 
        } 
        
    }
    public void createContract(){
        //create contact according to checkbox condition
        system.debug('IN Method');
        Parley_Pro_Checkbox_Setting__c objParleyParleyProCheckboxSetting  = Parley_Pro_Checkbox_Setting__c.getinstance('IsContract');    
        if(objParleyParleyProCheckboxSetting.IsContract__c == false){    
            ppContract =  ParleyProNewContractController.newPPContract(opp.Id,opportunityName);
        }else{
            stdContract  = ParleyProNewContractController.newContract(opp.Id,opportunityName);
        }
    }
    
    public PageReference onSamePageLoad()
    {  
        if(opp.AccountId == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Account');
            ApexPages.addMessage(myMsg);            
        }else{
            date d = opp.CloseDate;
            String s = d.format();
            datetime dt =DateTime.newInstance(d.year(), d.month(), d.day());
            system.debug('dt--->'+dt);
            if(ppContract != null && stdContract == null){
                system.debug('1');
                res = ParleyProNewContractController.createContractCallout(opportunityName,opp.Id,amt,opp.AccountId,dt.getTime(),ppContract.Id,templateId,NegId,email,Status,attachmentId);
            }else if (ppContract == null && stdContract != null) {
                system.debug('2');              
                res = ParleyProNewContractController.createContractCallout(opportunityName,opp.Id,amt,opp.AccountId,dt.getTime(),stdContract.Id,templateId,NegId,email,status,attachmentId);        
            }
            if((res == '' || res == null)){
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
                           
                bool = 'false';
                Message = 'failed';
                Spinnerbool = true;
                return null;
            }
            else if(res.contains('http')){              
                PageReference sendToPage = new PageReference(res);
                sendToPage.setRedirect(false);
                return sendToPage; 
                
            }
            else{               
                bool = 'false';
                Spinnerbool = true;
                Message = 'Success';
                return null;
            }
        }
        return null;
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
        return new Pagereference('/'+opportunityId);
    }
}