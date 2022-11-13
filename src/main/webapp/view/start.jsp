<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Зареєструйте себе</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body onload="getData()">
    <div style="padding-left:50px;font-family:monospace; font-size:30px;"">
            Зареєструйте себе!</br></br>
        <a href="${pageContext.request.contextPath}/view/reg-user.jsp"><div
                                style="color:saffron; font-size:20px;">Зареєструватися</div></a></br></br>
    </div>
</body>
                    <script>
                    function getData(){
                        $.ajax({
                                url: 'http://localhost:3030/taxi/rest/operations',
                                type: 'GET',
                                dataType: "text",
                                success: function(id) {
                                if(id!=="0"){
                                    window.location.replace("http://localhost:3030/taxi/rest");
                                }
                                }
                            });
                    }
                    </script>
</html>