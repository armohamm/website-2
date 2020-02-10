---
title: "Van SCORM naar LTI in CAPP LMS: een terugblik"
date: 2019-12-11 08:00
tags: CAPP LMS, SCORM, LTI, e-learning
author: Gerwin
lang: nl
featured: false
image: images/blog/social/development-1200x630.jpg
featured_image: images/blog/featured/20191211-development.jpg
header_image: moods/code.jpg
call_to_action: download-lti-whitepaper
---

__Bij de ontwikkeling van het nieuwe CAPP LMS hebben we besloten te stoppen met de ondersteuning van SCORM voor e-learningmateriaal. Inmiddels zijn we zo'n twee jaar verder en kijken we terug op dit besluit met Gerwin Veenstra, een van onze productmanagers.__

Twee jaar geleden maakten we de keuze om in de nieuwe versie van ons LMS geen SCORM meer te ondersteunen. We zijn vol voor LTI gegaan en dat was best een spannende keuze, die uiteindelijk goed heeft uitgepakt. Inmiddels durven we ons expert te noemen op het gebied van LTI. We ondersteunen bij het omzetten van SCORM-content, proberen andere bedrijven te helpen bij de implementatie van LTI en te bewaken dat 'wij', de markt, ons aan de standaard houden zodat al onze klanten met een gerust hart LTI kunnen gebruiken.

## De keuze voor LTI
De hoofdreden om voor LTI te kiezen is de combinatie van betere gegevensbeveiliging en controleerbaarheid onafhankelijk van welke browser en besturingssysteem een gebruiker gebruikt.

Bij zowel LTI als SCORM worden resultaten verstuurd vanuit een externe 'module' naar het [LMS](/wat-is-een-lms/){:title="Wat is een LMS?"} van waaruit de module wordt afgespeeld. De communicatie over het internet is van veel factoren afhankelijk; er kan op veel plekken iets mis gaan waardoor een resultaat op een module niet altijd direct goed verwerkt wordt in het LMS.

### Overdracht van resultaten waarborgen
Bij SCORM waren missende resultaten moeilijk, of met zeer arbeidsintensieve inspanningen, terug te halen. LTI biedt de mogelijkheid om resultaten nogmaals, en zo vaak als nodig voor juiste verwerking, op te sturen naar een LMS. Hiermee wordt de overdracht van resultaten naar het LMS gewaarborgd en weten we zeker dat de gebruiker die een module volgde het juiste resultaat ontvangt. Dit vergt wel een juiste LTI-implementatie en daar helpen we andere organisaties graag bij.

### Kostenbesparend
Eenmaal geïmplementeerd heeft een provider bijna geen extra _handling_ meer als het gaat om versturen van gemiste resultaten en de borging van dit proces. In dat opzicht zou het zelfs kostenbesparend moeten zijn ten opzichte van het gebruik van bijvoorbeeld _remote SCORM_.

## LTI-expert
Inmiddels durven we ons bij Defacto LTI-expert te noemen. We hebben zowel de ontvangende (consumer) als versturende (provider) kant van LTI geïmplementeerd en meerdere Nederlandse en Duitse bedrijven geholpen bij de implementatie van de versturende kant. We hebben een eigen LTI-implementatie gemaakt en deze [open source](https://github.com/DefactoSoftware/lti) aangeboden. Deze wordt door bedrijven al gebruikt om LTI-provider te worden.

We zoeken pro-actief contact met LTI-providers om te zorgen dat we ons allemaal aan de standaard houden en dat we communicatie tussen LMS en LTI-provider kunnen waarborgen.

## Geen SCORM-ondersteuning meer
SCORM is een standaard waarvan de laatste versie uit 2004 komt en sinds 2006 niet meer is bijgewerkt. Door het ontbreken van updates en onderhoud zijn er aanzienlijke beveiligingsissues ontstaan. We hebben deze, en meer punten, uiteen gezet in ons whitepaper over SCORM, LTI en xAPI dat [onderaan dit blog](#download-whitepaper) te downloaden is.

Naast bovengenoemde punten waren voor ons belangrijke overwegingen:
-   Er is een wildgroei ontstaan doordat SCORM-leveranciers de standaard(en) verschillend interpreteren en naar eigen inzicht mogelijkheden oprekken. Hierdoor is het niet langer een eenduidige standaard.
-   Bij SCORM zijn het LMS en de leverancier afhankelijk van de browser van de gebruiker waar de module in het LMS wordt weergegeven en is het ingewikkeld eventueel niet verstuurde resultaten te herstellen.

## Maar ik heb nog SCORM-modules!
Deze kreet hebben we uiteraard vaak gehoord en horen we zo nu en dan nog wel eens. Gelukkig hoeft dat geen enkel probleem te zijn. Wanneer wordt SCORM nu gebruikt?
-   In modules die een resultaat teruggeven dat ook in het LMS zichtbaar moet zijn.
-   In informatieve modules waarbij resultaat niet belangrijk is.

### 1. Aanbieden via LTI of losse leerelementen van maken
In het eerste geval kijken we of het een mogelijkheid is de module aan te bieden via LTI. Is dit niet het geval dan kan het toetsgedeelte worden opgenomen in onze app [CAPP Quizzes](/capp-quizzes). Quizzes is een Quiz builder waarmee 'toetsen' kunnen worden afgenomen en deze toetsen zijn eenvoudig in ons LMS (of elk ander willekeurig LMS) op te nemen. De module kan dan alsnog als webmodule via CAPP LMS worden afgespeeld. Overwogen kan worden de inhoud van de module over te nemen binnen ons LMS als video of artikel met leerelementen als hotspots e.d.

### 2. Webmodule maken
Bij de tweede vorm van modules kan er simpelweg een 'webmodule' van de SCORM-modules gemaakt worden. Dit kan vanuit praktisch elk authoring programma gedaan worden en de gebruiker kan alles doen wat hij ook in een SCORM-module kan doen.

## LTI in de toekomst
Er wordt nog steeds verder ontwikkeld aan de LTI-standaard en deze volgen we uiteraard op de voet. We zijn daarbij ook in gesprek met partijen in de markt die content aanbieden om elkaar scherp te houden op het vasthouden aan de standaard en het borgen van de uitwisseling van resultaten. We zijn erg blij met de keuze voor een standaard die nog steeds doorontwikkeld wordt, browser onafhankelijk is en aansluit op de hedendaagse technologieën.

### We helpen graag
In toekomstige blogs gaan we nog wat dieper in op de vele aspecten van LTI, dus abonneer op onze nieuwsbrief of houd het blog in de gaten. Heeft u vragen over LTI of het omzetten van SCORM-content, dan helpen we graag!
