import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Random;

public class TeamGenerator
{

	static String generateDate()
	{
		Random random = new Random();

		return (random.nextInt(15) + 1990) + "-" + (random.nextInt(11) + 1) + "-" + (random.nextInt(20) + 1);
	}

	static String generateDate(int year, int month, int day)
	{

		return year + "-" + month + "-" + day;
	}

	static int randSex(int teamSex)
	{
		if(teamSex == 0)
		{
			return new Random().nextInt(2) + 1;
		} else
			return teamSex;
	}

	static String generatePlayer(int id, int teamSex, int nationality)
	{
		Random random = new Random();

		String maleNames[] = new String[]
				{
						"Jaylon",
						"Andres",
						"Ibrahim",
						"Dorian",
						"Camden",
						"Ronin",
						"Donald",
						"Felix",
						"Ricardo",
						"Osvaldo",
						"Camryn",
						"Jaron",
						"Noel",
						"Hezekiah",
						"Darwin",
						"Tanner",
						"Vaughn",
						"Alex",
						"Chris",
						"Arturo",
						"Cason",
						"Ezekiel",
						"Emerson",
						"Russell",
						"Joseph",
						"Konnor",
						"Darrell",
						"Parker",
						"Eliezer",
						"Peter",
						"Anderson",
						"Valentin",
						"Levi",
						"Talan",
						"Brogan",
						"Franco",
						"Drew",
						"Giovanny",
						"Omari",
						"Jayce",
						"Darren",
						"Lewis",
						"Bernard",
						"Ramiro",
						"Kash",
						"Karter",
						"Zayden",
						"Shawn",
						"Zechariah",
						"Kane",
						"Fletcher",
						"Rashad",
						"Kendall",
						"Kai",
						"Urijah",
						"London",
						"Rogelio",
						"Makhi",
						"Salvatore",
						"Kyle",
						"Baron",
						"Chandler",
						"Kolten",
						"Bryant",
						"Damarion",
						"Octavio",
						"Darnell",
						"Raul",
						"Preston",
						"Thaddeus",
						"Isai",
						"Deacon",
						"Atticus",
						"Ronald",
						"Edwin",
						"Clarence",
						"Valentin",
						"Yahir",
						"Fabian",
						"Cole",
						"Max",
						"Peter",
						"Colt",
						"Marshall",
						"Orion",
						"Kamari",
						"Damien",
						"Jayce",
						"Donte",
						"Juan",
						"Hugo",
						"Arnav",
						"Myles",
						"Conor",
						"Drew",
						"Ralph",
						"Rey",
						"Silas",
						"Daniel",
						"Aidyn",
						"Dario",
						"Micah",
						"Ezra",
						"Mateo",
						"Jamar",
						"Wade",
						"August",
						"Jamarcus",
						"Moshe",
						"Mekhi",
						"Wilson",
						"Frankie",
						"Alfonso",
						"Moises",
						"Porter",
						"Aarav",
						"Kane",
						"Fletcher",
						"Royce",
						"Brennan",
						"Ulises",
						"Fabian",
						"Duncan",
						"Jaxon",
						"Miguel",
						"Armani",
						"Maximilian",
						"Marcel",
						"Brenden",
						"Rylee",
						"Chace",
						"Jose",
						"Damion",
						"Tanner",
						"Gunner",
						"Giovanny",
						"Bobby",
						"Conrad",
						"Clark",
						"Xzavier",
						"Marco",
						"Dean",
						"Bradyn",
						"Keenan",
						"Christian",
						"Davion",
						"Yahir",
						"Deon",
						"Harrison",
						"Max"
				};
		String femaleNames[] = new String[]
				{
						"Danika",
						"Lizeth",
						"Selina",
						"Isabella",
						"Annie",
						"Jaliyah",
						"Katelyn",
						"Jaylah",
						"Adriana",
						"Savanna",
						"Karli",
						"Jamiya",
						"Rowan",
						"Juliette",
						"Holly",
						"Noelle",
						"Keira",
						"Caylee",
						"Payton",
						"Liana",
						"Katrina",
						"Kendall",
						"Angeline",
						"Aracely",
						"Sophia",
						"Shiloh",
						"Harley",
						"Rosemary",
						"Parker",
						"Tanya",
						"Alejandra",
						"Stella",
						"Myah",
						"Reyna",
						"Hannah",
						"Amaris",
						"Diana",
						"Alaina",
						"Jessie",
						"Bianca",
						"Nathalie",
						"Nyla",
						"Camille",
						"Leanna",
						"Cali",
						"Aliana",
						"Bailey",
						"Tia",
						"Miranda",
						"Paige",
						"Shiloh",
						"Holly",
						"Samara",
						"Athena",
						"Krystal",
						"Meghan",
						"Melanie",
						"Makaila",
						"Riley",
						"Rosa",
						"Olivia",
						"Kristina",
						"Eileen",
						"Charlie",
						"Briley",
						"Tia",
						"Shania",
						"Jaylee",
						"Leila",
						"Donna",
						"Sydney",
						"Paris",
						"Bridget",
						"Trinity",
						"Kailyn",
						"Erin",
						"Hope",
						"Ava",
						"Camille",
						"Gracie",
						"Mattie",
						"Cadence",
						"Kaia",
						"Maya",
						"Alyssa",
						"Monique",
						"Armani",
						"Mckenzie",
						"Hayley",
						"Aubree",
						"Daphne",
						"Karlee",
						"Rory",
						"Aurora",
						"Lorena",
						"Maddison",
						"Amaya",
						"Sydnee",
						"Yazmin",
						"Naomi",
						"Michaela",
						"Daniela",
						"Mackenzie",
						"Lauryn",
						"Selina",
						"Adelyn",
						"Arely",
						"Felicity",
						"Claire",
						"Annie",
						"Averie",
						"Monique",
						"Alyssa",
						"Clara",
						"Shaylee",
						"Brianna",
						"Jakayla",
						"Camryn",
						"Marina",
						"Tanya",
						"Talia",
						"Ingrid",
						"Jade",
						"Janiya",
						"Olivia",
						"Anabelle",
						"Alejandra",
						"Rebekah",
						"Joyce",
						"Alexandra",
						"Madalynn",
						"Allyson",
						"Janae",
						"Raina",
						"Nadia",
						"Emery",
						"Tessa",
						"Kennedi",
						"Aliya",
						"Jessie",
						"Alexa",
						"Amirah",
						"Caylee",
						"Destiney",
						"Lana",
						"Ashleigh",
						"Ashlyn",
						"Ivy",
						"Marlene",
						"Livia"
				};

		String surnames[] = new String[]
				{
						"Corbyn",
						"Smith",
						"Brown",
						"Taylor",
						"Johnson",
						"Walker",
						"Wright",
						"Thompson",
						"Robinson",
						"White",
						"Hall",
						"Green",
						"Martin",
						"Wood",
						"Harris",
						"Clarke",
						"Jackson",
						"Clark",
						"Turner",
						"Hill",
						"Moore",
						"Cooper",
						"Ward",
						"King",
						"Watson",
						"Harrison",
						"Baker",
						"Young",
						"Allen",
						"Anderson",
						"Mitchell",
						"Bell",
						"Lee",
						"Parker",
						"Davis",
						"Bennett",
						"Miller",
						"Shaw",
						"Cook",
						"Richardson",
						"Marshall",
						"Collins",
						"Carter",
						"Bailey",
						"Gray",
						"Cox",
						"Adams",
						"Wilkinson",
						"Foster",
						"Chapman",
						"Russell",
						"Mason",
						"Webb",
						"Rogers",
						"Hunt",
						"Holmes",
						"Mills",
						"Palmer",
						"Matthews",
						"Fisher",
						"Barnes",
						"Knight",
						"Harvey",
						"Jenkins",
						"Barker",
						"Butler",
						"Pearson",
						"Stevens",
						"Dixon",
						"Hunter",
						"Fletcher",
						"Elliott",
						"Andrews",
						"Reynolds",
						"Fox",
						"Howard",
						"Ford",
						"Bradley",
						"Saunders",
						"Payne",
						"Armstrong",
						"West",
						"Walsh",
						"Pearce",
						"Day",
						"Dawson",
						"Brooks",
						"Atkinson",
						"Cole",
						"Lawrence",
						"Burns",
						"Ball",
						"Burton",
						"Williamson",
						"Spencer",
						"Booth",
						"Rose",
						"Webster",
						"Perry",
						"Watts",
						"Hart",
						"Wells",
						"Dunn",
						"Woods",
						"Stevenson",
						"Porter",
						"Hudson",
						"Hayes",
						"Lowe",
						"Carr",
						"Newman",
						"Page",
						"Berry",
						"Barrett",
						"Gregory",
						"Francis",
						"Oliver",
						"Marsh",
						"Gardner",
						"Stone",
						"Holland",
						"Riley",
						"Parsons",
						"Newton",
						"Hawkins",
						"Bird",
						"Harding",
						"Reed",
						"Nicholson",
						"Cooke",
						"Dean",
						"Shepherd",
						"Harper",
						"Cunningham",
						"Bates",
						"Burgess",
						"Lane",
						"Sharp",
						"Walton",
						"Bishop",
						"Cross",
						"Robson",
						"Warren",
						"Long",
						"Freeman",
						"Chambers",
						"Sutton",
						"Yates",
						"Nicholls",
						"Hodgson"
				};

		String person = "(" + id;

		if(teamSex == 0)
			teamSex = randSex(teamSex);
		if(teamSex == 1)
		{
			person += ", '" + maleNames[random.nextInt(150)] + "', '" + surnames[random.nextInt(150)];
		}
		if(teamSex == 2)
			person += ", '" + femaleNames[random.nextInt(150)] + "', '" + surnames[random.nextInt(150)];

		person += "', " + nationality + ", '" + generateDate() + "', " + teamSex + ")";

		return person;
	}

	//args 1:numer teamu 2:dyscyplina 3:ile_osób 4:pierwszeid
	public static void main(String[] args)
	{
		Random random = new Random();
		int team_number = Integer.valueOf(args[0]);
		int n = Integer.valueOf(args[2]);
		int dysc = Integer.valueOf(args[1]);
		int firstId = Integer.valueOf(args[3]);
		int team_sex = random.nextInt(3);
		int nationality = random.nextInt(245);


		System.out.println("Insert Into teams Values (" + team_number + ", " + team_sex + ", " + dysc + ", " + nationality + ");");

		for(int i = 0; i < n; i++)
		{
			System.out.println("Insert Into players VALUES " + generatePlayer(firstId + i, team_sex, nationality) + ";");
			System.out.println("Insert Into player_team VALUES (" + (firstId + i) + ", " + team_number + ");");
			System.out.println("Insert Into weights VALUES (" + (firstId + i) + ", " + (50 + random.nextInt(30)) + ", '" + generateDate(2017, 1, 1) + "')");
		}

	}
}
