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
	-events
		pomocnicza pomiędzy rozgrykami i druzynami
	-event_team_result
		wynik rozgrywek
	-finals
		etapy rozgrywek


	Wyzwalacze:
	-event_team_result_insert
		sprawdza poprawność danych drużyny
	

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
	
