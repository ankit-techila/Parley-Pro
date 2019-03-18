@isTest
public class SendContractforReviewController_Test {
    
    public static testmethod void  validateContract(){
        
        Account testAcct = new Account (Name = 'My Test Account');
        insert testAcct;
        //String s = '2013-02-14';
        Opportunity opp1 = new Opportunity(Name ='Test opportunity',
                                           AccountID = testAcct.ID,
                                           StageName = 'Customer Won',
                                           Amount = 3000,
                                           CloseDate = system.today());
        
        insert opp1;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Test Con';
        objContact.AccountId = testAcct.Id;
        objContact.Email = 'Test@gmail.com';
        Insert objContact;
        
        OpportunityContactRole objOCR = new OpportunityContactRole();
        objOCR.OpportunityId = opp1.Id;
        objOCR.IsPrimary = true;
        objOCR.ContactId = objContact.Id;
        Insert objOCR;
        
        Attachment objAttachment = new Attachment();
        objAttachment.Body = Blob.ValueOf('Test Attachment');
        objAttachment.Name = 'Test';
        objAttachment.ParentId =opp1.Id;
        Insert objAttachment;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp1.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 500
        );
        insert oli;
        
       Parley_Pro_Checkbox_Setting__c objParley = new Parley_Pro_Checkbox_Setting__c();
        objParley.Name = 'IsContract';
        objParley.IsContract__c = true;
        Insert objParley;
        system.assertEquals(true,objParley.IsContract__c);
        
        ParleyProSetups__c objSetup = new ParleyProSetups__c();
        objSetup.BackendURL__c = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objSetup.API_Key__c = 'floEgqvNPx5ix03mOEH9x2qwM5vpeLTu4rZy6cAV';
        objSetup.Webapp_URL__c = 'http://acme.parleypro.net/master/index.html#';
        Insert objSetup;
        
        ApexPages.currentPage().getParameters().put('attId',objAttachment.Id);
        ApexPages.currentPage().getParameters().put('id',opp1.Id);
        ApexPages.currentPage().getParameters().put('oppId',opp1.Id);
        ApexPages.currentPage().getParameters().put('email','Test@gmail.com');
        ApexPages.currentPage().getParameters().put('attId',objAttachment.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp1);
        SendContractforReviewController objContactReview = new SendContractforReviewController(controller);
        ParleyProNewContractController objParleyProNewContractController = new ParleyProNewContractController(controller);
        ParleyProNewContractController objParleyProNewContractController1 = new ParleyProNewContractController();
        ParleyProNewContractController.config = objSetup;
        String serverURL = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objParleyProNewContractController.base64 = 'efefrefregregrgrgrgrgrgr';
        objParleyProNewContractController.fileName = 'Test';
        objParleyProNewContractController.saveSettings();
        objParleyProNewContractController.getContractName();
        objParleyProNewContractController.getRequest();
        objParleyProNewContractController.createContract();
        objContactReview.createContract();
        objContactReview.onSamePageLoad();
        objContactReview.ReviewContractonParley();
        objContactReview.backToRecord();
    }
    
    public static testmethod void  validateContractWithoutAccount(){
        
        Opportunity opp1 = new Opportunity(Name ='Test opportunity',                                          
                                           StageName = 'Customer Won',
                                           Amount = 3000,
                                           CloseDate = system.today());        
        insert opp1;
        
        Parley_Pro_Checkbox_Setting__c objParley = new Parley_Pro_Checkbox_Setting__c();
        objParley.Name = 'IsContract';
        objParley.IsContract__c = true;
        Insert objParley;
        system.assertEquals(true,objParley.IsContract__c);
        
        ParleyProSetups__c objSetup = new ParleyProSetups__c();
        objSetup.BackendURL__c = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objSetup.API_Key__c = 'floEgqvNPx5ix03mOEH9x2qwM5vpeLTu4rZy6cAV';
        objSetup.Webapp_URL__c = 'http://acme.parleypro.net/master/index.html#';
        Insert objSetup;
        
        ApexPages.currentPage().getParameters().put('oppId',opp1.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp1);
        SendContractforReviewController objContactReview = new SendContractforReviewController(controller);
        ParleyProNewContractController objParleyProNewContractController = new ParleyProNewContractController(controller);
        ParleyProNewContractController objParleyProNewContractController1 = new ParleyProNewContractController();
        ParleyProNewContractController.config = objSetup;
        objParleyProNewContractController.selectedTab = 'second_tab__item';
        objParleyProNewContractController.getContractName();
        String apiKey = objSetup.API_Key__c;
        String serverURL = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objContactReview.createContract();
        objContactReview.onSamePageLoad();
        objContactReview.ReviewContractonParley();
        objContactReview.backToRecord();
    }
    
    public static testmethod void  validateContractWithoutContract(){
        
        Account testAcct = new Account (Name = 'My Test Account');
        insert testAcct;
        //String s = '2013-02-14';
        Opportunity opp1 = new Opportunity(Name ='Test opportunity',
                                           AccountID = testAcct.ID,
                                           StageName = 'Customer Won',
                                           Amount = 3000,
                                           CloseDate = system.today());
        
        insert opp1;
        
        Parley_Pro_Checkbox_Setting__c objParley = new Parley_Pro_Checkbox_Setting__c();
        objParley.Name = 'IsContract';
        objParley.IsContract__c = true;
        Insert objParley;
        system.assertEquals(true,objParley.IsContract__c);
        
        ParleyProSetups__c objSetup = new ParleyProSetups__c();
        objSetup.BackendURL__c = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objSetup.API_Key__c = 'floEgqvNPx5ix03mOEH9x2qwM5vpeLTu4rZy6cAV';
        objSetup.Webapp_URL__c = 'http://acme.parleypro.net/master/index.html#';
        Insert objSetup;
        
        ApexPages.currentPage().getParameters().put('oppId',opp1.Id);
        ApexPages.currentPage().getParameters().put('id',opp1.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp1);
        SendContractforReviewController objContactReview = new SendContractforReviewController(controller);
        ParleyProNewContractController objParleyProNewContractController = new ParleyProNewContractController(controller);
        ParleyProNewContractController objParleyProNewContractController1 = new ParleyProNewContractController();
        objParleyProNewContractController.selectedTab = 'third_tab__item';
        objParleyProNewContractController.getContractName();
        ParleyProNewContractController.config = objSetup;
        String serverURL = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        //objContactReview.createContract();
        objContactReview.onSamePageLoad();
        objContactReview.ReviewContractonParley();
        objContactReview.backToRecord();
    }
    public static testmethod void  validateContractWithAccount(){
        
        Account testAcct = new Account (Name = 'My Test Account');
        insert testAcct;
        
        
        Attachment objAttachment = new Attachment();
        objAttachment.Body = Blob.ValueOf('Test Attachment');
        objAttachment.Name = 'Test';
        objAttachment.ParentId =testAcct.Id;
        Insert objAttachment;
        
        Parley_Pro_Checkbox_Setting__c objParley = new Parley_Pro_Checkbox_Setting__c();
        objParley.Name = 'IsContract';
        objParley.IsContract__c = true;
        Insert objParley;
        system.assertEquals(true,objParley.IsContract__c);
        
        ParleyProSetups__c objSetup = new ParleyProSetups__c();
        objSetup.BackendURL__c = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objSetup.API_Key__c = 'floEgqvNPx5ix03mOEH9x2qwM5vpeLTu4rZy6cAV';
        objSetup.Webapp_URL__c = 'http://acme.parleypro.net/master/index.html#';
        Insert objSetup;
        
        ApexPages.currentPage().getParameters().put('accId',testAcct.Id);
        ApexPages.currentPage().getParameters().put('id',testAcct.Id);
        ApexPages.currentPage().getParameters().put('id',testAcct.Id);
        ApexPages.currentPage().getParameters().put('email','Test@gmail.com');
        ApexPages.currentPage().getParameters().put('attId',objAttachment.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(testAcct);
        SendAccountContractforReviewController objContactReview = new SendAccountContractforReviewController(controller);
        ParleyProNewContractController objParleyProNewContractController = new ParleyProNewContractController(controller);
        ParleyProNewContractController objParleyProNewContractController1 = new ParleyProNewContractController();
        objParleyProNewContractController.selectedTab = 'fourth_tab__item';
        objParleyProNewContractController.getContractName();
        ParleyProNewContractController.config = objSetup;
        String serverURL = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objParleyProNewContractController.base64 = 'efefrefregregrgrgrgrgrgr';
        objParleyProNewContractController.fileName = 'Test';
        objParleyProNewContractController.saveSettings();
        objParleyProNewContractController.getContractName();
        objParleyProNewContractController.getRequest();
        objParleyProNewContractController.createContract();
        objContactReview.createContract();
        objContactReview.onSamePageLoad();
        objContactReview.ReviewContractonParley();
        objContactReview.backToRecord();
        
    }
    public static testmethod void  validateContractWithoutContractforAccount(){
        
        Account testAcct = new Account (Name = 'My Test Account');
        insert testAcct;
        
        Parley_Pro_Checkbox_Setting__c objParley = new Parley_Pro_Checkbox_Setting__c();
        objParley.Name = 'IsContract';
        objParley.IsContract__c = true;
        Insert objParley;
        system.assertEquals(true,objParley.IsContract__c);
        
        ParleyProSetups__c objSetup = new ParleyProSetups__c();
        objSetup.BackendURL__c = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        objSetup.API_Key__c = 'floEgqvNPx5ix03mOEH9x2qwM5vpeLTu4rZy6cAV';
        objSetup.Webapp_URL__c = 'http://acme.parleypro.net/master/index.html#';
        Insert objSetup;
        
        ApexPages.currentPage().getParameters().put('accId',testAcct.Id);
        ApexPages.currentPage().getParameters().put('id',testAcct.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(testAcct);
        SendAccountContractforReviewController objContactReview = new SendAccountContractforReviewController(controller);
        ParleyProNewContractController objParleyProNewContractController = new ParleyProNewContractController(controller);
        ParleyProNewContractController objParleyProNewContractController1 = new ParleyProNewContractController();
        ParleyProNewContractController.config = objSetup;
        String serverURL = 'http://test-client.parleytest.d8a175a3.svc.dockerapp.io';
        //objContactReview.createContract();
        objContactReview.onSamePageLoad();
        objContactReview.ReviewContractonParley();
        objContactReview.backToRecord();
    }
    
}