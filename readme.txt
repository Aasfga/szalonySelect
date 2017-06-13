Opis bazy:
	Tabele:
	-nationalities
		informacje o krajach reprezentowanych przez zawodników
	-sexes
		płcie zawodników
	-categories
		kategorie w jakich startują zawodnicy, zawiera informacje o liczbie graczy w druzynie, ilosci druzyn na olimpiadzie
	-disciplines
		dyscypliny na olimpiadzie (kategorie, płeć zawodników)
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
	-results_score
		wyniki danego meczu
	-results_time
		czasy zawodników
	-results_notes
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
	
