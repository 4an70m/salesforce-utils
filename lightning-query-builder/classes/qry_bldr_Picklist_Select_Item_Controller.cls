global class qry_bldr_Picklist_Select_Item_Controller {

    @AuraEnabled
    global static String getFieldsSelectOutput(String sobjectType) {
        List<FieldSelectOutput> result = new List<FieldSelectOutput>();
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(sobjectType).getDescribe().fields.getMap();
        result.add(new NoneSelectOutput());
        for (Schema.SObjectField field : fieldsMap.values()) {
            result.add(new FieldSelectOutput(field));
        }
        return JSON.serialize(result);
    }
    
    private virtual class FieldSelectOutput {
        private String label;
        private String value;
        private Boolean selected;
        
        public FieldSelectOutput() {}
        
        public FieldSelectOutput(Schema.SObjectField field) {
            this.label = field.getDescribe().getLabel();
            this.value = field.getDescribe().getName();
            this.selected = false;
        }
    }
    
    private class NoneSelectOutput extends FieldSelectOutput {
        
        public NoneSelectOutput() {
            this.label = '--None--';
            this.value = '';
            this.selected = true;
        }
    }
    
}