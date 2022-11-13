function getData(){
$.ajax({
        url: 'rest/operations',
        type: 'GET',
        dataType: "text",
        success: function(id) {
        if(id==="0"){
            window.location.replace("http://localhost:3030/taxi");
            return;
        }
        var a = document.getElementById('myOrders');
        a.href = "/taxi/rest/userHistory/"+id;
        }
    });
}