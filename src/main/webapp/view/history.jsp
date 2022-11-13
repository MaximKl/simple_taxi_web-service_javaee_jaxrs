<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Водії</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    </head>
    <body style="font-family:monospace;" onload="getData()">
        <style>
            .th_norm, .td_norm {
              padding-left:30px;
              padding-right:30px;
              border-bottom: 1px solid #919184;
              border-right: 1px solid #919184;
            }
            .search{
                position:fixed;
                right:0;
                top:0;
                margin:10px;
                margin-right:385px;
                margin-top:50px;
            }

            .th_norm {
                font-size:20px;
            }
        </style>
    	<table>
    		<tr>
    			<th class="th_norm" style="width:50px;">Номер замовлення</th>
    			<th class="th_norm" style="width:150px;">Адреси</th>
    			<th class="th_norm">Водій</th>
    			<th class="th_norm">Автівка</th>
    			<th class="th_norm">Ціна</th>
    			<th class="th_norm" style="width:50px;">Оцінка замовлення</th>
    		</tr>
    	<c:forEach var="order" items="${orders}">

    		<tr style="height:120px;">
    			<td class="td_norm" style="font-size:30px; text-align:center;">${order.id}</td>
    			<td class="td_norm" style="text-align:center;">Звідки: ${order.user.addressFrom}<br><br>Куди: ${order.user.addressTo}</td>
    			<td class="td_norm">Ім`я: ${order.driver.name}<br>Прізвище: ${order.driver.surname}<br>Вік: ${order.driver.age}<br>Номер: ${order.driver.phone}</td>
    			<td class="td_norm">Назва: ${order.driver.car.brand} ${order.driver.car.name} ${order.driver.car.yearOfProduction}<br>Номер: ${order.driver.car.number}<br>Колір: ${order.driver.car.color}<br>Клас: ${order.driver.car.clas}</td>
                <td class="td_norm" style="font-size:30px">${order.price} ₴</td>
                <td class="td_norm" style="font-size:30px; text-align:center;">${order.mark}</td>
    		</tr>
    	</c:forEach>
    	</table>

                <div class="search">
                     <h2>Оберіть дію та оцінку</h2>
                     <select style="width:190px; height:30px; text-align:center;" id="option">
                       <option value="вище">Оцінка вище за надану</option>
                       <option value="нижче">Оцінка нижче за надану</option>
                       <option style="display:none;" label="" selected disabled>${param.option}</option>
                     </select>
                     <br>
                     <br>
                </div>


                <div class="search" style="margin-top:200px; margin-right:285px;">
                     <select style="width:190px; height:30px; text-align:center;" id="mark">
                       <option value="1">1</option>
                       <option value="2">2</option>
                       <option value="3">3</option>
                       <option value="4">4</option>
                       <option value="5">5</option>
                       <option value="6">6</option>
                       <option value="7">7</option>
                       <option value="8">8</option>
                       <option value="9">9</option>
                       <option value="10">10</option>
                       <option style="display:none;" label="" selected disabled>${param.mark}</option>
                     </select>
                     <br>
                     <br>
                     <input style="height:30px;" id="filter" type="button" value="Застосувати фільтр" onclick="applyFilter()">
                     <input id="approve" style="width:180px; height:40px; background-color:#d45d68" type="button" value="Прибрати фільтр" onclick="filtersOff()">
                </div>

        </body>

                <script>
                    var link="http://localhost:3030/taxi/rest/userHistory/";

        			function applyFilter(){
        			    var markBuffer = document.getElementById('mark');
        			    var optionBuffer = document.getElementById('option');
        			    var selectMark = markBuffer.options[markBuffer.selectedIndex];
        			    var selectOption = optionBuffer.options[optionBuffer.selectedIndex];
        			    if(selectMark.value.length===0 ||selectOption.value.length===0){
                            return;
        			    }
                        window.location.replace(link+"?option="+selectOption.value+"&mark="+selectMark.value);
        			}


                    function filtersOff(){
                        window.location.replace(link);
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
                                link = link+id;
                                }
                            });
                    }

                </script>
</html>