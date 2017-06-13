Opis bazy:
	Tabele:
	-nationalities
		informacje o krajach reprezentowanych przez zawodników
	-sexes
		p³cie zawodników
	-categories
		kategorie w jakich startuj¹ zawodnicy, zawiera informacje o liczbie graczy w druzynie, ilosci druzyn na olimpiadzie
	-disciplines
		dyscypliny na olimpiadzie (kategorie, p³eæ zawodników)
	-players 
		zawodnicy (imiê,nazwisko,kraj,p³eæ)
	-weights
		dane z wazenia zawodników
	-teams
		informacje o reprezentacjach
	-player_team
		pomocnicza tabela przejœciowa pomiêdzy graczami i dru¿ynami
	-places
		obiekty sportowe
	-judges
		sêdziowie
	-event
		rozgrywki
	-judge_game
		pomocnicza pomiêdzy sêdziami i rozgrykami
	-event_team
		pomocnicza pomiêdzy rozgrykami i druzynami
	-scoreResults
		wyniki danego meczu
	-timeResults
		czasy zawodników
	-noteResults
		noty przydzielone przez sêdziów
	-finals
		etapy rozgrywek
	

	Wyzwalacze:
	-team_insert
		sprawdza poprawnoœæ danych dru¿yny
	-sex_change_team
		sprawdza czy zawodnicy danej p³ci rywalizuj¹ w swojej kategorii
	-result_after_finish
		sprawdza czy czas rozgrywki jest poprawny
	-number_of_teams
		sprawdza czy odpowiednia iloœæ druzyn startuje w danej dyscyplinie
	