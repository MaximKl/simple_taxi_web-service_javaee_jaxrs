<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Create User</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body onload="getData()">
    <div style="padding-left:50px;font-family:monospace;">
        <h2>Create User</h2>
        <form action="rest/sendOrder" method="POST">
            <div style="width: 100px; text-align:left;">
                <div style="padding:15px;">
                    User ID: <input name="id" />
                </div>
                <div style="padding:10px;">
                    Name: <input name="name" />
                </div>
                <div style="padding:10px;">
                    Age: <input name="age" />
                </div>
                <div style="padding:20px;text-align:center">
                    <input type="submit" value="Submit" />
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
                                if(id==="0"){
                                    window.location.replace("http://localhost:3030/taxi");
                                }
                                }
                            });
                    }
                </script>
</html>