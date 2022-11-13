package ua.lb4.restserver.model.driver;


import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import java.util.ArrayList;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Drivers", propOrder = {
        "driver"
})
@XmlRootElement(name = "drivers")
public class Drivers {
    protected List<Driver> driver;


    public List<Driver> getDriver() {
        if (driver == null) {
            driver = new ArrayList<Driver>();
        }
        return this.driver;
    }

}
