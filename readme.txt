Opis bazy:
	Tabele:
	-nationalities
		informacje o krajach reprezentowanych przez zawodnik�w
	-sexes
		p�cie zawodnik�w
	-categories
		kategorie w jakich startuj� zawodnicy, zawiera informacje o liczbie graczy w druzynie, ilosci druzyn na olimpiadzie
	-disciplines
		dyscypliny na olimpiadzie (kategorie, p�e� zawodnik�w)
	-players 
		zawodnicy (imi�,nazwisko,kraj,p�e�)
	-weights
		dane z wazenia zawodnik�w
	-teams
		informacje o reprezentacjach
	-player_team
		pomocnicza tabela przej�ciowa pomi�dzy graczami i dru�ynami
	-places
		obiekty sportowe
	-judges
		s�dziowie
	-event
		rozgrywki
	-judge_game
		pomocnicza pomi�dzy s�dziami i rozgrykami
	-event_team
		pomocnicza pomi�dzy rozgrykami i druzynami
	-scoreResults
		wyniki danego meczu
	-timeResults
		czasy zawodnik�w
	-noteResults
		noty przydzielone przez s�dzi�w
	-finals
		etapy rozgrywek
	

	Wyzwalacze:
	-team_insert
		sprawdza poprawno�� danych dru�yny
	-sex_change_team
		sprawdza czy zawodnicy danej p�ci rywalizuj� w swojej kategorii
	-result_after_finish
		sprawdza czy czas rozgrywki jest poprawny
	-number_of_teams
		sprawdza czy odpowiednia ilo�� druzyn startuje w danej dyscyplinie
	