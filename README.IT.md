# WowClassicIta Addon

## Descrizione

WowClassicIta è un addon per World of Warcraft Classic progettato per migliorare la tua esperienza di gioco fornendo traduzioni italiane e contenuti localizzati. Questo addon mira a rendere il gioco più accessibile e divertente per i giocatori di lingua italiana.

## Caratteristiche

- [x] Traduzione in italiano per le descrizioni e gli obiettivi delle quest.
- [ ] Traduzione in italiano per i gossip.
- [ ] Traduzione in italiano per gli spells.
- [ ] Traduzione in italiano per gli oggetti.
- [ ] Traduzione in italiano per le skills.

## Installazione Manuale

1. Scarica l'addon dal repository o dal tuo gestore di addon preferito.
2. Estrai la cartella scaricata nella directory degli addon di WoW Classic:

    ```
    C:/Program Files (x86)/World of Warcraft/_classic_/Interface/AddOns/
    ```

3. Assicurati che la cartella sia nominata `WowClassicIta`.
4. Ricarica World of Warcraft Classic (`/reload`).

## Utilizzo

1. Avvia World of Warcraft Classic.
2. Vai al menu degli AddOns nella schermata di selezione del personaggio.
3. Abilita `WowClassicIta`.
4. Goditi il gioco con le traduzioni in italiano!

## Versione di Debug

Se desideri contribuire allo sviluppo di WowClassicIta e lavorare con la versione non pacchettizzata (caricando direttamente la versione di sviluppo in WoW), puoi posizionare direttamente questa cartella nel percorso degli AddOns.

- Innanzitutto, clona questo repository:

   ```shell
   git clone https://github.com/rez23/WowClassicIta
   ```

- Collega la cartella del tuo progetto addon alla cartella degli addon di WoW. Ad esempio, su sistemi Windows:

   ```powershell
   New-Item -ItemType Junction -Path "D:\Battlenet\games\World of Warcraft\_classic_era_\Interface\AddOns\WowClassicIta" -Value ".\WowClassicIta"
   ```

- Ora che tutto è impostato per caricare il tuo addon, devi acquisire le librerie necessarie tramite il packager:
  - Crea una cartella `.releases` per le versioni locali e copia lo script `release.sh`:

       ```powershell
       Set-Location -Path .\WowClassicIta
       New-Item -ItemType Directory -Path .\.releases
       Copy-Item -Path .\.packager\release.sh -Destination .\.releases\release.sh
       ```

  - Costruisci l'addon, per esempio, utilizzando WSL2:
     > **NB:** *Il packager richiede un sistema GNU/Linux per funzionare.*

     ```powershell
     bash.exe ./.releases/release.sh -d -z
     ```

     Questo comando costruirà l'addon saltando la creazione dello ZIP e l'upload.
  - Collega la cartella delle librerie generata dal packager alla cartella principale:

      ```powershell
      New-Item -ItemType Junction -Path .\Libs -Value ".\.releases\WowClassicIta\Libs"
      ```

- Ricarica World of Warcraft.

## Uso Avanzato

Digita `/wci` oppure `/ita` in chat per ottenere un elenco di opzioni o configura l'addon tramite il menu addon predefinito di Blizzard.

## Supporto

In caso di problemi o se hai suggerimenti, apri un issue nel repository o contatta il team di sviluppo.

## Licenza

Questo addon è distribuito sotto Licenza MIT. Vedi il file LICENSE per ulteriori dettagli.

Buone avventure ad Azeroth con WowClassicIta!

## Crediti e Ringraziamenti

Un enorme grazie a tutti coloro che hanno contribuito o contribuiranno allo sviluppo e al testing di WowClassicIta.

Un ringraziamento speciale a:

- [@Girolamone](https://github.com/Girolamone) per la traduzione in italiano delle quest e per il suo lavoro [qui](https://github.com/Girolamone/WoWita-quests).
- Icedany per la traduzione originale per PC che mi ha guidato nel mio lavoro.
- Gli sviluppatori e i manutentori delle librerie Ace3 utilizzate in questo progetto.
- @N6REJ e il suo [wowAddonTemplate](https://github.com/N6REJ/wowAddonTemplate) sul quale si basa questo progetto.
- I devs di [packeger](https://github.com/BigWigsMods/packager) per il loro fantastico generatore
