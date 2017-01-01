# Medical files migration

Medical files were digitized by data entry using Google Forms.

## Command

```sh
$ ./normalize_medical_files.js input.csv
```

## Fields

By exporting the Google Forms results to a CSV file using Google Sheets, we get a CSV file with the following fields:

| Index | Field name | Orginal field name | Example (if not free text input) |
|-------|------------|--------------------| ---------------------------------|
| 0     | Timestamp | Timestamp | `19/07/2016 20:06:02` |
| 1     | Last name | Familienaam | |
| 2     | First name | Voornaam | |
| 3     | Street and number | Straat en nummer | |
| 4     | City and zip code | Gemeente en postcode | |
| 5     | Telephone (home) | Telefoon (thuis) | |
| 6     | Birth date | Geboortedatum | |
| 7     | Blood type (if known) | Bloedgroep (indien geweten) | `A+`, `O+` |
| 8     | Gender | Geslacht | `Man`, `Vrouw` |
| 9     | Contact person 1 - Name | Naam 1 | |
| 10    | Contact person 1 - Telephone number | Telefoonnummer of GSM 1 | |
| 11    | Contact person 1 - Relationship with child | Band/relatie met kind 1 | `Papa`, `Stiefmama`, ... |
| 12    | Contact person 2 - Name | Naam 2 | |
| 13    | Contact person 2 - Telephone number | Telefoonnummer of GSM 2 | |
| 14    | Contact person 2 - Relationship with child | Band/relatie met kind 2 | `Papa`, `Stiefmama` |
| 15    | Contact person 3 - Name | Naam 3 | |
| 16    | Contact person 3 - Telephone number | Telefoon of GSM 3 | |
| 17    | Contact person 3 - Relationship with child | Band/relatie met kind 3 | `Papa`, `Stiefmama` |
| 18    | Family doctor | Huisarts | |
| 19    | Allergies | Allergieën | |
| 20    | Allergies - extra information | Bijkomende informatie allergieën | |
| 21    | Basic information diseases | Basisgegevens aandoeningen | |
| 22    | Extra information diseases | Bijkomende informatie aandoeningen | |
| 23    | Surgeries or diseases we should be aware of | Heeft uw kind bepaalde ziektes gehad of heelkundige ingrepen waarvan de leiding op de hoogte moet zijn? | |

