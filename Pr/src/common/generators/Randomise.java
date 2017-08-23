package common.generators;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Random;


public class Randomise {

    private final Statement statement;
    private final Preparer preparer;

    public Randomise(Statement statement){
        this.statement = statement;
        preparer = new Preparer(statement);
    }

    public long randomFromBetween(long a, long b ) {
        Random random = new Random();
        return a + Math.abs(random.nextInt())%(b-a+1);
    }

    public int randomFromBetween(int a, int b ) {
        Random random = new Random();
        return a + Math.abs(random.nextInt())%(b-a+1);
    }

    public String randomIdFromTable(String table ) throws SQLException {

        String sql = "SELECT * FROM " + table + ";";
        ResultSet rs = statement.executeQuery(sql);
        ArrayList<String> ids = preparer.arrayFromResultSetColumn(rs,1);

        int rand = randomFromBetween(0,ids.size()-1);

        return ids.get(rand);
    }

    public String generateFemaleName() {

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

        int rand = randomFromBetween(0,femaleNames.length-1);

        return femaleNames[rand];
    }

    public String generateMaleName() {

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
        int rand = randomFromBetween(0, maleNames.length - 1);
        return maleNames[rand];
    }

    public String generateLastName() {
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

        int rand = randomFromBetween(0, lastNames.length - 1);
        return lastNames[rand];
    }

    public String generateBirthTime(){
        Timestamp timestamp = new Timestamp( randomFromBetween(400000000000L,1000000000000L) );
        return timestamp.toString();
    }

    public String generateOlympicTime(){
        Timestamp timestamp = new Timestamp( randomFromBetween(1498000000000L,1500000000000L));
        return timestamp.toString();
    }
}
