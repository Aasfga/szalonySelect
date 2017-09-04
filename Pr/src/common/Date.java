package common;

import java.util.GregorianCalendar;
import common.generators.Communication;
import common.generators.Randomise;
import sun.security.tools.keytool.Main;

import static common.generators.Communication.enter;

public class Date {

    public static String manually(){
        Communication.hello("date");

        String day = enter("day");
        String month = enter("month");
        String year =  enter("year");

        return day + "-" + month + "-" + year;
    }

    public static String generateOlympic(){
        int day =  MainApp.randomise.randomFromBetween(10,31);

        if( day > 20) {
            return "2017-06" + "-" + day;
        } else {
            return "2017-07" + "-" + day;
        }
    }

    public static String generateBirthDay(){
        GregorianCalendar gc = new GregorianCalendar();

        int year = MainApp.randomise.randomFromBetween(1980, 2000);

        gc.set(gc.YEAR, year);

        int dayOfYear = MainApp.randomise.randomFromBetween(1, gc.getActualMaximum(gc.DAY_OF_YEAR));

        gc.set(gc.DAY_OF_YEAR, dayOfYear);

        String month = String.valueOf((gc.get(gc.MONTH) + 1));
        if( month.length() < 2){
            month = "0" + month;
        }

        String day = String.valueOf((gc.get(gc.DAY_OF_MONTH) + 1));
        if( day.length() < 2){
            day = "0" + day;
        }

        return gc.get(gc.YEAR) + "-" + month + "-" + day;
    }
}




