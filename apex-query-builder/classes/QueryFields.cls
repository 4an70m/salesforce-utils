/**
 * Created by User on 10.04.2018.
 */

public virtual class QueryFields {

    private final String fromSObject;
    private final Set<String> fieldTokens;

    public QueryFields(Query query) {
        this.fieldTokens = new Set<String>();
        this.fromSObject = query.getFromSobject();
    }

    public void addField(String fieldName) {
        if (fieldName.contains(',')) {
            this.addFields(fieldName);
            return;
        }
        this.fieldTokens.add(fieldName.trim());
    }

    public void addField(SObjectField field) {
        this.fieldTokens.add(field.getDescribe().getName());
    }

    public void addFields(SObject sobj) {
        Map<String, Object> populatedFields = sobj.getPopulatedFieldsAsMap();
        for (String field : populatedFields.keySet()) {
            this.fieldTokens.add(field);
        }
    }

    public void addFields(String fieldNames) {
        List<String> fields  = fieldNames.trim().split(',');
        for (String field : fields) {
            this.fieldTokens.add(field.trim());
        }
    }

    public void addFields(List<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldTokens.add(fieldName.trim());
        }
    }

    public void addFields(Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldTokens.add(fieldName.trim());
        }
    }

    //all fields
    public void addAllFields() {
        Set<String> fieldNames = Schema.getGlobalDescribe().get(this.fromSobject).getDescribe().fields.getMap().keySet();
        this.fieldTokens.addAll(fieldNames);
    }

    public void addAllCreatableFields() {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(this.fromSobject);
        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

        Set<String> createableFields = new Set<String>{};
        for (Schema.SObjectField field : fieldMap.values()) {
            DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.isCreateable()) {
                createableFields.add(fieldDescribe.getName());
            }
        }
        fieldTokens.addAll(createableFields);
    }

    //field sets
    public void addFieldSet(FieldSet fieldSet) {
        Set<String> fieldNames = new Set<String>();
        for (FieldSetMember fieldSetMember : fieldSet.getFields()) {
            fieldNames.add(fieldSetMember.getFieldPath());
        }
        this.fieldTokens.addAll(fieldNames);
    }

    public void addFieldSet(String fieldSetName) {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = GlobalDescribeMap.get(this.fromSobject);
        List<FieldSetMember> fields = sObjectTypeObj.getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
        for (FieldSetMember fieldSetMember : fields) {
            result.add(fieldSetMember.getFieldPath());
        }
        this.fieldTokens.addAll(result);
    }

    public override String toString() {
        String fields = '';
        if (this.fieldTokens.isEmpty()) {
            fields = 'Id';
        } else {
            fields = String.join(new List<String>(this.fieldTokens), ', ');
        }
        return fields;
    }
}