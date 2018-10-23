/**
 * Created by 4an70 on 10/2/2018.
 */
({
    //init
    loadProfiles: function(cmp, evt, helper) {
        let action = cmp.get("c.getListOfProfiles");
        action.setCallback(this, response => {
            const state = response.getState();
            if (state === "SUCCESS") {
                helper.buildTable(response, cmp, helper);
            } else {
                //ToDo: handle errors
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    buildTable: function(response, cmp, helper) {
        let profiles = response.getReturnValue();
        if (!$A.util.isArray(profiles)) {
            return;
        }
        let columns = Object.keys(profiles[0]).map(fieldName => {
            return {label: fieldName, fieldName: fieldName, type: "text"};
        });
        cmp.set("v.profiles", profiles);
        cmp.set("v.filteredProfiles", profiles);
        cmp.set("v.profileColumns", columns);
    },

    initKeyShortcuts: function(cmp, evt, helper) {
        window.onkeydown = function (keyEvent) {
            if (keyEvent.keyCode === 70 && keyEvent.ctrlKey) {
                cmp.find("filterField").focus();
                keyEvent.preventDefault();
            }
            if (keyEvent.keyCode === 27) {
                cmp.find("filterField").set("v.value", "");
                cmp.set("v.filteredProfiles",  cmp.get("v.profiles"));
                keyEvent.preventDefault();
            }
        };
    },

    //export
    exportToExcel: function(cmp, evt, helper) {
        let selectedRows = cmp.find("profilesTable").getSelectedRows();
        if (!$A.util.isArray(selectedRows) || selectedRows.length === 0) {
            return;
        }
        helper.getPermissionsForProfiles(selectedRows, cmp)
            .then($A.getCallback(result => {
                helper.buildExcelTable(result, cmp);
            }))
    },

    getPermissionsForProfiles: function(selectedRows, cmp) {
        return new Promise($A.getCallback(function(resolve, reject) {
            const action = cmp.get("c.getProfilesWithPermissions");
            let profileIds = selectedRows.map(profile => {return profile.Id});
            action.setParams({"profileIds": profileIds, "permissionsType": cmp.get("v.permissionType")});
            action.setCallback(this, response => {
                const state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue())
                } else {
                    reject(response);
                }
            });
            $A.enqueueAction(action);
        }));
    },

    buildExcelTable: function(result, cmp) {
        const excelFileName =  "Profiles Export.xlsx";
        const wb = XLSX.utils.book_new();
        /* add to workbook */
        result.forEach(profile => {
            let ws = XLSX.utils.json_to_sheet(profile.FieldPerms);
            XLSX.utils.book_append_sheet(wb, ws, profile.Profile.Name.substring(0, 30));
        });

        /* write workbook (use type "binary") */
        XLSX.writeFile(wb, excelFileName, {bookType:"xlsx", type:"binary"});
    },

    filterProfiles: function(cmp, evt, helper) {
        const allProfiles = cmp.get("v.profiles");
        let filterWord = evt.getSource().get("v.value");
        if (!filterWord) {
            cmp.set("v.filteredProfiles", allProfiles);
            return;
        }
        let filteredProfiles = allProfiles.filter(profile => {
            return Object.values(profile).some(profileField => {
                 return profileField.toUpperCase().includes(filterWord.toUpperCase());
            });
        });
        cmp.set("v.filteredProfiles", filteredProfiles);
    },

    //import
    importTable: function (cmp, evt, helper) {
        debugger;
        let table = evt.getParam("table");
        let fieldPermissions = XLSX.utils.sheet_to_json(table.Sheets.Profile);
        let action = cmp.get("c.updateProfiles");
        action.setParams({"fieldPermissions": fieldPermissions});
        action.setCallback(this, response => {
            let state = response.getState();
            if(state === "SUCCESS") {
                alert("Success");
            } else {
                alert("Error");
            }
        });
        $A.enqueueAction(action);
    }
})