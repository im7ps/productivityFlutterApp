🚀 Quick Start (Come eseguire i test)
Hai due modalità per eseguire i test, a seconda del tuo contesto operativo.

# Esecuzione via Docker
Questa modalità utilizza il profilo test definito nel docker-compose.yml. Avvia un database Postgres ottimizzato (in RAM tramite tmpfs) e un container dedicato per i test.

# Esegui l'intera suite di test integrativi e unitari
docker compose --profile test up tests

oppure per test di carico

# Esegui il test di carico

docker compose --profile load up load-tests

Nota: Questo comando avvierà automaticamente anche il servizio backend e il database principale (db), poiché Locust deve testare l'applicazione reale in esecuzione.

Interfaccia Web: Una volta avviato, apri il browser all'indirizzo: 👉 http://localhost:8089

Dalla dashboard potrai:

Impostare il numero di utenti simulati (es. 100).

Impostare lo "Spawn rate" (utenti al secondo).

Avviare il test e visualizzare grafici in tempo reale su RPS (Richieste per Secondo), tempi di risposta e failure rate.

File di configurazione: Gli scenari di test sono definiti in backend/tests/locustfile.py. Modifica questo file per aggiungere nuovi endpoint o comportamenti utente da simulare.

# Per pulire le risorse di test dopo l'esecuzione
docker compose --profile test down

⚠️ Troubleshooting
Errore: ConnectionRefused in locale

Assicurati che Docker sia avviato. Testcontainers ne ha bisogno per alzare il DB effimero.

Errore: Dirty Database in Docker

Se interrompi bruscamente i test Docker, il volume tmpfs si pulisce al riavvio del container, ma per sicurezza puoi forzare una pulizia:
docker compose --profile test down -v