<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<title>Створення замовлення</title>
</head>
<body onload="getData()">
    <div style="padding-left:50px;font-family:monospace;">
        <h1>Створення замовлення</h1>
        <h2 id="error"style="color:red;"></h2>
            <div style="width: 200px; text-align:left;">

                <div style="padding:10px; font-size:20px;">
                    Адреса куди: <input id="to" name="to" />
                </div>

                <div style="padding:10px; font-size:20px;">
                    Адреса звідки: <input id="from" name="from" />
                </div>

                <input style="height:30px;" id="approve" type="button" value="Продовжити" onclick="apply()">

            </div>
    </div>
                <script>
        			function apply(){

                    if (document.getElementById('from').value.trim() === "" || document.getElementById('to').value.trim() === "") {
                       ${"error"}.innerHTML = "Помилка, надано пусті поля";
                    } else {
                            window.location.replace("http://localhost:3030/taxi/rest/rate?driverId="+${param.driverId}+"&from="+document.getElementById('from').value+"&to="+document.getElementById('to').value);
                        }
        			}

        			function getData(){
                        $.ajax({
                                url: 'http://localhost:3030/taxi/rest/operations',
                                type: 'GET',
                                dataType: "text",
                                success: function(id) {
                                if(id==="0"){
                                    window.location.replace("http://localhost:3030/taxi");
                                }
                                }
                            });
                    }

                </script>
</body>
</html>