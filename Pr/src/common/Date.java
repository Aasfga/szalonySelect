package common;

import common.generators.Communication;

import static common.generators.Communication.enter;

public class Date {

    public static String manually(){
        Communication.hello("date");

        String day = enter("day");
        String month = enter("month");
        String year =  enter("year");

        //TODO check fields

        return day + "-" + month + "-" + year;
    }
}
