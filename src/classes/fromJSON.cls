global class fromJSON{
    public cls_templates[] templates;
    public cls_Users[] Users;
    
    global class cls_Users{
        public String lastName{get;set;}       
        public String firstName{get;set;}     
        public String id{get;set;}       
    }

    global class cls_templates {
        public String type;    //template
        public String id;   //3abd267b-89a8-4da9-a343-b8bf8b0c46dd
        public String name; //full_featured_template
    }
 
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }
}