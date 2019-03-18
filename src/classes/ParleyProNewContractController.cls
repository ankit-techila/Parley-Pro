global with sharing class ParleyProNewContractController {
    
    public static ParleyProSetups__c config {get;set;}
    public List<fromJSON.cls_templates> templatesList = new List<fromJSON.cls_templates>();
    public List<fromJSON.cls_Users> NegotiatorsList = new List<fromJSON.cls_Users>();
    public String selectedTemplates{get;set;}
    public String selectedNegotiator{get;set;}
    public String oppId;
    public String accId;
    public Boolean bool {get;set;}
    public Parley_Pro_Checkbox_Setting__c objParelyCheckboxCustomsetting{get;set;}
    public Opportunity objopportunity{get;set;}
    public String oppName {get;set;}
    public Account objAccount {get;set;}
    public String accountName {get;set;}
    public String accountName1 {get;set;}
    public String accountName2 {get;set;}
    public String accountName3 {get;set;}
    public String accountName4 {get;set;}
    public String selectedTab {get;set;}
    public boolean customsettingvalue {get;set;}
    public String tempId;
    public String NegId;
    public OpportunityContactRole objContactRole{get;set;}
    public AccountContactRole objAccountContactRole{get;set;}
    public List<SelectOption> options {get;set;}
    public List<SelectOption> options1 {get;set;}
    public static String email{get;set;}
    public String emails{get;set;}
    public Boolean docBool{get;set;}
    public String StageName;
    public Boolean sendforSignature {get;set;}
    public Boolean requestContract {get;set;}
    public Boolean NegotiateContract {get;set;}
    public Boolean internalReview{get;set;}
    public Boolean thirdPartyPaper{get;set;}
    public String fileName {get; set;}
    public String base64 {get;set;}
    public static transient String attachmentbody {get;set;}
    public static transient blob payloadBlob {get;set;}
    
    
    public static ParleyProSetups__c getConfig(){
        if (config == null){
            config = ParleyProSetups__c.getOrgDefaults();
        }
        return config;
    }
    
    public string apiKey{
        get {return getConfig().API_Key__c;} 
        set {getConfig().API_Key__c = value;}
    }
    public string serverURL{
        get {return getConfig().BackendURL__c;} 
        set {getConfig().BackendURL__c = value;}
    }
    
    public string webAppURL{
        get {return getConfig().Webapp_URL__c;} 
        set {getConfig().Webapp_URL__c = value;}
    }
    
    global ParleyProNewContractController (ApexPages.StandardController sc){
        options = new List<SelectOption> ();
        options1 = new List<SelectOption> ();
        objopportunity = new opportunity();
        objAccount = new Account();
        oppName = '';
        bool = false;
        if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id').startsWith('006'))
        oppId = ApexPages.currentPage().getParameters().get('id');
        else if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id').startsWith('001'))
        accId = ApexPages.currentPage().getParameters().get('id');
        accountName1 = '';
        accountName2 = '';
        accountName3 = '';
        accountName4 = '';
        StageName = '';
        email = '';
        objParelyCheckboxCustomsetting = new Parley_Pro_Checkbox_Setting__c();
        objParelyCheckboxCustomsetting = [SELECT Id,IsContract__c,X3rd_Party_Paper__c,Internal_Review__c,Negotiate_Contract__c,Request_Contract__c,Send_for_Signature__c FROM Parley_Pro_Checkbox_Setting__c];
        sendforSignature = objParelyCheckboxCustomsetting.Send_for_Signature__c;
        requestContract = objParelyCheckboxCustomsetting.Request_Contract__c;
        NegotiateContract = objParelyCheckboxCustomsetting.Negotiate_Contract__c;
        internalReview = objParelyCheckboxCustomsetting.Internal_Review__c;
        thirdPartyPaper = objParelyCheckboxCustomsetting.X3rd_Party_Paper__c;
        customsettingvalue = objParelyCheckboxCustomsetting.IsContract__c;
        objContactRole = new OpportunityContactRole();
        objAccountContactRole = new AccountContactRole();     
        try{
            if(oppId != null && oppId.startsWith('006')){
                objopportunity = [SELECT Id, Name FROM Opportunity WHERE Id=: oppId LIMIT 1];
                oppName = objopportunity.Name;
                objContactRole = [SELECT Id, Opportunity.Name, Contact.Email, Contact.Name, Role, isPrimary FROM OpportunityContactRole Where OpportunityId =: oppId AND Isprimary = true LIMIT 1];
            }else if(accId != null && accId.startsWith('001')){
                objAccount = [SELECT Id, Name FROM Account WHERE Id =: accId LIMIT 1];                    
                accountName1 = objAccount.Name;
                accountName2 = objAccount.Name;
                accountName3 = objAccount.Name;
                accountName4 = objAccount.Name;
                accountName = objAccount.Name;
                objAccountContactRole = [SELECT Id, Account.Name, Contact.Email, Contact.Name, Role, isPrimary FROM AccountContactRole Where AccountId =: accId AND Isprimary = true LIMIT 1];
            }
        }catch(exception e){
        }
    }
    
    public ParleyProNewContractController (){     
        objParelyCheckboxCustomsetting = new Parley_Pro_Checkbox_Setting__c();
        objParelyCheckboxCustomsetting = [SELECT Id,IsContract__c,X3rd_Party_Paper__c,Internal_Review__c,Negotiate_Contract__c,Request_Contract__c,Send_for_Signature__c FROM Parley_Pro_Checkbox_Setting__c];
        sendforSignature = objParelyCheckboxCustomsetting.Send_for_Signature__c;
        requestContract = objParelyCheckboxCustomsetting.Request_Contract__c;
        NegotiateContract = objParelyCheckboxCustomsetting.Negotiate_Contract__c;
        internalReview = objParelyCheckboxCustomsetting.Internal_Review__c;
        thirdPartyPaper = objParelyCheckboxCustomsetting.X3rd_Party_Paper__c;
        customsettingvalue = objParelyCheckboxCustomsetting.IsContract__c;
    }
    
    public pageReference saveSettings() {
        Parley_Pro_Checkbox_Setting__c objParelyCustomsetting = Parley_Pro_Checkbox_Setting__c.getInstance('IsContract');
        if(Schema.sObjectType.Parley_Pro_Checkbox_Setting__c.fields.IsContract__c.isCreateable() || Schema.sObjectType.Parley_Pro_Checkbox_Setting__c.fields.IsContract__c.isUpdateable() || Schema.sObjectType.Parley_Pro_Checkbox_Setting__c.fields.IsContract__c.isAccessible()) {
            objParelyCustomsetting.IsContract__c = customsettingvalue;
            objParelyCustomsetting.Send_for_Signature__c = sendforSignature;
            objParelyCustomsetting.Request_Contract__c= requestContract;
            objParelyCustomsetting.Negotiate_Contract__c= NegotiateContract;
            objParelyCustomsetting.Internal_Review__c = internalReview;
            objParelyCustomsetting.X3rd_Party_Paper__c = thirdPartyPaper;
        }
        update objParelyCustomsetting ;
        upsert config;
        return null;
    }
    
    
    public void getContractName(){     
        String tempName = '';      
        accountName1 = '';
        accountName2 = '';
        accountName3 = '';
        accountName4 = '';
        bool = true;
       for (SelectOption so : options){
            if (so.getValue() == selectedTemplates){
                tempName = so.getLabel();
            }
        }
        
        tempId = selectedTemplates;
        NegId = selectedNegotiator; 
         system.debug('selectedTemplates'+selectedTemplates);
        system.debug('selectedNegotiator'+selectedNegotiator);   
         if(selectedTab == null || selectedTab == 'first_tab__item'){
               StageName = 'SIGN';
            }else if(selectedTab == 'second_tab__item'){             
                StageName = 'DRAFT';              
            }
            else if(selectedTab == 'third_tab__item'){             
                StageName = 'NEGOTIATE';
            }
            else if(selectedTab == 'fourth_tab__item'){            
                StageName = 'REVIEW';
            }
             else if(selectedTab == 'fifth_tab__item'){            
                StageName = 'DRAFT';
            }
            
        if((selectedTab == null || selectedTab == 'first_tab__item') && tempName != null){
                accountName1 = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;
                accountName = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;
            }else if(selectedTab == 'second_tab__item'  && tempName != null){
                accountName2 = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;
                accountName =tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;              
            }
            else if(selectedTab == 'third_tab__item' && tempName != null){
                accountName3 = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;
                accountName = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;
                docBool = false;              
            }
            else if(selectedTab == 'fourth_tab__item' && tempName != null){
                accountName4 = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name;
                accountName = tempName != ''?objAccount.Name+' '+'-'+' '+tempName : objAccount.Name; 
                docBool = false;           
            }                              
        else if(selectedTemplates == null && selectedTemplates == '--None--' && selectedNegotiator != null){
            accountName1 = objAccount.Name; 
            accountName2 = objAccount.Name; 
            accountName3 = objAccount.Name; 
            accountName4 = objAccount.Name;
            accountName = objAccount.Name; 
        }          
    }
    
    public void getRequest(){
        // Fetch Templates
        URL url = new URL(getConfig().BackendURL__c);
        httpRequest req = new httpRequest();
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Host', url.getHost());
        req.setHeader('X-API-KEY', getConfig().API_Key__c);
        req.setEndpoint( getConfig().BackendURL__c + '/salesforce/documents/templates');
        req.setTimeout(120000);
        
        Http h = new Http();
        HTTPResponse res = new HTTPResponse();
        if(!Test.isRunningTest())
            res = h.send(req);
        else
            res.setStatusCode(200);  
        if(res.getStatusCode()==200){
            options.add(new Selectoption('--None--','--None--'));
            String jsonResponse = '';
            if(!test.isRunningTest())
            jsonResponse = res.getBody();
            else
            jsonResponse = '{ "templates": [ { "id": "d86699e6-ec6e-4b1f-a468-b849d1013b46", "name": "BeFoundOnline SOW without if2" }, { "id": "4b8553b5-49a6-4483-bf26-bba99566d511", "name": "BeFoundOnline SOW without if" } ]}';
            system.debug('jsonResponse '+jsonResponse);
            fromJSON ParserClassObj = fromJSON.parse(jsonResponse); 
            templatesList = ParserClassObj.templates;
            system.debug('templatesList '+templatesList);
            for(fromJSON.cls_templates obj : templatesList){              
                options.add(new SelectOption(obj.Id,obj.Name));
            }            
        }
        
        URL urls = new URL(getConfig().BackendURL__c);
        httpRequest request = new httpRequest();
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Host', urls.getHost());
        request.setHeader('X-API-KEY', getConfig().API_Key__c);
        request.setEndpoint( getConfig().BackendURL__c + '/salesforce/tenants/users');
        request.setTimeout(120000);
        
        Http https = new Http();
        HTTPResponse response = new HTTPResponse();
        if(!Test.isRunningTest())
            response = https.send(request);
        else
            response.setStatusCode(200);     
        if(response.getStatusCode()==200){
            options1.add(new Selectoption('--None--','--None--'));
            String jsonResponse1 = '';
            if(!Test.isRunningTest())
             jsonResponse1  =   '{"Users":'+response.getBody()+'}';
            else
             jsonResponse1 = '{"Users":[{"id":"7b12044d-d12c-44ac-9646-48ead1a1a5f0","email":"lilian+view@parleypro.com","firstName":"Lilian","lastName":"Viewer"},{"id":"0aca9ac7-d731-4485-9b04-bd7a8c6cd3ee","email":"roman+acmetest@parleypro.com","firstName":"Chandler","lastName":"Bing"},{"id":"d62d42e7-c4ee-4e84-80da-07e524f91ac0","email":"pento1988+ccn@gmail.com","firstName":"Lucy","lastName":"Johnson"},{"id":"a8576921-f27c-4d3a-95f7-310a90f47703","email":"lilian+sue@parleypro.com","firstName":"Sue","lastName":"New"},{"id":"0a381a5c-d335-4305-8e82-e2a18c3188d3","email":"lilian+nn@parleypro.com","firstName":"Greta","lastName":"Garbo"},{"id":"3dfd642f-f11a-43c7-8965-7866a8052e02","email":"tristan@parleypro.com","firstName":"Tristan","lastName":"Bing"},{"id":"425ef5ec-4874-4f80-ae6d-5b41d7680562","email":"roman+pp@parleypro.com","firstName":"Roman","lastName":"PP"},{"id":"da57c2ed-203d-4855-a307-6f6f79ed26d4","email":"roman+kem@parleypro.com","firstName":"Roman","lastName":"Kemal"},{"id":"425a0174-302a-4eff-aebc-ce0c7bc80168","email":"roman+aug5r@parleypro.com","firstName":"Roman","lastName":"Reviewer"},{"id":"42aacc39-08fb-4343-af62-72356020654d","email":"bmunroe@parleypro.com","firstName":"Bill","lastName":"Munroe"},{"id":"0f483667-7671-4047-aa34-7bcfb6a37818","email":"rodion.stolyarov@quantumsoft.ru","firstName":"Rodion","lastName":"Stolyarov"},{"id":"8204fa24-efbe-4464-87b2-eb2c121579b2","email":"saba+dev@parleypro.com","firstName":"Saba","lastName":"Mirza"},{"id":"af99eed1-a69f-46b6-b43c-0dab3a4d745a","email":"alex.demidov@quantumsoft.ru","firstName":"Alex","lastName":"Demidov"},{"id":"b99cfc70-4cf9-44fe-a5c2-150ce9dc8880","email":"victoria+@parleypro.com","firstName":"victoria","lastName":"m2"},{"id":"36f3f789-39d2-45bb-8aa2-8a24142e92d6","email":"victoria+1@parleypro.com","firstName":"Victoria","lastName":"Smith"},{"id":"b6ff81ed-b8d3-4637-a4cb-4ffe7f2d8035","email":"lilian+812@parleypro.com","firstName":"Sarah","lastName":"Gilbertson"},{"id":"bafbeedf-4c3a-40d8-88e5-ec9c4d277897","email":"alex.demidov+reviewer@quantumsoft.ru","firstName":"Alex","lastName":"Demidov CM"},{"id":"4442a631-044d-411c-8aae-b624dc478b68","email":"lilian+lc3@parleypro.com","firstName":"Lilian","lastName":"caldeira"},{"id":"54ac96a0-458c-4518-a305-8d970ea13dd6","email":"yaroslav.yarovikov@quantumsoft.ru","firstName":"John","lastName":"Smith"},{"id":"14ea603c-0161-4ffe-b422-61d882f64c4a","email":"victoria+2@parleypro.com","firstName":"Victoria","lastName":"Lopez"},{"id":"aca6e50d-e7ae-4756-95d5-0d22f589511b","email":"victoria+cm@parleypro.com","firstName":"Victoria","lastName":"CM"},{"id":"8ec2b893-2f71-4469-9a36-b5f91bbe5ba7","email":"charlie+test@parleypro.com","firstName":"Charlie","lastName":"McGillis"},{"id":"f4bc9a5e-1282-46d0-9bdf-c0df3ad64471","email":"victoria+newcn@palreypro.com"},{"id":"6948c018-e1c3-4d98-aaa0-846c9d7d558f","email":"victoria+12345@parleypro.com","firstName":"Victoria","lastName":"Smith"},{"id":"64605824-eb1b-4bb4-bb24-cc512cff6665","email":"dary.tyurina+test@gmail.com","firstName":"Dasha","lastName":"Tyurina"},{"id":"1a677610-2626-4e56-8174-bfbbf23e9d30","email":"victoria+new@parleypro.com"},{"id":"2d728f9b-a4a0-4a80-a327-1217a8ee961e","email":"victoria+newcn2@parleypro.com","firstName":"Victoria","lastName":"New CN"},{"id":"a4b3d3b7-0938-4606-abf2-120f92e75094","email":"lilian+fun1@parleypro.com","firstName":"Greta","lastName":"Garbo"},{"id":"b37be6d4-25b4-426a-8ded-bbb775997d1b","email":"victoria@parleypro.com","firstName":"Victoria","lastName":"Molokova"},{"id":"ca0fecc9-fd5e-4b38-8abc-c746e7424f7e","email":"roman+adobe@parleypro.com","firstName":"Adobe","lastName":"Review"},{"id":"f27820f9-9e27-46d1-af2f-5d2721942bf6","email":"victoria+cm+cn@parleypro.com","firstName":"Victoria","lastName":"CM+CN"},{"id":"cd9a210b-1779-480e-9990-65e846e4d4e9","email":"lilian+hybrid@parleypro.com","firstName":"Lilian","lastName":"Caldeira"}]}';
            system.debug('jsonResponse1'+jsonResponse1);
            fromJSON ParserClassObj = fromJSON.parse(jsonResponse1); 
            NegotiatorsList = ParserClassObj.Users;
            for(fromJSON.cls_Users obj : NegotiatorsList){
                options1.add(new SelectOption(obj.id,obj.firstName+' '+obj.lastName));
            }          
        }    
        
    }
    
    public static httpRequest getRequestContract() {
        URL url = new URL(getConfig().BackendURL__c);
        //Instantiate an httpRequest and set the required attributes
        httpRequest req = new httpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Host', url.getHost());
        req.setHeader('X-API-KEY', getConfig().API_Key__c);
        req.setEndpoint( getConfig().BackendURL__c + '/salesforce/contract');
        req.setTimeout(120000);
        return req;
    }
    
    public static String getRequestBody(String contractName, String sfdcContractId, String Stage, Long dueDate,Decimal amount, String OppName,String templateId, String chiefNegotiatorId, String parentId) {
        string tempId = 'cb3a8bf0-c7a6-4362-a458-8a34de8e4364';
        String chefId = '425ef5ec-4874-4f80-ae6d-5b41d7680562';
         system.debug('chiefNegotiatorId---->1 '+chiefNegotiatorId);
        Map<String, Object> params = new Map<String, Object>();
        params.put('dueDate', dueDate);
        params.put('sfdcContractId', sfdcContractId);
        params.put('ownerId', UserInfo.getUserId());
        params.put('value', 'USD ' + amount);
        // TODO: please replace with actual email address of the requester
        params.put('ownerEmail', UserInfo.getUserEmail());
       
        params.put('name', OppName);
        params.put('hybrid', false);
        String Url = String.ValueOf(URL.getOrgDomainUrl());
        Integer index = Url.indexOf('=');
        String sub = url.subString(0,index+1);
        Url = Url.remove(sub);
        url = Url.RemoveEnd(']');
        if(Stage == 'SIGN')
        params.put('returnUrl', url+'/'+parentId);
        if(Stage != null && Stage != '')
            params.put('stage', Stage);
        else
            params.put('stage', 'NEGOTIATE');
        if(templateId != null)
            params.put('templateId', templateId);
        else
            params.put('templateId', tempId);
             if(chiefNegotiatorId != null)
            params.put('chiefNegotiatorId', chiefNegotiatorId);
        else
            params.put('chiefNegotiatorId', chefId);
        params.put('counterPartyCompanyName', contractName);       
        Contract  objContract = new  Contract();
        
        if(sfdcContractId.substring(0,3)== '800'){
            if(Schema.sObjectType.Contract.fields.Id.isAccessible() && Schema.sObjectType.Contract.fields.Name.isAccessible() && Schema.sObjectType.Contract.fields.Opportunity__c.isAccessible()) {
                objContract = [Select Id,Name,AccountId, Opportunity__c FROM Contract WHERE Id=: sfdcContractId];
            }
            if(Schema.sObjectType.OpportunityContactRole.fields.OpportunityId.isAccessible() && Schema.sObjectType.OpportunityContactRole.fields.IsPrimary.isAccessible()) {
                if(objContract.Opportunity__c != null){               
                OpportunityContactRole[] OppcontactRoles = [select Contact.Email from OpportunityContactRole where OpportunityId = :objContract.Opportunity__c  and IsPrimary = true];
                processCCN(params, OppcontactRoles, objContract.Opportunity__c);
                }
                else{
                AccountContactRole[] AccountcontactRoles = [select Contact.Email from AccountContactRole where accountId = :objContract.AccountId and IsPrimary = true];
                processAccountCCN(params, AccountcontactRoles , objContract.Opportunity__c);
                }
            }          
        }else if(sfdcContractId.subString(0,3) == 'a0J'){
                Parley_Pro_Contract__c parleyContract = [SELECT Id,Name,Parley_Pro_Contract_ID__c,Opportunity__c,Account__c   FROM  Parley_Pro_Contract__c WHERE Id =: sfdcContractId];
                if(parleyContract.Opportunity__c != null){
                OpportunityContactRole[] oppcontactRoles = [select Contact.Email from OpportunityContactRole where OpportunityId = :parleyContract.Opportunity__c  and IsPrimary = true];
                 processCCN(params, oppcontactRoles , parleyContract.Opportunity__c);  
                 }
                else{
                AccountContactRole[] AccountcontactRoles = [select Contact.Email from AccountContactRole where accountId = :parleyContract.Account__c  and IsPrimary = true];               
                processAccountCCN(params, AccountcontactRoles , parleyContract.Account__c  );   
                }
                }
        String body = JSON.serialize(params);  
        return body;
    }
    
    
    public static void processCCN(Map<String, Object> params, OpportunityContactRole[] contactRoles, String account) {
        if (contactRoles.size() > 0) {
            String email = contactRoles[0].Contact.Email;
            if(email != null && email != '')
            params.put('counterPartyChiefNegotiatorEmail', email);                  
        }else{
            params.put('counterPartyChiefNegotiatorEmail', 'cp_chief@admin.com');
        }
    }    
     public static void processAccountCCN(Map<String, Object> params, AccountContactRole[] contactRoles, String account) {
        if (contactRoles.size() > 0) {
            String email = contactRoles[0].Contact.Email;
            if(email != null && email != '')
            params.put('counterPartyChiefNegotiatorEmail', email);                      
        }else {
            params.put('counterPartyChiefNegotiatorEmail', 'cp_chief@admin.com');
        }
    }    
    
    public static String parseContractId(String body) {
        System.debug('Body -> '+body);
        JSONParser parser = JSON.createParser(body);
        System.debug('parser-> '+parser);
        String contractId = '';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'id')) {
                parser.nextToken();
                contractId = parser.getText();
                break;
            }
        }
        return contractId;
    }
    
    webservice static String createContractCallout(String contractName, String parentId, Decimal amount, String account, Long dueDate, String ContractsId,String templateId, String chiefNegotiatorId, String email, String Stage, String attachmentId){
    try{
        Parley_Pro_Checkbox_Setting__c objParleyParleyProCheckboxSetting  = Parley_Pro_Checkbox_Setting__c.getinstance('IsContract');
        Account objAccount = [SELECT Id,Name FROM Account WHERE Id=: account];
        httpRequest req = getRequestContract();
        String body = '';
        System.Debug('>>>>> getRequest: ' + req);
        if(parentId.subString(0,3) == '006'){
            body = getRequestBody(objAccount.Name,ContractsId, Stage, dueDate,amount,contractName,templateId,chiefNegotiatorId,parentId);
            body = body.removeEnd('}');
            body += ',"additionalUsers":[';
            List<String> sList = new list<String>();
            if(email != null && email != '')
                sList = email.split(',');
            if(!sList.isempty()){
                for(String s : sList){
                    body +='"'+s+'",';
                }
            }
            if(body.contains(',')){
                body = body.removeEnd(',');            }
           
            body += ']';           
            if(attachmentId != null){
            Attachment objAttachment = [SELECT Id,Name,body FROM Attachment WHERE Id=: attachmentId];        
            attachmentbody = EncodingUtil.base64encode(objAttachment.body);
            objAttachment.body = EncodingUtil.base64Decode(attachmentbody);
            attachmentbody = '';
            attachmentbody = objAttachment.body.toString();
            Integer index = attachmentbody.indexOf(',');
            String sub = '';
            if (index != 0){
                sub = attachmentbody.subString(0,index+1);
            }          
            if(sub != '' && sub != null)
            attachmentbody = attachmentbody.remove(sub);
            
            String payLoadLimit = '';
             system.debug('Limits.getHeapSize()'+Limits.getHeapSize());
              system.debug('payload.length()'+attachmentbody.length());
               system.debug('Limits.getLimitHeapSize()'+Limits.getLimitHeapSize());
            if (attachmentbody.length() > 5999999) {               
                system.debug('Limits.getHeapSize()'+Limits.getHeapSize());
                payLoadLimit = attachmentbody.subString(5999999,attachmentbody.length());
                attachmentbody.remove(payLoadLimit);
            }                  
        
                body += ',"documents":[';
                body += '{"data": "'+attachmentbody+'",';
                body += '"fileName": "'+objAttachment.Name+'",';
                body += '"counterparty": '+true+'}';
                body += ']';               
            }
          
            Map<String, Schema.SObjectType> schemaMapOLI = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchemaOLI = schemaMapOLI.get('OpportunityLineItem');
            Map<String, Schema.SObjectField> fieldMapOLI = ObjectSchemaOLI.getDescribe().fields.getMap();
            DescribeSObjectResult describeResultOLI = OpportunityLineItem.getSObjectType().getDescribe();
            List<String> OLIfieldNames = new List<String>(describeResultOLI.fields.getMap().keySet());
            String queryOLI = ' SELECT ' + String.join( OLIfieldNames, ',' ) + ' FROM OpportunityLineItem WHERE opportunityId =: parentId';
            List<OpportunityLineItem> OLIList  = Database.query(queryOLI);
            system.debug('OLIList'+OLIList);
            
            if(!OLIList.isempty()){             
                body += ',"products":[';
                for(OpportunityLineItem oli : OLIList){
                    body += '{';
                    for(String fieldName: fieldMapOLI.keySet()){ 
                        Schema.DisplayType valueType = fieldMapOLI.get(fieldName).getDescribe().getType();
                        if (valueType == Schema.DisplayType.Id && oli.get(fieldName) != null){                                                 
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        }else if (valueType == Schema.DisplayType.Email && oli.get(fieldName) != null){                          
                             body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        }
                        else if(valueType == Schema.DisplayType.DateTime  && oli.get(fieldName) != null){
                            DateTime DT = (DateTime)oli.get(fieldName);                       
                            String s = DT.format('MM/dd/yyyy');                    
                            body += '"'+fieldName+'": "'+s+'",';
                        }
                        else if ((valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency) && oli.get(fieldName) != null ){
                            Decimal d = (Decimal)oli.get(fieldName);
                            String s = String.ValueOf(d);
                            body += '"'+fieldName+'": "'+s+'",';
                        }
                        else if (valueType == Schema.DisplayType.Double && oli.get(fieldName) != null){
                            Double d = (Double)oli.get(fieldName);
                            String s = String.ValueOf(d);
                            body += '"'+fieldName+'": "'+s+'",';
                        }
                        else if (valueType == Schema.DisplayType.Integer && oli.get(fieldName) != null){
                            Integer i = (Integer)oli.get(fieldName);
                            String s = String.ValueOf(i);
                            body += '"'+fieldName+'": "'+s+'",';
                        }
                        else if (valueType == Schema.DisplayType.Boolean && oli.get(fieldName) != null){
                            boolean b = (boolean)oli.get(fieldName);
                            String s = String.ValueOf(b);
                            body += '"'+fieldName+'": "'+s+'",';
                        }
                        else if (valueType == Schema.DisplayType.Date && oli.get(fieldName) != null){
                            Date d = (Date)oli.get(fieldName);
                            String s = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');                       
                            body += '"'+fieldName+'": "'+s+'",';
                        }
                        else if (valueType == Schema.DisplayType.Picklist && oli.get(fieldName) != null)                      
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        else if (valueType == Schema.DisplayType.Phone && oli.get(fieldName) != null)
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        else if (valueType == Schema.DisplayType.String && oli.get(fieldName) != null){                      
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        } 
                        else if (valueType == Schema.DisplayType.TEXTAREA && oli.get(fieldName) != null){                      
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        } 
                        else if (valueType == Schema.DisplayType.URL && oli.get(fieldName) != null){                      
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        } 
                        else if (valueType == Schema.DisplayType.REFERENCE && oli.get(fieldName) != null){                      
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';
                        }                        
                        else
                            body += '"'+fieldName+'": "'+(String)oli.get(fieldName)+'",';                  
                    }
                    if(body.contains(',')){
                        body = body.removeEnd(',');
                    }
                    body += '},';
                }
                if(body.contains(',')){
                    body = body.removeEnd(',');
                }
                body += ']';               
            }
            
            
            body += ',"properties":{';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get('Opportunity');
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            DescribeSObjectResult describeResultVehicleInventory = Opportunity.getSObjectType().getDescribe();
            List<String> VehiclefieldNames = new List<String>(describeResultVehicleInventory.fields.getMap().keySet());
            String query = ' SELECT ' + String.join( VehiclefieldNames, ',' ) + ' FROM Opportunity WHERE Id =: parentId';
            List<Opportunity> oppList  = Database.query(query);
            system.debug('oppList'+oppList);
            Map<String,string> valueMap=new Map<String,String>();
            
            for(opportunity o:oppList){
                for(String fieldName: fieldMap.keySet()){                                 
                    Schema.DisplayType valueType = fieldMap.get(fieldName).getDescribe().getType();
                        system.debug('valueType-->'+valueType);
                        system.debug('FieldValue-->'+o.get(fieldName));                 
                    if (valueType == Schema.DisplayType.Id && o.get(fieldName) != null){
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    }else if (valueType == Schema.DisplayType.Email && o.get(fieldName) != null){
                            valueMap.put(fieldName,(String)o.get(fieldName));
                    }
                    else if(valueType == Schema.DisplayType.DateTime  && o.get(fieldName) != null){
                        DateTime DT = (DateTime)o.get(fieldName);                      
                        String s = DT.format('MM/dd/yyyy');                     
                        valueMap.put(fieldName,s);
                    }
                    else if ((valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency) && o.get(fieldName) != null ){
                        Decimal d = (Decimal)o.get(fieldName);
                        String s = String.ValueOf(d);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Double && o.get(fieldName) != null){
                        Double d = (Double)o.get(fieldName);
                        String s = String.ValueOf(d);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Integer && o.get(fieldName) != null){
                        Integer i = (Integer)o.get(fieldName);
                        String s = String.ValueOf(i);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Boolean && o.get(fieldName) != null){
                        boolean b = (boolean)o.get(fieldName);
                        String s = String.ValueOf(b);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Date && o.get(fieldName) != null){
                        Date d = (Date)o.get(fieldName);
                        String s = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM-d-YYYY');                       
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Picklist && o.get(fieldName) != null)
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    else if (valueType == Schema.DisplayType.Phone && o.get(fieldName) != null)
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    else if (valueType == Schema.DisplayType.String && o.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    } 
                    else if (valueType == Schema.DisplayType.TEXTAREA && o.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    } 
                    else if (valueType == Schema.DisplayType.URL && o.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    } 
                    else if (valueType == Schema.DisplayType.REFERENCE && o.get(fieldName) != null){
                        system.debug('------>'+fieldName+(String)o.get(fieldName));
                        valueMap.put(fieldName,(String)o.get(fieldName));
                    }                        
                    else
                        valueMap.put(fieldName,(String)o.get(fieldName));                   
                }    
            }
            if(account != null){
                Map<String, Schema.SObjectType> schemaMap1 = Schema.getGlobalDescribe();
                Schema.SObjectType ObjectSchema1 = schemaMap1.get('Account');
                Map<String, Schema.SObjectField> fieldMap1 = ObjectSchema1.getDescribe().fields.getMap();
                DescribeSObjectResult describeResultAccount = objAccount.getSObjectType().getDescribe();
                List<String> accountfieldNames = new List<String>(describeResultAccount.fields.getMap().keySet());
                String query1 = ' SELECT ' + String.join( accountfieldNames, ',' ) + ' FROM Account WHERE Id =: account';            
                List<Account> accountlist  = Database.query(query1);               
                for(Account a : accountlist){
                    for(String fieldName: fieldMap1.keySet()){                          
                        Schema.DisplayType valueType = fieldMap1.get(fieldName).getDescribe().getType();                       
                        if (valueType == Schema.DisplayType.Id && a.get(fieldName) != null){
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        }else if (valueType == Schema.DisplayType.Email && a.get(fieldName) != null){
                            system.debug('email---->'+fieldName+(String)a.get(fieldName));
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        }
                        else if(valueType == Schema.DisplayType.DateTime && a.get(fieldName) != null){
                            DateTime DT = (DateTime)a.get(fieldName);                                               
                            String s = String.ValueOf(DT.format('MM/dd/yyyy'));
                            valueMap.put('account.'+fieldName,s);
                        }
                        else if ((valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency) && a.get(fieldName) != null){
                            Decimal d = (Decimal)a.get(fieldName);
                            String s = String.ValueOf(d);
                            valueMap.put('account.'+fieldName,s);
                        }
                        else if (valueType == Schema.DisplayType.Double && a.get(fieldName) != null){
                            Double d = (Double)a.get(fieldName);
                            String s = String.ValueOf(d);
                            valueMap.put('account.'+fieldName,s);
                        }
                        else if (valueType == Schema.DisplayType.Integer && a.get(fieldName) != null){
                            Integer i = (Integer)a.get(fieldName);
                            String s = String.ValueOf(i);
                            valueMap.put('account.'+fieldName,s);
                        }
                        else if (valueType == Schema.DisplayType.Boolean && a.get(fieldName) != null){
                            boolean b = (boolean)a.get(fieldName);
                            String s = String.ValueOf(b);
                            valueMap.put('account.'+fieldName,s);
                        }
                        else if (valueType == Schema.DisplayType.Date && a.get(fieldName) != null){
                            Date d = (Date)a.get(fieldName);                        
                            String s = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');                           
                            valueMap.put('account.'+fieldName,s);
                        }
                        else if (valueType == Schema.DisplayType.Picklist && a.get(fieldName) != null){                      
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        }
                        else if (valueType == Schema.DisplayType.Phone && a.get(fieldName) != null)
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        else if (valueType == Schema.DisplayType.String && a.get(fieldName) != null){                      
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        } 
                        else if (valueType == Schema.DisplayType.TEXTAREA && a.get(fieldName) != null){                      
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        } 
                        else if (valueType == Schema.DisplayType.URL && a.get(fieldName) != null){                      
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        } 
                        else if (valueType == Schema.DisplayType.REFERENCE && a.get(fieldName) != null){                      
                            valueMap.put('account.'+fieldName,(String)a.get(fieldName));
                        }  
                        else if (valueType == Schema.DisplayType.ADDRESS){    
                            if(a.get(fieldName) != null)
                            {
                                Address add = (ADDRESS)a.get(fieldName);                                
                                String sa = String.ValueOf(add);
                                String s =''; 
                                if(add.getStreet() != null)    
                                    s += add.getStreet()+', ';
                                if(add.getCity() != null)    
                                    s += add.getCity()+', ';
                                if(add.getState() != null)
                                    s +=add.getState()+', ';
                                if(add.getPostalCode() != null)
                                    s +=add.getPostalCode()+', ';
                                if(add.getCountry() != null)
                                    s +=add.getCountry()+', ';
                                if(add.getCountryCode() != null)
                                    s +=add.getCountryCode()+', ';
                                if(add.getGeocodeAccuracy() != null)
                                    s +=add.getGeocodeAccuracy()+', ';
                                if(add.getStateCode() != null)
                                    s +=add.getStateCode()+', ';
                                s = s.removeEnd(', ');                            
                                valueMap.put('account.'+fieldName,s);
                            }                     
                        }                      
                        else{                        
                            valueMap.put('account.'+fieldName, String.valueOf((ADDRESS)a.get(fieldName)));
                        }                   
                    }    
                }
            }
            system.debug('valueMap'+valueMap);
            for(Parley_API_Mapping__c objParley : [SELECT Id, API_Field_Name__c, API_field_Value__c FROM Parley_API_Mapping__c WHERE API_Field_Name__c != null]){
                objParley.API_Field_Name__c = objParley.API_Field_Name__c.toLowerCase();
                system.debug('objParley.API_Field_Name__c'+objParley.API_Field_Name__c);
                if(valueMap.containsKey(objParley.API_Field_Name__c)){
                    system.debug('objParley.API_Field_Name__c'+objParley.API_Field_Name__c);
                    body +='"'+objParley.API_field_Value__c +'":"'+ valueMap.get(objParley.API_Field_Name__c)+'",';
                }
            }
            if(body.contains(',')){
                body = body.removeEnd(',');
            }
            body += '}}';                       
        }else if (parentId.subString(0,3) == '001'){
            
            body = getRequestBody(objAccount.Name, ContractsId, Stage, dueDate,amount,contractName,templateId,chiefNegotiatorId,parentId);
            body = body.removeEnd('}');
             body += ',"additionalUsers":[';
            List<String> sList = new list<String>();
            if(email != null && email != '')
                sList = email.split(',');
            if(!sList.isempty()){
                for(String s : sList){
                    body +='"'+s+'",';
                }
            }
            if(body.contains(',')){
                body = body.removeEnd(',');
            }           
            body += ']'; 
             if(attachmentId != null){
            Attachment objAttachment = [SELECT Id,Name,body FROM Attachment WHERE Id=: attachmentId];        
            String base64Body = EncodingUtil.base64encode(objAttachment.body);
            Blob payloadBlob = EncodingUtil.base64Decode(base64Body);
            String payload = payloadBlob.toString();
            Integer index = payload.indexOf(',');
            String sub = '';
            if (index != 0){
                sub = payload.subString(0,index+1);
            }          
            if(sub != '' && sub != null)
            payload = payload.remove(sub);                  
        
                body += ',"documents":[';
                body += '{"data": "'+payload+'",';
                body += '"fileName": "'+objAttachment.Name+'",';
                body += '"counterparty": '+true+'}';
                body += ']';               
            }
            
            
            body += ',"properties":{';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get('Account');
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            DescribeSObjectResult describeResultVehicleInventory = objAccount.getSObjectType().getDescribe();
            List<String> VehiclefieldNames = new List<String>(describeResultVehicleInventory.fields.getMap().keySet());
            String query = ' SELECT ' + String.join( VehiclefieldNames, ',' ) + ' FROM Account WHERE Id =: parentId';
            List<Account> accountlist  = Database.query(query); 
            system.debug('accountlist'+accountlist);
            Map<String,string> valueMap=new Map<String,String>();            
            for(Account a : accountlist)
            {
                for(String fieldName: fieldMap.keySet())
                {                          
                    Schema.DisplayType valueType = fieldMap.get(fieldName).getDescribe().getType();
                    system.debug('valueType-->'+valueType);
                    system.debug('FieldValue-->'+a.get(fieldName));
                    if (valueType == Schema.DisplayType.Id && a.get(fieldName) != null){
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    }else if (valueType == Schema.DisplayType.Email && a.get(fieldName) != null){
                            valueMap.put(fieldName,(String)a.get(fieldName));
                    }
                    else if(valueType == Schema.DisplayType.DateTime && a.get(fieldName) != null){
                         DateTime DT = (DateTime)a.get(fieldName);                      
                        String s = DT.format('MM/dd/yyyy');
                        valueMap.put(fieldName,s);
                    }
                    else if ((valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency) && a.get(fieldName) != null){
                        Decimal d = (Decimal)a.get(fieldName);
                        String s = String.ValueOf(d);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Double && a.get(fieldName) != null){
                        Double d = (Double)a.get(fieldName);
                        String s = String.ValueOf(d);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Integer && a.get(fieldName) != null){
                        Integer i = (Integer)a.get(fieldName);
                        String s = String.ValueOf(i);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Boolean && a.get(fieldName) != null){
                        boolean b = (boolean)a.get(fieldName);
                        String s = String.ValueOf(b);
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Date && a.get(fieldName) != null){
                        Date d = (Date)a.get(fieldName);
                        String s = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM-d-YYYY');                        
                        valueMap.put(fieldName,s);
                    }
                    else if (valueType == Schema.DisplayType.Picklist && a.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    }
                    else if (valueType == Schema.DisplayType.Phone && a.get(fieldName) != null)
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    else if (valueType == Schema.DisplayType.String && a.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    } 
                    else if (valueType == Schema.DisplayType.TEXTAREA && a.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    } 
                    else if (valueType == Schema.DisplayType.URL && a.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    } 
                    else if (valueType == Schema.DisplayType.REFERENCE && a.get(fieldName) != null){                      
                        valueMap.put(fieldName,(String)a.get(fieldName));
                    }  
                    else if (valueType == Schema.DisplayType.ADDRESS){    
                        if(a.get(fieldName) != null)
                        {
                            Address add = (ADDRESS)a.get(fieldName); 
                            System.Debug('>>>>> Address: ' + add);
                            String sa = String.ValueOf(add);
                            String s =''; 
                            if(add.getStreet() != null)    
                                s += add.getStreet()+', ';
                            if(add.getCity() != null)    
                                s += add.getCity()+', ';
                            if(add.getState() != null)
                                s +=add.getState()+', ';
                            if(add.getPostalCode() != null)
                                s +=add.getPostalCode()+', ';
                            if(add.getCountry() != null)
                                s +=add.getCountry()+', ';
                            if(add.getCountryCode() != null)
                                s +=add.getCountryCode()+', ';
                            if(add.getGeocodeAccuracy() != null)
                                s +=add.getGeocodeAccuracy()+', ';
                            if(add.getStateCode() != null)
                                s +=add.getStateCode()+', ';
                            s = s.removeEnd(', ');
                            System.Debug('>>>>> String address: ' + s);
                            valueMap.put(fieldName,s);
                        }                     
                    }                      
                    else{                        
                        valueMap.put(fieldName, String.valueOf((ADDRESS)a.get(fieldName)));
                    }                   
                }    
            }      
            for(Parley_API_Mapping__c objParley : [SELECT Id, API_Field_Name__c, API_field_Value__c FROM Parley_API_Mapping__c WHERE API_Field_Name__c != null]){               
                objParley.API_Field_Name__c = objParley.API_Field_Name__c.toLowerCase();
                if(valueMap.containsKey(objParley.API_Field_Name__c)){                           
                    body +='"'+objParley.API_field_Value__c +'":"'+ valueMap.get(objParley.API_Field_Name__c)+'",';
                }
            }
            if(body.contains(',')){
                body = body.removeEnd(',');
            }
            body += '}}';            
        }
        System.Debug('>>>>> getRequestBody: ' + body);               
        req.setBody(body); 
        httpResponse res ;
        String contractId = '';
        if(!test.isRunningTest()){
            res = new http().send(req);  
            String header = res.getHeader('SignServiceUrl');  
            if(header != null && header !='')
            contractId = header; 
            else         
            contractId = parseContractId(res.getBody());
            System.Debug('>>>>> responseBody: ' + res.getBody());    
        }
        else{
            ContractId = 'SuccessId';
        }
           
        if (contractId.length() > 0 && !contractId.contains('http')) {       
            if(objParleyParleyProCheckboxSetting.IsContract__c == false){
                Parley_Pro_Contract__c parleyContract = [SELECT Id,Name,Parley_Pro_Contract_ID__c FROM  Parley_Pro_Contract__c WHERE Id =: ContractsId];
                if(Schema.sObjectType.Parley_Pro_Contract__c.fields.Parley_Pro_Contract_ID__c.isUpdateable()){          
                    parleyContract.Parley_Pro_Contract_ID__c  = ContractId ;
                }                
                Update parleyContract;                           
            }
            else if (objParleyParleyProCheckboxSetting.IsContract__c == true){
                Contract standardContract = [SELECT Id,Name,Contract_ID__c FROM  Contract WHERE Id =: ContractsId];   
                if(Schema.sObjectType.Contract.fields.Contract_ID__c.isUpdateable()){                                 
                    standardContract.Contract_ID__c = ContractId ;    
                }           
                Update standardContract;                
            }         
        }
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'ankit@techilaservices.com','roman+pp@parleypro.com'};
        message.subject = 'Contract update status email';      
        message.setplaintextbody(body+'----->'+res.getBody());
        mails.add(message);
        if(!Test.isRunningTest()){
          Messaging.sendEmail(mails); 
          return contractId;
          }
          else return null;
        }  catch(Exception e){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'ankit@techilaservices.com','roman+pp@parleypro.com'};
        message.subject = 'Contract update status email';       
        message.setplaintextbody(e.getMessage());
        mails.add(message);
        if(!Test.isRunningTest())
          Messaging.sendEmail(mails);
          return null;
       }     
        //return contractId;
    }
    
    
    
    public static Parley_Pro_Contract__c newPPContract(String parentId, String contractName) {
        Parley_Pro_Contract__c ppContract = new Parley_Pro_Contract__c();     
        Parley_Pro_Checkbox_Setting__c objParleyParleyProCheckboxSetting  = Parley_Pro_Checkbox_Setting__c.getinstance('IsContract');    
        if(objParleyParleyProCheckboxSetting.IsContract__c == false){  
            if(Schema.sObjectType.Parley_Pro_Contract__c.fields.Opportunity__c.isCreateable() && Schema.sObjectType.Parley_Pro_Contract__c.fields.Account__c.isCreateable() && Schema.sObjectType.Parley_Pro_Contract__c.fields.ContractName__c.isCreateable()){                     
                if(parentId.subString(0,3) == '006'){      
                    ppContract.Opportunity__c = parentId;                          
                }else if (parentId.subString(0,3) == '001'){                 
                    ppContract.Account__c = parentId;                       
                }
                ppContract.ContractName__c=contractName;           
                insert ppContract;
            }
        }
        return ppContract;    
    }
    
    public static Contract newContract(String parentId, String contractName) {
        
        Contract objContract = new Contract();
        Opportunity opp = new opportunity();     
        Parley_Pro_Checkbox_Setting__c objParleyParleyProCheckboxSetting  = Parley_Pro_Checkbox_Setting__c.getinstance('IsContract');
        if(objParleyParleyProCheckboxSetting.IsContract__c == true){                                          
                if(parentId.subString(0,3) == '006'){
                    opp = [Select Id, Name, AccountId FROM Opportunity WHERE Id =: parentId];
                    objContract.Opportunity__c = parentId;
                    objContract.AccountId = opp.AccountId;               
                }else if (parentId.subString(0,3) == '001'){
                    objContract.AccountId = parentId;              
                }                     
                objContract.Name = contractName;
                try{                       
                    insert objContract; 
                }catch(exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Account');
                    ApexPages.addMessage(myMsg);
                }                        
        }
        
        return objContract ;
    }

    public pageReference createContract(){ 
        Attachment a = new Attachment();
        try{
            if(base64 != null && fileName != null && oppId != null){
                a.parentId = oppId;
                a.Body = EncodingUtil.base64decode(base64);
                a.name = fileName;
                insert a;
            }else if(base64 != null && fileName != null && accId != null){
                a.parentId = accId;         
                a.Body = EncodingUtil.base64decode(base64);         
                a.name = fileName;
                insert a;
            }
        }catch(exception e){
            system.debug('Message'+e.getMessage());
            system.debug('Message'+e.getLineNumber());
        } finally{
         a.Body = null;
        }            
          PageReference pageRef;
       
         if(oppId != null){
            pageRef = Page.SendContractforReviewPage;
            pageRef.getParameters().put('opp',oppName);
        }else if(accId != null){
            pageRef = Page.SendContractforAccountReviewPage;
            pageRef.getParameters().put('accountName',accountName);
        }
        pageRef.getParameters().put('attId',a.Id);      
        pageRef.getParameters().put('templateId',tempId);            
        pageRef.getParameters().put('status',StageName);
        pageRef.getParameters().put('email',emails);
        pageRef.getParameters().put('chiefNegotiatorId',NegId);
        if(oppId != null){
            pageRef.getParameters().put('OppId',oppId);
        }else if(accId != null){
            pageRef.getParameters().put('accId',accId);
        }
        return pageRef;
    }
}