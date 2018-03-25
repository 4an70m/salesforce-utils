({
	recordUpdated: function (component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") {
            console.log('ERROR');
        } else if (changeType === "CHANGED") {
            alert('Record updated');
        }
    }
})