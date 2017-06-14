Opis bazy:

	Tabele:
	-categories
		kategorie w jakich startują zawodnicy, zawiera informacje o liczbie graczy w druzynie, ilosci druzyn na olimpiadzie
	-disciplines
		dyscypliny na olimpiadzie (kategorie, płeć zawodników)
	-nationalities
		informacje o krajach reprezentowanych przez zawodników
	-sexes
		płcie zawodników
	-players 
		zawodnicy (imię,nazwisko,kraj,płeć)
	-weights
		dane z wazenia zawodników
	-teams
		informacje o reprezentacjach
	-player_team
		pomocnicza tabela przejściowa pomiędzy graczami i drużynami
	-places
		obiekty sportowe
	-judges
		sędziowie
	-event
		rozgrywki
	-judge_game
		pomocnicza pomiędzy sędziami i rozgrykami
	-event_team
		pomocnicza pomiędzy rozgrykami i druzynami
	-scoreResults
		wyniki danego meczu
	-timeResults
		czasy zawodników
	-noteResults
		noty przydzielone przez sędziów
	-finals
		etapy rozgrywek

		
	Wyzwalacze:
	-team_insert
		sprawdza poprawność danych drużyny
	-sex_change_team
		sprawdza czy zawodnicy danej płci rywalizują w swojej kategorii
	-result_after_finish
		sprawdza czy czas rozgrywki jest poprawny
	-number_of_teams
		sprawdza czy odpowiednia ilość druzyn startuje w danej dyscyplinie
	-one_nationality
		sprawdza czy gracze reprezentują swój kraj
	-one_judge_in_game
		sprawdza czy sędzia sędziuje tylko jeden mecz
	-insert_event
		sprawdza kolejność rozgrywek
	
	
	Perspektywy:
	-team_category
		zwraca informacje o reprezentacji każdej kategorii
	-results
		zwraca wyniki wszystkich rozgrywek
	-golden_medal
		złote medale każdej kategorii
	-silver_medal
		srebrne medale każdej kategorii
	-bronze_medal
		brązowe medale każdej kategorii
	
