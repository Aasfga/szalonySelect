import java.util.Random;
import java.util.Scanner;

public class JudgeGenerator
{
	public static void main(String[] args)
	{
		Random random = new Random();
		Scanner scanner = new Scanner(System.in);
		System.out.println("Size: ");
		int n = scanner.nextInt();
		System.out.println("FirstId: ");
		int firstId = scanner.nextInt();

		for(int i = 0; i < n; i++)
		{
			System.out.println(TeamGenerator.insert("judges") + "(" + (i + firstId) + ", '" + Arrays.getMaleName() + " " + Arrays.getSurname() + "')");
		}
	}
}
