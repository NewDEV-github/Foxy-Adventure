extends Node #klasa dziedziczona w skrypcie
var cfile = ConfigFile.new() #instancjuje klase ConfigFile, uzywana do obslugi plikow *.cfg w kodzie gry

func save_progress():
	cfile.load("user://save.cfg") #laduje plik przed modyfikacja. Bez uprzedniego zaladowania plik zostanie nadpisany calkowicie po zapisie
	cfile.set_value("game save", "stage", "001") #ustawia wartosc w kluczu w sekcji pliku konfiguracyjnego.  Jesli nie ma klucza badz wartosci, utworzy je
	cfile.save("user://save.cfg") #zapisuje plik
func load_progress():
	cfile.load("user://save.cfg") #laduje plik do odczytu
	if cfile.has_section_key("game save", "stage"): #sprawdza czy istnieje klucz w podanej sekcji, gdyz jesli by nie istnialy, metoda get_value() zwrocila by blad o nie istniejacym kluczu w sekjcji
		var stage = cfile.get_value("game save", "stage", "01") #pobiera wartosc z danego klucza w danej sekcji. 3 argument to wartosc domyslna, ktora zwracana jest w przypadku bledu innego niz brak klucza podanego w drugim argumencie
		return stage #zwraca wartosc z klucza stage w sekcji game save
