global class ParleyProPostInstall implements InstallHandler {
  global void onInstall(InstallContext context) {
    if(context.previousVersion() == null) {
      ParleyProSetups__c config = ParleyProSetups__c.getOrgDefaults();
      if (Schema.sObjectType.ParleyProSetups__c.fields.BackendURL__c.isUpdateable() && 
          Schema.sObjectType.ParleyProSetups__c.fields.Webapp_URL__c.isUpdateable() && 
          Schema.sObjectType.ParleyProSetups__c.fields.API_Key__c.isUpdateable() &&
          Schema.sObjectType.ParleyProSetups__c.fields.BackendURL__c.isCreateable() && 
          Schema.sObjectType.ParleyProSetups__c.fields.Webapp_URL__c.isCreateable() && 
          Schema.sObjectType.ParleyProSetups__c.fields.API_Key__c.isCreateable()) {
          config.BackendURL__c = 'https://api.parleypro.com';
          config.Webapp_URL__c = 'https://<ENTER YOUR SUBDOMAIN>.parleypro.com/#';
          config.API_Key__c = 'GET YOUR API KEY from Parley Pro Administration/Integrations';
          upsert config;
        }
      }
  }
}