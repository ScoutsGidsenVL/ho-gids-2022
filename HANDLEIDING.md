# Handleiding HO-gids
> Deze handleiding bevat instructies om de HO-gids te updaten.

De HO-gids bestaat uit 3 grote delen: [nieuws](#nieuws), het [programma](#programma) en de [kaart](#kaart). Elk van die delen kan geconfigureerd worden m.b.v. JSON en markdown bestanden, zonder een nieuwe versie te publiceren. Deze data staat in het mapje `assets/content/`.

![navigatie menu met de 3 onderdelen](https://user-images.githubusercontent.com/68152530/236469064-5adb76bc-a2c6-4db6-b38c-2ddc7e83ce39.png)

Opgelet! Aanpassingen of nieuwe afbeeldingen in de map `assets/images/` worden niet geüpdatet zonder een nieuwe app versie te publiceren!

## 1. Nieuws
Nieuws artikels zijn gedefinieerd in [`assets/content/nieuws.json`](/assets/content/nieuws.json). Per artikel zijn er een aantal configuratie mogelijkheden. Enkel `title` is verplicht.

* `title`: De hoofdtekst van het artikel. Wordt ook gebruikt in meldingenen en de app bar.
* `subtitle`: Korte beschrijving van het artikel. Wordt ook gebruikt in meldingen.
* `image`: Een afbeelding om in het klein naast het artikel te gebruiken.
* `body`: De naam van een markdown bestand `assets/content/nieuws/KEY.md` dat de inhoud van het artikel bevat. Als dit veld niet wordt meegegeven kan de gebruiker niet doorklikken op het nieuwsbericht.
* `publishTime`: Het moment waarop dit bericht zichtbaar wordt voor gebruikers. Als dit veld niet wordt meegegeven dan zal dit bericht nooit rechtstreeks worden getoond (er kan wel naar worden gelinked vanuit andere artikels). Het formaat van dit veld wordt [hieronder](#tijd-formaat) beschreven.
* `archiveTime`: Het moment waarop dit bericht verdwijnt van het startscherm (tenzij de gebruiker op "meer nieuws" heeft geklikt). Het formaat van dit veld wordt [hieronder](#tijd-formaat) beschreven.
* `pin`: Als dit `true` is zal het bericht bovenaan op het startscherm staan, en dus boven recentere nieuwsberichten.
* `notify`: Als dit `true` is krijgt de gebruiker hiervoor een melding op met moment dat het bericht gepubliceerd wordt (volgens `publishTime`).

Een voorbeeld van een nieuws artikel:
```json
{
    "title": "DAS Goesting!",
    "subtitle": "Ontdek het jaarthema...",
    "image": "jaarthema.jpg",
    "body": "jaarthema",
    "publishTime": "VR 18:00",
    "archiveTime": "ZO 13:00",
    "pin": true,
    "notify": true
}
```

Weergave van nieuwsberichten in de app:

![](https://user-images.githubusercontent.com/68152530/236467564-c65f72af-b25f-4fdb-9131-e6d2ac9c728d.png)

De nieuws artikels zelf zijn geschreven in [markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) en staan in de map `assets/content/nieuws/`.

Gebruik het volgende formaat om afbeeldingen in het artikel te plaatsen:
```md
![leefregels](resource:assets/images/leefregels.png)
```

Artikels kunnen zelf doorverwijzen naar andere pagina's, bijvoorbeeld:
```md
Kleine ongelukjes: [Rode kruis in gebouw 39](/kaart?id=39)
```

## 2. Programma
Het programma is gedefinieerd in [`assets/content/programma.json`](/assets/content/programma.json). Het programma is opgedeeld in verschillende tabs voor elke dag. Elke gebeurtenis heeft een aantal configuratie mogelijkheden. Enkel `title` en `start` zijn verplicht.

* `title`: De naam van de gebeurtenis. Wordt ook gebruikt in meldingen. Probeer dit onder de 50 karakters te houden, zo past het altijd op twee lijnen.
* `subtitle`: Een korte beschrijving van de gebeurtenis. Wordt gebruikt in meldingen en bij een programma detail.
* `start`: Wanneer deze gebeurtenis begint. Het formaat van dit veld wordt [hieronder](#tijd-formaat) beschreven.
* `end`: Wanneer deze gebeurtenis eindigt. Het formaat van dit veld wordt [hieronder](#tijd-formaat) beschreven. Als dit veld niet wordt meegegeven dan blijft de gebeurtenis eeuwig duren, kan bijvoorbeeld gebruikt worden voor de laatste gebrurtenis "Einde HO".
* `location`: De plaats op de kaart van deze gebeurtenis. Komt overeen met de eigenschap `name` op de [kaart](#kaart).
* `group`: De tekst van de groep waar deze gebeurtenis toe behoord. Kan bijvoorbeeld gebruikt worden om enkele gebeurtenisen te groeperen onder "hoofdpodium".
* `notify`: Als dit `true` is krijgt de gebruiker hiervoor een melding op met moment dat deze gebeurtenis begint (volgens `start`).

Een voorbeeld van een gebeurtenis:
```json
{
    "title": "Marktje op de grote grond",
    "start": "ZA 15:00",
    "end": "ZA 18:00",
    "location": "GG",
    "notify": true
}
```

Het programma in de app:

![](https://user-images.githubusercontent.com/68152530/236479638-8f18bb03-2a3b-48ae-b763-a869279c1f64.png)

## 3. Kaart
Plaatsen op de kaart zijn gedefinieerd in [`assets/content/kaart.json`](/assets/content/kaart.json). Dit JSON bestand heeft het [GeoJSON](https://en.wikipedia.org/wiki/GeoJSON) formaat. De coördinaten kunnen het best bewerkt worden met een [GeoJSON editor](https://geoman.io/geojson-editor).

Naast coördinaten heeft elke plaats ook een aantal eigenschappen in het veld `properties`.
* `name`: De identificatie van deze plaats. Zou normaal gezien uniek moeten zijn. Wordt nooit aan de gebruiker getoond, maar wordt gebruikt in links. Bijvoorbeeld in een nieuws artikel kan de link `/kaart?id=GG` gebruikt worden, wat verwijst naar de "Grote Grond". Er wordt ook naar dit veld verwezen in het [programma](#programma).
* `displayName`: De naam die de gebruiker ziet na het selecteren van deze plaats.
* `style`: Dit wordt enkel gebruikt voor polygons om de kleur te bepalen. Als dit `kampeergrond` is zal een een tent icoontje worden toegevoegd in het midden van die plaats.

Enkele plaatsen aangeduid op de kaart:

![](https://user-images.githubusercontent.com/68152530/236480072-aa584ed8-5c04-4c51-b908-ebf22dd133cb.png)

De kleuren van regio's zijn gedefinieerd in [`lib/pages/kaart.dart`](/lib/pages/kaart.dart), afhankelijk van `style`:

![](https://user-images.githubusercontent.com/68152530/236480950-50e5e02f-a2e1-4a9b-a0aa-6b728ed95b8e.png)

---

## Tijd formaat
In zowel nieuwsberichten als het programma wordt gebruikgemaakt van een simpel formaat om tijd voor te stellen. Bijvoorbeeld `"VR 21:00"` betekent vrijdag (de eerste dag van HO) om 21u. De mogelijke dagen zijn `VR`, `ZA`, en `ZO`.

De eerste dag van HO is gedefineerd in [`lib/model/time_manager.dart`](/lib/model/time_manager.dart) (zoek naar `defaultStart`). Deze datum moet dus elk jaar aangepast worden voor de app release.

## Themakleuren
Om de themakleuren aan te passen is een app release nodig. De kleuren zijn gedefinieerd in [`lib/main.dart`](/lib/main.dart), (zoek naar `ThemeData`).

## Developer instellingen
Om de features rond nieuws, programma en meldingen gemakkelijk te kunnen testen bestaat er een "geheime" pagina. Hier kan je naartoe gaan door 4 keer te klikken op de titel "HO-Gids" op het nieuws startscherm.

* **Klok overschrijven**: dit levert ongeveer hetzelfde resultaat op alsof je de klok van je toestel zou wijzigen in de instellingen. Dit heeft geen effect op meldingen!
* **Start HO (vrijdag)**: op welke dag dat HO begint. Alle nieuws en programma tijden zijn gebaseerd op deze dag.
* **Meldingen opnieuw inplannen**: dit gebeurt automatisch bij het opstarten van de app, maar hiermee kan je ook manueel de meldingen terug schedulen. Vooral nuttig net na het aanpassen van "Start HO".

![developer scherm](https://user-images.githubusercontent.com/68152530/238377676-cd411172-cdf0-41a8-88db-7e0de3a588c4.png)
