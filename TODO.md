# TODO - What I've Done (Emotional Compass)

## ✅ Completati (Pivot Architetturale)
- [x] **Backend Re-architecting**: Rinominate entità Category -> Dimension e ActivityLog -> Action.
- [x] **Database Pivot**: Passaggio a Slug IDs per le Dimensioni e seeding dei 4 pilastri (Energia, Chiarezza, Relazioni, Anima).
- [x] **Fulfillment System**: Aggiunto `fulfillment_score` (1-5) alle Azioni per misurare il "nutrimento" emotivo.
- [x] **Onboarding "The Manifesto"**: Implementata sequenza cinematografica con testi definitivi, animazioni e feedback aptico.
- [x] **Frontend Alignment**: Refactoring completo dei repository, modelli Freezed e provider per riflettere il nuovo dominio.
- [x] **Bug Fix Critici**: Risolta persistenza dati (commijt mancante nel backend) e bug di routing (accessibilità manuale onboarding).

## 🚀 Prossimi Passi (Alta Priorità)
- [ ] **Dimension Balance Widget**: Creare un widget (radar chart o barre cumulative) nella Dashboard che mostri il bilancio delle 4 dimensioni per la giornata corrente.
- [ ] **Action History Filtering**: Aggiungere filtri nella Dashboard per visualizzare le azioni per singola dimensione.
- [ ] **Energy Bar Logic**: Definire come il `fulfillment_score` e la durata delle azioni influenzano il riempimento delle barre di energia giornaliere.
- [ ] **Daily Log Integration**: Collegare i Daily Log (sonno, umore) al sistema delle dimensioni per vedere correlazioni (es. "Se dormo poco, la mia Chiarezza cala").

## 🛠️ Manutenzione e Qualità
- [ ] **Refactoring `onboarding_screen.dart`**: Pulire il codice rimuovendo i residui di debug print e semplificando i widget di layout.
- [ ] **Backend Test Update**: Aggiornare la suite di test per coprire i nuovi endpoint `/dimensions` e `/actions`.
- [ ] **Localization (i18n)**: Passare da `AppStrings` a file `.arb` reali per il supporto multi-lingua.
- [ ] **Unit Tests Frontend**: Aumentare la copertura dei test sui nuovi Action/Dimension Notifiers.
