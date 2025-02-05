var POST_URL = "https://boneheadsbakery.requestcatcher.com/test";
//var POST_URL = "https://boneheads-bakery.com/order-hook";
function onSubmit(e) {
    var form = FormApp.getActiveForm();
    var allResponses = form.getResponses();
    var latestResponse = allResponses[allResponses.length - 1];
    var response = latestResponse.getItemResponses();
    var payload = {};
    for (var i = 0; i < response.length; i++) {
        var question = response[i].getItem().getTitle();
        var answer = response[i].getResponse();
        payload[question] = answer;
    }

    payload["token-proof"] = "trust-me-bro"
    payload["throw"] = "https://inv.boneheads-bakery.com/order-hook"


    var options = {
        "method": "post",
        "contentType": "application/json",
        "payload": JSON.stringify(payload)
    };
UrlFetchApp.fetch(POST_URL, options);
};