import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.Random;

public class PlayerStatement {

//    public static String generateManually(Scanner scanner) {
//
//        System.out.println("Give sex ID:");
//
//        String wybor = scanner.next();
//        System.out.println("");
//        return null;
//    }


    public static String generateAuto() throws SQLException {

        String sex = generateIDSex();
        //1 - male, 2 - female

        String firstName;
        if( sex.equals(1)){
            firstName = generateMaleName();
        }else {
            firstName = generateFemaleName();
        }

        String lastName = generateLastName();
        String nationality = generateNationality();
        String date = generateDate();

        String sql = "INSERT INTO players VALUES(DEFAULT, \'" + firstName + "\', \'" + lastName + "\'," + nationality + ",\'" + date + "\'," + sex + ");";
        Main.statement.execute(sql);

        return null;
    }


    public static String generateIDSex() throws SQLException {

        String sql = "SELECT * FROM sexes;";
        ResultSet rs = Main.statement.executeQuery(sql);
        ArrayList<String> ids = Main.columnFromResultSet(rs,1);

        int rand = Main.randomFromRange(0,ids.size()-1);

        return ids.get(rand);
    }



    public static String generateFemaleName() {

        String[] femaleNames = {
                "Robena",
                "Doreen",
                "Concepcion",
                "Raelene",
                "Easter",
                "Geralyn",
                "Lezlie",
                "Inge",
                "Jacquelynn",
                "Necole",
                "Danita",
                "Jacelyn",
                "Sharika",
                "Charline",
                "Marlana",
                "Deandrea",
                "Marcella",
                "May",
                "Blanche",
                "Mechelle",
                "Danyell",
                "Corine",
                "Jeanie",
                "Susanne",
                "Chasity",
                "Kaye",
                "Terri",
                "Hermelinda",
                "Lucrecia",
                "Jeanette",
                "Isabella",
                "Azalee",
                "Tracie",
                "Jannette",
                "Madaline",
                "Sherika",
                "Echo",
                "Maile",
                "Hertha",
                "Cecille",
                "Deirdre",
                "Magen",
                "Beatris",
                "Aleta",
                "Ngoc",
                "Elke",
                "Rose",
                "Jann",
                "Kum",
                "Izetta",
                "See",
                "Elaina",
                "Joi",
                "Elva",
                "Ninfa",
                "Carin",
                "Jacklyn",
                "Camelia",
                "Marguerite",
                "Emmie",
                "Jaquelyn",
                "Luann",
                "Candice",
                "Jinny",
                "Rosita",
                "Vonda",
                "Tina",
                "Fredericka",
                "Marla",
                "Noella",
                "Sha",
                "Lucretia",
                "Jacquelin",
                "Dian",
                "Phebe",
                "Alejandra",
                "Laurie",
                "Hellen",
                "Alverta",
                "Marth",
                "Kathlene",
                "Shanti",
                "Leona",
                "Liliana",
                "Xiao",
                "Hallie",
                "France",
                "Soo",
                "Iluminada",
                "Louanne",
                "Christene",
                "Mai",
                "Alyssa",
                "Ladawn",
                "Wan",
                "Daniella",
                "Ellena",
                "Felipa",
                "Justina",
                "Shavonne",
        };

        int rand = Main.randomFromRange(0,femaleNames.length-1);
        System.out.println(rand);
        return femaleNames[rand];
    }

    public static String generateMaleName() {

        String[] maleNames = {
                "Mohammad",
                "Ricky",
                "Earle",
                "Rodolfo",
                "Miguel",
                "Brain",
                "Bernie",
                "Luciano",
                "Percy",
                "Leroy",
                "Charles",
                "Leo",
                "Henry",
                "Cedric",
                "Allen",
                "Michal",
                "Wesley",
                "Levi",
                "Cortez",
                "Ben",
                "Toney",
                "Connie",
                "Orlando",
                "Robbie",
                "Oliver",
                "Burl",
                "Reginald",
                "Danial",
                "Colin",
                "Douglass",
                "Major",
                "Samual",
                "Leigh",
                "Stephen",
                "Alexander",
                "Arthur",
                "Virgil",
                "Abram",
                "Otto",
                "Josef",
                "Ricardo",
                "Nathanial",
                "Lyndon",
                "Abraham",
                "Gale",
                "Jere",
                "Rusty",
                "Barney",
                "Noel",
                "Marcelino",
                "Zackary",
                "Lanny",
                "Rudolf",
                "Chang",
                "Paul",
                "Gil",
                "Alden",
                "Homer",
                "Ali",
                "Wilburn",
                "Dannie",
                "Olen",
                "Clement",
                "Nick",
                "Ramon",
                "Neil",
                "James",
                "Antonia",
                "Marcos",
                "Shelby",
                "Alphonse",
                "Russ",
                "Elden",
                "Giovanni",
                "Sanford",
                "Rickey",
                "Errol",
                "Sidney",
                "Joe",
                "Seymour",
                "King",
                "Damon",
                "Kory",
                "Bret",
                "Everette",
                "Eldridge",
                "Alvaro",
                "Marc",
                "Fredric",
                "Ervin",
                "Cristobal",
                "Bernardo",
                "Jayson",
                "Rene",
                "Dallas",
                "Robin",
                "Dewitt",
                "Brad"};
        int rand = Main.randomFromRange(0, maleNames.length - 1);
        return maleNames[rand];
    }

    public static String generateLastName() {
        String[] lastNames = {
                "Hansen",
                "Summers",
                "Cantu",
                "Curry",
                "Campbell",
                "Dalton",
                "Sampson",
                "Benson",
                "Richardson",
                "Cox",
                "Gibbs",
                "Shannon",
                "Fitzgerald",
                "Bailey",
                "Ramirez",
                "Black",
                "Patel",
                "Peters",
                "Clements",
                "Benjamin",
                "Payne",
                "Valencia",
                "Haney",
                "Werner",
                "Davidson",
                "Cooke",
                "Daugherty",
                "Beltran",
                "Shaw",
                "Blackwell",
                "Knox",
                "Ritter",
                "Delgado",
                "Zavala",
                "Francis",
                "Beasley",
                "Ewing",
                "Harrison",
                "Bird",
                "Riggs",
                "Dodson",
                "Green",
                "Burton",
                "Petersen",
                "Chung",
                "Hobbs",
                "Clarke",
                "Cross",
                "Craig",
                "Downs",
                "Daniel",
                "Nichols",
                "Palmer",
                "Huffman",
                "Gilmore",
                "Rollins",
                "Woods",
                "Gould",
                "Holt",
                "Carney",
                "Murillo",
                "Hutchinson",
                "Parsons",
                "Rivera",
                "Suarez",
                "Garrison",
                "Dyer",
                "Forbes",
                "Ali",
                "Andrews",
                "Shah",
                "Solis",
                "Kent",
                "Thornton",
                "Meyers",
                "Stafford",
                "Stanley",
                "Wilkerson",
                "Tran",
                "Rice",
                "Clayton",
                "Petty",
                "Pearson",
                "Henderson",
                "Gaines",
                "Atkinson",
                "Moreno",
                "Berry",
                "Woodward",
                "Mclean",
                "Haynes",
                "Vega",
                "Donaldson",
                "Douglas",
                "Cordova",
                "Kaiser",
                "Richmond",
                "Arnold",
                "Whitaker",
                "Cuevas"
        };
        int rand = Main.randomFromRange(0,lastNames.length-1);
        return lastNames[rand];
    }

    public static String generateNationality() throws SQLException {

        String sql = "SELECT * FROM nationalities;";
        ResultSet rs = Main.statement.executeQuery(sql);
        ArrayList<String> ids = Main.columnFromResultSet(rs,1);

        int rand = Main.randomFromRange(0,ids.size()-1);

        return ids.get(rand);
    }


    public static String generateDate(){
        GregorianCalendar gc = new GregorianCalendar();

        int year = randBetween(1900, 2010);

        gc.set(gc.YEAR, year);

        int dayOfYear = randBetween(1, gc.getActualMaximum(gc.DAY_OF_YEAR));

        gc.set(gc.DAY_OF_YEAR, dayOfYear);

        System.out.println(gc.get(gc.YEAR) + "-" + (gc.get(gc.MONTH) + 1) + "-" + gc.get(gc.DAY_OF_MONTH));


        Random random = new Random();
        int minDay = (int) LocalDate.of(1900, 1, 1).toEpochDay();
        int maxDay = (int) LocalDate.of(2015, 1, 1).toEpochDay();
        long randomDay = minDay + random.nextInt(maxDay - minDay);

        LocalDate randomBirthDate = LocalDate.ofEpochDay(randomDay);

        return randomBirthDate.toString();
    }

    public static int randBetween(int start, int end) {
        return start + (int)Math.round(Math.random() * (end - start));
    }
}
