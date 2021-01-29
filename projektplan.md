# Projektplan

## 1. Projektbeskrivning (Beskriv vad sidan ska kunna göra).
    Jag skall göra en promodoro hemsida för datorn. hemsidan skall kunna vara en simpel nedräknare om man inte skapar ett konto. Om ett konto skapas skall applikationen spara hur lång tid du har fokuserat per dag. Användare skall också kunna göra tasks skall kunna läggas ned specifika fokus tider på. Dessa task fokustider skall då också ha seperata statistiker på hur mycket tid lades ned på en task. tasken skall också enkelt kunnas klassas som klara och tas bort, men inte statistiken för dem.
## 2. Vyer (visa bildskisser på dina sidor).
![design](design1.png)
![design2](design2.png)
## 3. Databas med ER-diagram (Bild på ER-diagram).
![erd schema](erd.png)
## 4. Arkitektur (Beskriv filer och mappar - vad gör/innehåller de?).
        layout.slim
        index.slim
            #nedräknings timer
            #länkar till alla andra sidor
        login.slim
            #sida för inlogg och
        information
            options.slim
                #kan ändra tidsinställningar för användaren
            task.slim
                #skapa tasks
                #radera tasks
                #ändra på tasks
                #beräknar hur mycket fokus tid som spenderas på specifika tasks
                #ger tasksen färger
            statistics.slim
                #visar hur mycket tid per dag som man använt fokus timern



