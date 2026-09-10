# taf

Simulateur de collection de créatures sur Roblox. Le code (scripts Lua/Luau)
vit dans ce repo et est synchronisé vers Roblox Studio avec **Rojo**. La
construction visuelle de la map (terrain, modèles Sloyd, décor) se fait
directement dans Studio via Team Create, comme d'habitude.

## Structure

```
default.project.json                          # config Rojo
src/
  ReplicatedStorage/Modules/PetData.lua        # catalogue des espèces (rareté, valeur)
  ServerScriptService/Server/
    Main.server.lua                            # point d'entrée serveur
    PlayerDataManager.lua                      # sauvegarde (DataStore) + leaderstats
    EggService.lua                             # oeuf placeholder + logique de hatch
  StarterPlayer/StarterPlayerScripts/Client/
    UI.client.lua                              # HUD (coins + notif de hatch)
```

## Setup (une fois)

1. Installer [Rojo](https://rojo.space/) (déjà fait sur cette machine).
2. Dans Roblox Studio : menu **Plugins** → installer le plugin **Rojo** depuis
   le Marketplace (recherche "Rojo").

## Workflow au quotidien

1. Dans ce dossier, lancer le serveur Rojo :
   ```bash
   rojo serve
   ```
2. Dans Roblox Studio, ouvrir le plugin Rojo (icône dans l'onglet Plugins) et
   cliquer **Connect**. Les scripts de `src/` apparaissent dans l'explorer.
3. Éditer les `.lua` ici (VS Code, Claude Code...) — Studio se met à jour en
   direct.
4. Tester en jeu dans Studio (bouton Play).
5. Commit + push sur GitHub pour partager avec ton ami :
   ```bash
   git add -A
   git commit -m "..."
   git push
   ```

## Pipeline modèles Sloyd

Les modèles générés par Sloyd s'importent directement dans Studio (plugin
Sloyd), puis se placent dans Workspace ou ReplicatedStorage à la main. Ils ne
sont pas versionnés dans ce repo (ce sont des fichiers binaires Roblox) — ils
vivent dans la session Team Create / le fichier de place. Le repo Git suit
uniquement le code.

## État actuel

MVP fonctionnel : un oeuf placeholder (sphère jaune) apparaît au centre de la
map, `ProximityPrompt` pour le "hatch", tire un pet aléatoire pondéré par
rareté (`PetData.lua`), l'ajoute aux données du joueur, ajoute des coins et
affiche une notif côté client. Remplacer le placeholder par un modèle Sloyd
en gardant le nom `Egg` et le `ProximityPrompt` pour ne pas casser le script.
