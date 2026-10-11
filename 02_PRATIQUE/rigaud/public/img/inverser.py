import os
import re

# Définir le dossier actuel
dossier = os.path.dirname(os.path.abspath(__file__))
total_fichiers = 177

# Étape 1 : Renommer temporairement pour éviter d'écraser les fichiers existants
# Exemple : A1.jpg -> TEMP_177.jpg
fichiers_a_traiter = []
for nom_fichier in os.listdir(dossier):
    match = re.match(r"^A(\d+)(\..+)$", nom_fichier)
    if match:
        num = int(match.group(1))
        ext = match.group(2)
        if 1 <= num <= total_fichiers:
            nouveau_num = total_fichiers - num + 1
            ancien_chemin = os.path.join(dossier, nom_fichier)
            chemin_temp = os.path.join(dossier, f"TEMP_{nouveau_num}{ext}")
            
            os.rename(ancien_chemin, chemin_temp)
            fichiers_a_traiter.append((chemin_temp, nouveau_num, ext))

# Étape 2 : Appliquer le nom final sans le préfixe TEMP
# Exemple : TEMP_177.jpg -> A177.jpg
for chemin_temp, num_final, ext in fichiers_a_traiter:
    chemin_final = os.path.join(dossier, f"A{num_final}{ext}")
    os.rename(chemin_temp, chemin_final)

print("Inversion de la numérotation terminée avec succès !")
