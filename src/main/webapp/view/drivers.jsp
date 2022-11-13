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
                margin-right:125px;
            }

            .th_norm {
                font-size:20px;
            }
        </style>
        <div style="width: 1100px; margin-bottom:30px; margin-top:-50;">
            <div style="padding:10px;">
                <h2>Пошук за прізвищем водія або номером, роком та назвою автомобілю:</h2>
                <input placeholder="Приклади:   AX0000IP   |   Петро Петренко   |   Skoda Octavia 2010" style="width:450px; height:30px;" id="input_search"/>
                <input style="margin:20px; width:70px; height:30px;" id="approve" type="button" value="Пошук" onclick="applyInput()">
                <input id="approve" style="margin-left:180px; width:230px; height:40px; background-color:#d45d68" type="button" value="Прибрати усі фільтри" onclick="filtersOff()">
                <h3>Результати пошуку: ${param.search}</h3>
            </div>

        </div>
    	<table>
    		<tr>
    			<th class="th_norm">Інформація водія</th>
    			<th class="th_norm">Зв`язок</th>
    			<th class="th_norm">Автомобіль</th>
    			<th class="th_norm">Клас</th>
    			<th class="th_norm">Оцінка</th>
    		</tr>
    	<c:forEach var="driver" items="${drivers}">

    	    <c:url var="callButton" value="/rest/make-order">
                <c:param name="driverId" value="${driver.id}"/>
            </c:url>

    		<tr style="height:120px;">
    			<td class="td_norm">Імя: ${driver.name}<br>Прізвище: ${driver.surname}<br>Вік: ${driver.age}</td>
    			<td class="td_norm" style="font-size:20px">Мобільний телефон: ${driver.phone}</td>
    			<td class="td_norm" style="font-size:17px">Назва: ${driver.car.brand} ${driver.car.name} ${driver.car.yearOfProduction}<br> Номер: ${driver.car.number}<br> Колір: ${driver.car.color}</td>
                <td class="td_norm" style="font-size:30px">${driver.car.clas}</td>
                <td class="td_norm" style="font-size:30px">${driver.mark}</td>
                <td style="padding-left:20px;"><input style="height:50px;" type="button" value="Замовити" onclick="window.location.href = '${callButton}'"></td>
    		</tr>
    	</c:forEach>
    	</table>


                <div class="search" style="margin-top:20px;">
                     <h2>Оберіть початкову оцінку</h2>
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
                       <option label="--прибрати фільтр--"></option>
                       <option style="display:none;" label="" selected disabled>${param.mark}</option>
                     </select>
                     <br>
                     <br>
                     <input style="height:30px;" id="approveMark" type="button" value="Застосувати фільтр" onclick="applyMark()">
                </div>

                <div class="search" style="margin-top:200px; margin-right:190px;">
                     <h2>Оберіть клас</h2>
                     <select style="width:190px; height:30px; text-align:center;" id="clas">
                       <option value="Економ">Економ</option>
                       <option value="Середній">Середній</option>
                       <option value="Преміум">Преміум</option>
                       <option value="Вантажний">Вантажний</option>
                       <option label="--прибрати фільтр--"></option>
                       <option style="display:none;" label="" selected disabled>${param.clas}</option>
                     </select>
                     <br>
                     <br>
                     <input style="height:30px;" id="approve" type="button" value="Застосувати фільтр" onclick="applyClas()">
                </div>

                <div class="search" style="margin-top:400px; margin-right:190px;">
                     <h2>Оберіть колір</h2>
                     <select style="width:190px; height:30px; text-align:center;" id="color">
                       <option value="Чорний">Чорний</option>
                       <option value="Білий">Білий</option>
                       <option value="Сірий">Сірий</option>
                       <option value="Зелений">Зелений</option>
                       <option value="Синій">Синій</option>
                       <option value="Жовтий">Жовтий</option>
                       <option value="Червоний">Червоний</option>
                       <option value="Коричневий">Коричневий</option>
                       <option label="--прибрати фільтр--"></option>
                       <option style="display:none;" label="" selected disabled>${param.color}</option>
                     </select>
                     <br>
                     <br>
                     <input style="height:30px;" id="approve" type="button" value="Застосувати фільтр" onclick="applyColor()">
                </div>
    </body>
                <script>
                    var link="http://localhost:3030/taxi/rest/drivers?";
        			function applyClas(){
        			    var buffer = document.getElementById('clas');
        			    var select = buffer.options[buffer.selectedIndex];
                        window.location.replace(link+"search=${param.search}&color=${param.color}&mark=${param.mark}&clas="+select.value);
        			}

        			function applyMark(){
                        var buffer = document.getElementById('mark');
                        var select = buffer.options[buffer.selectedIndex];
                        window.location.replace(link+"search=${param.search}&color=${param.color}&mark="+select.value+"&clas=${param.clas}");
                    }

                    function applyColor(){
                        var buffer = document.getElementById('color');
                        var select = buffer.options[buffer.selectedIndex];
                        window.location.replace(link+"search=${param.search}&color="+select.value+"&mark=${param.mark}&clas=${param.clas}");
                    }

                    function applyInput(){
                        window.location.replace(link+"search="+${"input_search"}.value+"&color=${param.color}&mark=${param.mark}&clas=${param.clas}");
                    }

                    function filtersOff(){
                        window.location.replace("http://localhost:3030/taxi/rest/drivers");
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
</html>