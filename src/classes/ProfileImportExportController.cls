/**
 * Created by 4an70 on 10/2/2018.
 */

public with sharing class ProfileImportExportController {

    @AuraEnabled
    public static List<Profile> getListOfProfiles() {
        return [SELECT Id, Name FROM Profile ORDER BY Name];
    }

    @AuraEnabled
    public static List<PermissionSet> getProfilesWithPermissions(List<Id> profileIds, String permissionsType) {
        return new ProfileManager(profileIds).setPermissionExportType(permissionsType).getProfilesWithPermissions();
    }

    @AuraEnabled
    public static void updateProfiles(List<FieldPermissions> fieldPermissions) {
        update fieldPermissions;
    }

    private class ProfileManager {

        private List<Id> profileIds;
        private String permissionsType;

        public ProfileManager(List<Id> profileIds) {
            this.profileIds = profileIds;
        }

        //public interface
        public ProfileManager setPermissionExportType(String permissionsType) {
            this.permissionsType = permissionsType;
            return this;
        }

        public List<PermissionSet> getProfilesWithPermissions() {
//            List<ProfileWithPermissions> result = new List<ProfileWithPermissions>();
            List<PermissionSet> permissionSets = getPermissionSets();
/*            List<SObjectWithFields> sobjectsWithFields = this.getSObjectWithFields();
            for (PermissionSet permissionSet : permissionSets) {
//                ProfileWithPermissions profileWithPermissions = new ProfileWithPermissions(permissionSet);
            }
*/


            return permissionSets;
        }

        //private methods
        private List<SObjectWithFields> getSObjectWithFields() {
            List<SObjectWithFields> result = new List<SObjectWithFields>();
            Map<String, SObjectType> globalDescribe = Schema.getGlobalDescribe();
            for(SObjectType sobjectType : globalDescribe.values()) {
                result.add(new SObjectWithFields(sobjectType));
            }
            return result;
        }

        private List<PermissionSet> getPermissionSets() {
            return [
                    SELECT Id
                        , Profile.Name
                        , ProfileId
                        , (
                            SELECT Id
                                , ParentId
                                , SobjectType
                                , PermissionsCreate
                                , PermissionsRead
                                , PermissionsEdit
                                , PermissionsDelete
                                , PermissionsViewAllRecords
                                , PermissionsModifyAllRecords
                            FROM ObjectPerms
                        )
                        , (
                            SELECT Id
                                , Field
                                , ParentId
                                , SobjectType
                                , PermissionsRead
                                , PermissionsEdit
                            FROM FieldPerms
                        )
                    FROM PermissionSet
                    WHERE ProfileId IN :this.profileIds
            ];
        }
    }

    private class PermissionSetWithObjectInfo {

        private PermissionSet permissionSet;
        private Map<String, List<String>> fieldsBySobjectName;

        public PermissionSetWithObjectInfo(PermissionSet permissionSet) {
            this.permissionSet = permissionSet;
            this.fieldsBySobjectName = this.formObjectFieldMap();
        }

        private Map<String, List<String>> formObjectFieldMap() {
            Map<String, List<String>> result = new Map<String, List<String>>();
            for (ObjectPermissions objectPermissions : this.permissionSet.ObjectPerms) {
                List<String> fields = new List<String>();
                for (FieldPermissions fieldPermissions : this.permissionSet.FieldPerms) {

                }
            }
            return result;
        }
    }

    private class ProfileWithPermissions {

        @AuraEnabled public Profile profile;

        public ProfileWithPermissions() {

        }
    }
    
    private class ObjectPermission {
        
    }
    
    private class FieldPermission {
        
    }
    
    private class SObjectWithFields {
        
        private String sobjectName;
        private List<String> fieldNames;
        
        public SObjectWithFields(SObjectType sobjectName) {
            DescribeSObjectResult describeSObject = sobjectName.getDescribe();
            this.sobjectName = describeSObject.getName();
            this.fieldNames = new List<String>(describeSObject.fields.getMap().keySet());
        }
    }
}