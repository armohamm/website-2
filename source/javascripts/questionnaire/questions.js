(function() {
  var questionData = [
    {
      "title": "Online leren",
      "questions": [
        "vindt een substantieel deel van de trainingen / scholingen​ online​ plaats.",
        "maken we gebruik van allerlei online content, zoals e-learning modules, video’s, artikelen en links.",
        "wordt door onszelf e-learning materiaal ontwikkeld.",
        "is er een toenemende behoefte aan leerplek-onafhankelijk leren (mobiele apparaten).",
        "vindt toetsing digitaal plaats."
      ]
    },
    {
      "title": "Events",
      "questions": [
        "vindt een substantieel deel van de trainingen / scholingen via bijeenkomsten ​niet (online)​ plaats.",
        "is de cursusadministratie een belangrijk proces.",
        "worden klassikale trainingen en scholingen intern georganiseerd.",
        "worden cursussen en trainingen aan externen aangeboden.",
        "is de financiële afhandeling van klassikale trainingen en scholingen belangrijk."
      ]
    },
    {
      "title": "Compliance",
      "questions": [
        "moeten we kunnen aantonen dat medewerkers gecertificeerd of bekwaam zijn.",
        "worden bepaalde opleidingen door een externe partij geaccrediteerd.",
        "is het herhaald aantonen van vakbekwaamheid op specifieke handelingen noodzakelijk.",
        "is een deel van de trainingen en opleidingen die wij aanbieden verplicht.",
        "is het van belang dat gegevens over bevoegdheden (certificering) beschikbaar zijn in andere systemen zoals Roostering, EPD, etc."
      ]
    },
    {
      "title": "Kennis delen",
      "questions": [
        "is sociaal leren belangrijk.",
        "maken experts uit onze eigen organisatie zelf leercontent.",
        "is het delen van kennis belangrijk.",
        "speelt informeel leren een steeds belangrijkere rol.",
        "werken we met een aanpak zoals 70:20:10​ en ontwerpen we leertrajecten vanuit de 5 moments of need."
      ]
    },
    {
      "title": "Performance Support",
      "questions": [
        "is ​performance support​ een belangrijk thema.",
        "vindt leren vooral plaats op de werkplek en ondersteunen wij dit met digitale middelen.",
        "wordt er precies genoeg informatie aangeboden in de vorm die nodig is om effectief te kunnen opereren in het proces.",
        "willen we binnen het LMS zowel formele scholing kunnen aanbieden als ondersteunende instructies die een medewerker te allen tijde kan raadplegen (werkinstructies, protocollen, instructievideo’s, etc.).",
        "is het belangrijk dat leercontent overal snel en makkelijk doorzoek- en vindbaar is (2 clicks en 10 seconden)."
      ]
    },
    {
      "title": "​Curation",
      "questions": [
        "is het belangrijk dat iedereen een op maat gemaakt leeraanbod krijgt.",
        "bieden we uitgebreide leerpaden aan.",
        "is het evalueren en reviewen van trainingen en e-learning een must.",
        "meten we of onze trainingen het beoogde effect hebben.",
        "hebben medewerkers een persoonlijk ontwikkelplan."
      ]
    },
    {
      "title": "Personeelontwikkeling",
      "questions": [
        "worden coaching- of jaargesprekken ingezet.",
        "kunnen medewerkers voor duurdere trainingen een educatie aanvraag doen.",
        "is het belangrijk dat medewerkers duurzaam inzetbaar zijn.",
        "houden we rekening met mobiliteit en interne vacatures.",
        "hebben individuen en afdelingen een eigen leerbudget."
      ]
    }
  ];

  // Initialize questions
  var questions = new questionnaire.Questions("#questions-form", questionData);

  // Results form
  var $resultsForm = $("#results-form");
  var $resultsInput = $("#results-input");

  $resultsForm.on("submit", function(e) {
    // Calculate average group results
    var resultData = questions.serializeJSON();
    resultData = questions.getAverageGroupResults(resultData.groups);
    resultData = JSON.stringify(resultData);

    // Populate hidden results input before submitting
    $resultsInput.val(resultData);
  });
})();
