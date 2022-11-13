package ua.lb4.restserver;

import ua.lb4.restserver.model.driver.Driver;
import ua.lb4.restserver.model.driver.Drivers;
import ua.lb4.restserver.model.order.Order;
import ua.lb4.restserver.model.order.Orders;
import ua.lb4.restserver.model.user.EmailOrPhone;
import ua.lb4.restserver.model.user.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.*;
import javax.ws.rs.core.*;
import javax.xml.bind.*;
import javax.xml.namespace.QName;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URI;
import java.net.URISyntaxException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.logging.Logger;
import java.util.stream.Collectors;


@Path("/")
public class Service {

    private static Logger log;

    static {
        log = Logger.getLogger(Service.class.getName());
    }

    private Orders unMarshalOrders() {
        File file = new File(LINK.ORDERS_FILE);
        if (file.canRead()) {
            try {
                Unmarshaller um = JAXBContext.newInstance(ua.lb4.restserver.model.order.ObjectFactory.class).createUnmarshaller();
                return (Orders) um.unmarshal(file);
            } catch (JAXBException e) {
                throw new RuntimeException(e);
            }
        }
        return new Orders();
    }

    private User unMarshalUser() {
        File file = new File(LINK.USER_FILE);
        if (file.canRead()) {
            try {
                Unmarshaller um = JAXBContext.newInstance(ua.lb4.restserver.model.user.ObjectFactory.class).createUnmarshaller();
                return (User) um.unmarshal(file);
            } catch (JAXBException e) {
                throw new RuntimeException(e);
            }
        }
        return new User();
    }

    private Drivers unMarshalDriver() {
        File file = new File(LINK.DRIVER_FILE);
        if (file.canRead()) {
            try {
                Unmarshaller um = JAXBContext.newInstance(ua.lb4.restserver.model.driver.ObjectFactory.class).createUnmarshaller();
                return (Drivers) um.unmarshal(file);
            } catch (JAXBException e) {
                throw new RuntimeException(e);
            }
        }
        return new Drivers();
    }

    @POST
    @Path("registration")
    @Produces(MediaType.APPLICATION_XML)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response createUser(@FormParam("name") String name, @FormParam("surname") String surname, @FormParam("mail") String mail) throws URISyntaxException, ServletException, IOException {
        if (mail.isBlank())
            return Response.temporaryRedirect(new URI("/taxi/view/reg-user-error.jsp")).build();
        boolean isUnique = false;
        User user = new User();
        EmailOrPhone emailOrPhone = new EmailOrPhone();
        List<User> users = unMarshalOrders().getOrder().stream().map(Order::getUser).collect(Collectors.toList());
        if (mail.matches("(\\+380\\d{9})|(0\\d{9})"))
            emailOrPhone.setPhone(mail);
        else if (!mail.matches(("^([_a-zA-Z0-9-]+(\\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{1,6}))?$")))
            return Response.temporaryRedirect(new URI("/taxi/view/reg-user-error.jsp")).build();
        else
            emailOrPhone.setEmail(mail);
        user.setAnswer(emailOrPhone);
        if (!name.isBlank())
            user.setName(name);
        if (!surname.isBlank())
            user.setSurname(surname);
        while (!isUnique) {
            int id = new Random().nextInt(10000);
            if (users.stream().noneMatch(u -> u.getId() == id)) {
                isUnique = true;
                user.setId(id);
            }
        }

        try {
            Marshaller marshaller = JAXBContext.newInstance(ua.lb4.restserver.model.user.ObjectFactory.class).createMarshaller();
            JAXBElement<User> juser = new JAXBElement<>(
                    new QName(LINK.USER, "user"),
                    User.class, user);
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.marshal(juser, new File(LINK.USER_FILE));
        } catch (JAXBException e) {
            throw new RuntimeException(e);
        }
        Date time = Date.from(LocalDateTime.now().plusYears(1).atZone(ZoneId.systemDefault()).toInstant());
        log.info("Створено користувача\n");
        return Response.temporaryRedirect(new URI("/taxi/rest")).cookie(new NewCookie("ID", String.valueOf(user.getId()),"/", null, Cookie.DEFAULT_VERSION,null, 366*60*60*24, time, false, false)).build();
    }


    @GET
    @Path("sendOrder")
    @Produces(MediaType.APPLICATION_XML)
    public Response createOrder(@QueryParam("driverId") String id, @QueryParam("from") String from, @QueryParam("to") String to, @QueryParam("mark") String mark) throws URISyntaxException {
        User u = unMarshalUser();
        u.setAddressFrom(from);
        u.setAddressTo(to);
        List<Driver> drivers = unMarshalDriver().getDriver();
        Driver d = drivers.stream().filter(driver -> driver.getId() == Integer.parseInt(id)).findFirst().get();

        Order order = new Order();
        order.setId(new Random().nextInt(1000));
        order.setDriver(d);
        order.setUser(u);
        order.setPrice(BigDecimal.valueOf(new Random().nextInt(1000)));
        order.setMark(Integer.parseInt(mark));

        Orders orders = unMarshalOrders();
        orders.getOrder().add(order);

        try {
            Marshaller marshaller = JAXBContext.newInstance(ua.lb4.restserver.model.order.ObjectFactory.class).createMarshaller();
            JAXBElement<Orders> jorder = new JAXBElement<>(
                    new QName(LINK.ORDER, "orders"),
                    Orders.class, orders);
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.marshal(jorder, new File(LINK.ORDERS_FILE));
        } catch (JAXBException e) {
            throw new RuntimeException(e);
        }


        long drives = unMarshalOrders().getOrder().stream().filter(o -> o.getDriver().getId() == Integer.parseInt(id)).count();
        long marks = ((unMarshalOrders().getOrder().stream().filter(o -> o.getDriver().getId() == Integer.parseInt(id)).collect(Collectors.summingLong(o -> o.getMark()))) * 100) / drives;
        double floatMarks = (double) marks / 100;

        drivers.forEach(driver -> {
            if (driver.getId() == Integer.parseInt(id))
                driver.setMark(BigDecimal.valueOf(floatMarks));
        });
        Drivers drivers1 = new Drivers();
        drivers1.getDriver().clear();
        drivers1.getDriver().addAll(drivers);

        try {
            Marshaller marshaller = JAXBContext.newInstance(ua.lb4.restserver.model.driver.ObjectFactory.class).createMarshaller();
            JAXBElement<Drivers> jdriver = new JAXBElement<>(
                    new QName(LINK.DRIVER, "drivers"),
                    Drivers.class, drivers1);
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.marshal(jdriver, new File(LINK.DRIVER_FILE));
        } catch (JAXBException e) {
            throw new RuntimeException(e);
        }


        log.info("Створено замовлення");
        return Response.temporaryRedirect(new URI("/taxi/rest")).build();
    }

    @GET
    @Path("userHistory/{id}")
    @Produces(MediaType.APPLICATION_XML)
    public void getHistory(@Context HttpServletRequest request, @Context HttpServletResponse response, @PathParam("id") String id,
                           @QueryParam("option") String option, @QueryParam("mark") String optionValue) throws ServletException, IOException {
        List<Order> orders = unMarshalOrders().getOrder().stream().filter(o -> o.getUser().getId() == Integer.parseInt(id)).collect(Collectors.toList());
        List<Order> ordersToReturn = new ArrayList<>();
        boolean isFilter = false;
        if (option != null && optionValue != null) {
            if (!option.isBlank() && !optionValue.isBlank()) {
                if (option.equals("вище")) {
                    ordersToReturn = orders.stream().filter(o -> o.getMark() >= Integer.parseInt(optionValue)).collect(Collectors.toList());
                    isFilter = true;
                }
                if (option.equals("нижче")) {
                    ordersToReturn = orders.stream().filter(o -> o.getMark() <= Integer.parseInt(optionValue)).collect(Collectors.toList());
                    isFilter = true;
                }
            }
        }
        if (isFilter)
            request.setAttribute("orders", ordersToReturn);
        else
            request.setAttribute("orders", orders);
        log.info("Надано список замовлень користувача з ID: " + id);
        request.getRequestDispatcher("/view/history.jsp").forward(request, response);
    }


    @GET
    @Path("operations")
    @Produces(MediaType.APPLICATION_XML)
    public String getOp(@CookieParam("ID") String value) {
        if(value==null){
            return "0";
        }
        return value;
    }

    @GET
    @Path("drivers")
    @Produces(MediaType.APPLICATION_XML)
    public void getDrivers(@Context HttpServletRequest request, @Context HttpServletResponse response,
                           @QueryParam("clas") String clas, @QueryParam("color") String color, @QueryParam("mark") String mark, @QueryParam("search") String search) throws ServletException, IOException {
        List<Driver> drivers = unMarshalDriver().getDriver();
        List<Driver> driversToReturn = new ArrayList<>();
        boolean isMark = false;
        boolean isColor = false;
        boolean isClas = false;
        boolean isSearch = false;
        if (mark != null) {
            if (!mark.isBlank()) {
                drivers.forEach(d -> {
                    if (d.getMark().intValue() >= Integer.parseInt(mark))
                        driversToReturn.add(d);
                });
                isMark = true;
            }
        }

        if (color != null) {
            if (!color.isBlank()) {
                if (isMark) {
                    List<Driver> buffer = List.copyOf(driversToReturn);
                    driversToReturn.clear();
                    buffer.forEach(d -> {
                        if (d.getCar().getColor().equals(color))
                            driversToReturn.add(d);
                    });
                } else {
                    drivers.forEach(d -> {
                        if (d.getCar().getColor().equals(color))
                            driversToReturn.add(d);
                    });
                }
                isColor = true;
            }
        }

        if (clas != null) {
            if (!clas.isBlank()) {
                if (isMark || isColor) {
                    List<Driver> buffer = List.copyOf(driversToReturn);
                    driversToReturn.clear();
                    buffer.forEach(d -> {
                        if (d.getCar().getClas().equals(clas))
                            driversToReturn.add(d);
                    });
                } else {
                    drivers.forEach(d -> {
                        if (d.getCar().getClas().equals(clas))
                            driversToReturn.add(d);
                    });
                }
                isClas = true;
            }
        }

        if (search != null) {
            if (!search.isBlank()) {
                List<String> searchedWords = Arrays.asList(search.split(" "));
                if (isMark || isColor || isClas) {
                    List<Driver> buffer = List.copyOf(driversToReturn);
                    driversToReturn.clear();
                    for (Driver d : buffer) {
                        for (String word : searchedWords) {
                            if (d.getCar().getName().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getCar().getBrand().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getCar().getNumber().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getName().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getSurname().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (String.valueOf(d.getCar().getYearOfProduction()).equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                        }
                    }
                } else {
                    for (Driver d : drivers) {
                        for (String word : searchedWords) {
                            if (d.getCar().getName().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getCar().getBrand().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getCar().getNumber().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getName().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (d.getSurname().equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                            if (String.valueOf(d.getCar().getYearOfProduction()).equalsIgnoreCase(word) && driversToReturn.stream().noneMatch(driver -> driver.getId() == d.getId()))
                                driversToReturn.add(d);
                        }
                    }
                }
                isSearch = true;
            }
        }
        if (!isColor && !isClas && !isMark && !isSearch)
            request.setAttribute("drivers", drivers);
        else
            request.setAttribute("drivers", driversToReturn);
        log.info("Проведено фільтрацію");
        request.getRequestDispatcher("/view/drivers.jsp").forward(request, response);
    }
}
