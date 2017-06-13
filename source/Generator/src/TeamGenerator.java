import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Random;
import java.util.Scanner;

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

	static String generatePlayer(int id, int sex, int nationality)
	{

		sex = randSex(sex);


		return "(" + id + ", '" + (sex == 1 ? Arrays.getMaleName() : Arrays.getFemaleName())
				+ "', '" + Arrays.getSurname() + "', " + nationality + ", '" + generateDate() + "', " + sex + ")";
	}

	static String insert(String table)
	{
		return "INSERT INTO " + table + " VALUES";
	}

	public static void main(String[] args)
	{
		Random random = new Random();
		Scanner scanner = new Scanner(System.in);
		System.out.println("Podaj numer teamu: ");
		int teamID = scanner.nextInt();
		System.out.println("Podaj dyscypline: ");
		int discipline = scanner.nextInt();
		System.out.println("Podaj płeć");
		int sex = scanner.nextInt();
		System.out.println("Podaj ilość osób w drużynie: ");
		int n = scanner.nextInt();
		System.out.println("Podaj pierwsze id: ");
		int firstId = scanner.nextInt();
		int nationality = random.nextInt(244);


		System.out.println(insert("teams") + "(" + teamID + ", " + sex + ", " + discipline + ", " + nationality + ");");

		for(int i = 0; i < n; i++)
		{
			System.out.println(insert("players") + generatePlayer(i + firstId, sex, nationality) + ";");
			System.out.println("Insert Into player_team VALUES (" + (firstId + i) + ", " + teamID + ");");
			System.out.println("Insert Into weights VALUES (" + (firstId + i) + ", " + (50 + random.nextInt(30)) + ", '" + generateDate(2017, 1, 1) + "');");
		}

	}


	//generator finałów

	//ustawiam dyscypline, liczbe graczy, druzyn, nastepnie eliminacje funkcje tworzaca wynik
}
