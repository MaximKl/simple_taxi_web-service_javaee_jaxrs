<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Будь ласка, оцініть замовлення</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body onload="getData()">
    <div style="padding-left:50px;font-family:monospace;">
        <h2>Будь ласка, оцініть замовлення</h2>
            <div style="width: 100px">
                <div style="padding:10px;">
                 <select style="width:190px; height:30px; text-align:center;" id="mark">
                   <option value="1">1</option>
                   <option value="2">2</option>
                   <option value="3">3</option>
                   <option value="4">4</option>
                   <option value="5">5</option>
                   <option value="6" selected>6</option>
                   <option value="7">7</option>
                   <option value="8">8</option>
                   <option value="9">9</option>
                   <option value="10">10</option>
                 </select>
                 </div>
            </div>
            <input id="approve" type="button" value="Надіслати" onclick="apply()">
    </div>
            <script>
    			function apply(){
    			    var select = document.getElementById('mark');
                    var option = select.options[select.selectedIndex];
                    window.location.replace("http://localhost:3030/taxi/rest/sendOrder?driverId=${param.driverId}&from=${param.from}&to=${param.to}&mark="+option.value);
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