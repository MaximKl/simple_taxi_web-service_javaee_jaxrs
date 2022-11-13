<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
        <title>Створення користувача</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body onload="getData()">
    <div style="padding-left:50px;font-family:monospace;">
        <h1>Створення користувача</h1>
        <form action="http://localhost:3030/taxi/rest/registration" method="POST">
            <div style="width: 400px; text-align:left;">

                <div style="padding:10px; font-size:20px;"">
                    Ім`я (необов`язково): <input name="name" />
                </div>

                <div style="padding:10px; font-size:20px;"">
                    Прізвище (необов`язково): <input name="surname" />
                </div>

                <div style="padding:10px; font-size:20px;"">
                    Телефон або поштова скринька (обов`язково):<br> <input name="mail" />
                </div>

                <div style="padding:20px; text-align:center;">
                    <input style="height:30px;" type="submit" value="Submit" />
                </div>

            </div>
        </form>
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