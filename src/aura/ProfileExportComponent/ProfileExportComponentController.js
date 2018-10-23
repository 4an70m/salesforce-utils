/**
 * Created by 4an70 on 10/2/2018.
 */
({
    doInit: function(cmp, evt, helper) {
        helper.loadProfiles(cmp, evt, helper);
        helper.initKeyShortcuts(cmp, evt, helper);
    },

    exportSelectedProfiles: function (cmp, evt, helper) {
        helper.exportToExcel(cmp, evt, helper);
    },

    filterProfiles: function(cmp, evt, helper) {
        helper.filterProfiles(cmp, evt, helper);
    },

    tableImport: function(cmp, evt, helper) {
        helper.importTable(cmp, evt, helper);
    }
})