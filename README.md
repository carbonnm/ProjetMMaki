# 🖊️ MMaki – Outil de Sketchnote interactif sous Godot

> Application développée dans le cadre du cours *Méthodologie du génie logiciel* (MDL) – Université de Namur, 2023.

## 🎯 Objectif

Créer une application de **sketchnote interactive** adaptée à l'enseignement, utilisable sur tablette ou PC (Windows, Linux, navigateur). L’outil permet à un enseignant de dessiner, écrire, et illustrer ses cours en temps réel, comme sur un tableau numérique, avec reconnaissance automatique de mots-clés transformables en images.

---

## 🛠️ Fonctionnalités principales

| Catégorie           | Fonctionnalité                                                                 |
|---------------------|--------------------------------------------------------------------------------|
| **Canvas interactif** | Dessin au stylet ou à la souris, écriture texte                              |
| **Reconnaissance**  | Mots-clés reconnus → propositions d’illustrations automatiques                 |
| **Images**          | Sélection d’image(s) parmi une base associée à un mot                          |
| **Structuration**   | Titres, sous-titres, hiérarchies visuelles personnalisables                    |
| **Navigation**      | Zoom / dézoom, déplacement dans le canvas, arrière-plan personnalisable        |
| **Édition**         | Copier / coller, rotation, déplacement des éléments (texte, image, dessin)     |
| **Menus contextuels**| Menus clic droit/gauche adaptés au stylet ou à la souris                      |
| **Thèmes**          | Sauvegarde et réutilisation de styles personnalisés                            |
| **Exportation**     | Sauvegarde au format **SVG** pour archivage ou réutilisation                  |

---

## 🧪 Technologies utilisées

- 🧠 **Godot Engine** – moteur principal (interface, moteur d’entrée, rendu)
- 🐍 **Godot Python plugin** – intégration d’un moteur Python dans Godot pour traitements OCR
- 🧾 **[Pytesseract](https://github.com/madmaze/pytesseract)** – moteur OCR (Tesseract) pour reconnaissance de mots dans les zones dessinées
- 📐 **SVG Parser maison** – export précis du canvas dans un format vectoriel structuré
- ⚙️ **Pattern State + Machine à états** – gestion explicite des entrées utilisateur concurrentes
- 🧪 **[GUT – Godot Unit Test](https://github.com/bitwes/Gut)** – tests unitaires, fuzzing, mutation-based testing

---
