Names: De naamgeving wordt consistent gedaan met camel case. Dit is in de gehele code te zien.    

Headers: Er staat bijna boven elke functie een header met een korte beschrijving van de functie. Alleen staat er niet bij hoe de functie gebruikt moet worden. Dit is het geval bij elke header.
Dit moet dus verbeterd worden door in elke header te beschrijven hoe de functie gebruikt moet worden.    

Comments: Er zijn duidelijke comments geschreven waar nodig. Bij lange blokken staat er een comment met een beschrijving van het blok.    

Layout: Functies die bij elkaar horen staan bij elkaar. Makkelijk te zien wat er bij elkaar hoort. Dit is in de gehele code te zien.

Formatting: Er is gezegd dat de formatting goed is. De indentation, line breaks en het gebruik van spaties en haakjes worden goed gedaan. Dit is in de gehele code te zien. Dit gaat dus goed, en zal ook zo worden gedaan in volgende opdrachten.

Flow: Code is niet diep genest, de flow zelf is ook duidelijk te begrijpen als een verhaal. Weinig duplicates (Zie idiom2 en modularization.)

Idiom: Voor het opslaan van de resultaten wordt er gebruik gemaakt van een array van dictionaries.  Dit is niet erg handig, want grote kans op fouten, omdat je veel moet nadenken over hoe het allemaal wordt opgeslagen. Daardoor ook tijdje problemen gehad met conversion van AnyObject.
Dit is te zien in de functie getData in SearchViewController.
Het is handiger om een struct te gebruiken, omdat er dan verder geen omkijken is naar data conversion in verschillende functies.

Idiom2: De OMDb API wordt voor elke view apart aangeroepen. Zou mooier, overzichtelijker en efficiënter zijn als dit eenmalig wordt gedaan en alle informatie die bij een film hoort dan opgeslagen wordt zodat dit hergebruikt kan worden. Dit is te zien in SearchViewController, SavedViewController en DetailedViewController waar dataTask wordt gebruikt.

Decomposition: Code is goed opgesplitst in functies, waarvan sommigen vaker gebruikt worden.

Modularization: Het invullen van de TableViewCell vindt plaats in SearchViewController/SavedViewController. Logischer en ook consistenter als dit in de eigen module SingleResultTableViewCell gebeurt. Nu wordt het namelijk voor een zelfde soort cell in verschillende modules gedaan. Met een get/set zou het mooier zijn.


