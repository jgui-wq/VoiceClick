# VoiceClick

Dictez n'importe où d'un simple clic. VoiceClick transforme la saisie vocale intégrée de Windows (Win+H) en outil de dictée au clic — appuyez sur F1 pour l'activer, puis cliquez dans un champ texte pour dicter.

![Windows 10/11](https://img.shields.io/badge/Windows-10%20%7C%2011-blue) ![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-green) ![License MIT](https://img.shields.io/badge/License-MIT-yellow)

## Comment ça marche

1. **F1** active/désactive le mode dictée
2. **Cliquez** dans un champ texte — la saisie vocale démarre automatiquement
3. Parlez — vos mots apparaissent en texte
4. **Cliquez** dans un autre champ — la dictée suit votre curseur

VoiceClick ne s'active que dans les zones de saisie (champs texte, terminaux, barres de recherche), pas sur les boutons, menus ou la barre des tâches.

## Cibles supportées

| Cible | Détection |
|-------|-----------|
| Terminaux (Windows Terminal, cmd, PowerShell, Git Bash, PuTTY) | Classe de fenêtre |
| Champs texte classiques (Bloc-notes, boîtes de dialogue, barres de recherche) | Classe de contrôle (Edit, RichEdit, Scintilla) |
| Autres applications avec curseur texte | Position du caret |

## Installation

1. Installer [AutoHotkey v2](https://www.autohotkey.com/) (gratuit)
2. Télécharger `VoiceClick.ahk`
3. Double-cliquer pour lancer

Optionnel : placer un raccourci dans le dossier Démarrage (`Win+R` → `shell:startup`) pour le lancer automatiquement.

## Couper le son de la dictée

La saisie vocale Windows émet un bip au démarrage. Pour le couper :

1. Appuyez sur **Win+H** pour déclencher la dictée une fois
2. Clic droit sur l'**icône du son** dans la barre des tâches → **Mixeur de volume**
3. Coupez le son de **"Expérience de fonctionnalité Windows"**

Ce réglage persiste après redémarrage.

## Prérequis

- Windows 10 ou 11 avec la saisie vocale activée
- [AutoHotkey v2.0+](https://www.autohotkey.com/)

## Licence

MIT
