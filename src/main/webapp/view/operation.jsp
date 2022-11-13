<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Оберіть дію</title>
        <script src="/taxi/js/getUser.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    </head>
    <body onload="getData()">
        <div style="padding-left:50px;font-family:monospace; font-size:30px;">
                Оберіть дію</br></br>
            <a href="${pageContext.request.contextPath}/rest/drivers"><div
                                    style="color:saffron; font-size:20px;">Зробити замовлення</div></a></br></br>
            <a id="myOrders"><div
                                    style="color:saffron; font-size:20px;">Отримати історію замовлень</div></a></br></br>
        </div>
    </body>
</html>