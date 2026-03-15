VERSION = 1.0

import json, os, requests, webbrowser

def clear():
    os.system('clear')


current_path = os.path.expanduser('~/.config/waybar/scripts/current.json')
saved_path = os.path.expanduser('~/.config/waybar/scripts/saved.json')
token_path = os.path.expanduser('~/.config/waybar/scripts/token')

try:
    with open(current_path, 'r') as fichier:
        current = json.load(fichier)

    with open(saved_path, 'r') as fichier:
        saved = json.load(fichier)

except Exception as e:
    clear()
    print("=== RECOVERY MODE ===")
    print(f"Une erreur est survenue lors de l'ouverture des fichiers pour stocker vos communes!\nErreur: {e}")
    choice = input("Souhaitez vous réinitialiser les fichiers ? (Y/n)")
    if (choice == "Y" or choice == "y"):
        with open(current_path, 'w') as fichier:
            current = {"city":"location", "lat": "0.0", "lon":"0.0", "dept":9999}
            json.dump(current, fichier, indent=4)

        with open(saved_path, 'w') as fichier:
            saved = []
            json.dump(saved, fichier, indent=4)
    else:
        current = {"city":"location", "lat": "0.0", "lon":"0.0", "dept":9999}

try:
    with open(token_path, 'r') as fichier:
        token = fichier.read()
        if token[-1] == '\n': token = token[:-1]
except FileNotFoundError:
    input("AVERTISSEMENT: Aucun token pour l'API Météo France n'a été renseigné!\nVous pourez le faire dans ce panel en choisissant \"Gérer mon token Météo France\" dans ce panel!\n\nLe token Météo France permet de compléter les fonctionnalité du module météo de la waybar\nAppuyer sur entrée pour continuer...")
except Exception as e:
    input(f"Une erreur est survenue lors de la récupération du token Météo France (erreur {e})\nVous pourrez tenter de corriger ça en choisissant \"Gérer mon token Météo France\" sur le panel\nAppuyez sur entrée pour continuer...")


clear()
print("===                         ===")
print("--- Panel météo de LoinafOS ---")
print("===                         ===")
print(f"Version {VERSION}")
print("\n\n\n")
print("Commune actuelle: "+str(current['city']))
print("\n\nQue souhaitez vous faire?")
print("1. Changer de commune")
print("2. Ajouter une commune")
print("3. Supprimer une commune")
print("4. Gérer mon token Météo France")
print("5. (DEBUG) Editer un .JSON")
print("6. Terminer ce panel\n\n")
menu = input("Menu: ")

while (menu == "1" or menu == "2" or menu == "3" or menu == "4" or menu == "5"):

    if (menu == "1"):
        clear()
        print("Communes actuellement enregistrées:")
        for i in range(len(saved)):
            print(str(i)+": "+saved[i]['city'])
        print(str(len(saved))+": Localisation associée à votre adresse IP")

        try:
            choice = int(input("Numéro de commune à sélectionner: "))

            if choice < len(saved):
                current['city'] = saved[choice]['city']
                current['lat'] = saved[choice]['lat']
                current['lon'] = saved[choice]['lon']
                current['dept'] = saved[choice]['dept']
                with open(current_path, 'w') as fichier:
                    json.dump(current, fichier, indent=4)
            elif choice == len(saved):
                current['city'] = 'location'
                current['lat'] = "0.0"
                current['lon'] = "0.0"
                current['dept'] = 67
                with open(current_path, 'w') as fichier:
                    json.dump(current, fichier, indent=4)

        except ValueError:
            input("Paramètre invalide, veuillez réessayer...")

    elif menu == "2":
        clear()
        print("Ajouter une commune")
        inter = input("Voulez vous ajouter une commune française ? (Y/n)")
        if inter == 'y' or inter == 'Y':
            name = input("Saisir le nom de la commune (limité à la France): ")
            print("Veuillez patienter...")
            try:
                citys = requests.get(f"https://api-adresse.data.gouv.fr/search/?q={name}&type=municipality").json()
                if (len(citys['features']) == 0):
                    print("Aucune commune française trouvée! Vérifier l'orthographe!")
                    input("Appuyez sur entrée pour continuer...")
                else:
                    for i in range(len(citys['features'])):
                        city = citys['features'][i]
                        print(str(i)+": "+str(city['properties']['postcode'])+" "+str(city['properties']['name']))
                    print("\n\nVeuillez choisir une commune (Source: api-adresse.data.gouv.fr)")
                    city_choice = int(input("Numéro de ville: "))
                    if (city_choice < len(citys['features'])):
                        city = citys['features'][city_choice]
                        new = {
                            "city": city['properties']['name'],
                            "lat": str(city['geometry']['coordinates'][1]),
                            "lon": str(city['geometry']['coordinates'][0]),
                            "dept": int(city['properties']['postcode'][:2]),
                        }
                        saved.append(new)
                        with open(saved_path, 'w') as fichier:
                            json.dump(saved, fichier, indent = 4)
            except Exception as e:
                input(f"Une erreur est survenue: {e}! Veuillez réessayer plus tard\nAppuyer sur entrée pour continuer")
        else:
            name = input("Saisir le nom de la commune: ")
            name = name.replace(" ", "%20")
            print("Veuillez patienter...")
            headers = {
                'User-Agent': f'LoinafWeather/{VERSION} (contact: tomservice.contact@gmail.com)'
            }
            url = f"https://nominatim.openstreetmap.org/search?q={name}&format=json"
            #print(url)
            citys = requests.get(url, headers=headers).json()
            #input(citys.content)
            try:
                
                if (len(citys) == 0):
                    print("Aucune commune ne correspond à votre recherche! Vérfier l'orthographe!")
                    input("Appuyer sur entrée pour continuer")
                else:
                    for i in range(len(citys)):
                        print(str(i)+": "+citys[i]["display_name"])
                    print("\n\nVeuillez choisir une commune (Source: Nominatim OpenStreetMap)")
                    city_choice = int(input("Numéro de ville: "))
                    if (city_choice < len(citys)):
                        city = citys[i]
                        new = {
                            "city": city['name'],
                            "lat": str(city['lat']),
                            "lon": str(city['lon']),
                            "dept": 9999,
                        }
                        saved.append(new)
                        with open(saved_path, 'w') as fichier:
                            json.dump(saved, fichier, indent=4)
            except Exception as e:
                input(f"Une erreur est survenue: {e}! Veuillez réessayer plus tard\nAppuyer sur entrée pour continuer")
    elif menu == "3":
        clear()
        print("Communes actuellement enregistrées:")
        for i in range(len(saved)):
            print(str(i)+": "+saved[i]['city'])

        try:
            choice = int(input("Numéro de commune à sélectionner: "))

            if i < len(saved):
                del saved[i]
                with open(current_path, 'w') as fichier:
                    json.dump(current, fichier, indent=4)
        except ValueError:
            input("Paramètre invalide, veuillez réessayer...")
    elif menu == "4":
        clear()
        print("Modifier le token de votre API Météo France")
        choice = input("Voulez vous accéder à la page du portail API de Météo France lié aux vigilance pour générer un token?(Vous serez invitez à créer un compte si vous n'en avez pas) (Y/n)")
        if choice == "Y" or choice == "y":
            webbrowser.open("https://portail-api.meteofrance.fr/web/fr/api/DonneesPubliquesVigilance")
        input("Sur le site du portail de Météo France lié aux vigilances, appuyez sur \"Souscrire à l'API gratuitement\", puis \"Utiliser\" et générez une \"API key\" (vous devrez entrer une période de validitée en secondes), puis une fois la clé générée, appuyez sur entrée...")
        print("Une fenêtre neovim va s'ouvrir, veuillez coller votre clé dedans, puis sauvegarder et fermer neovim")
        os.system("kitty nvim ~/.config/waybar/scripts/token")
    elif menu == "5":
        clear()
        print("AVERTISSEMENT: Vous êtes sur le point d'accéder au fichier JSON qui stocke vos villes! Les endommager peut rendre votre module météo et ce panel INUTILISABLE!\nNe modifiez ces fichiers uniquement si vous savez ce que vous faîtes!")
        choice = input("Poursuivre (Y/n)")
        if choice == "Y" or choice == "y":
            print("Quel fichier souhaitez vous modifier ?")
            print("1: current.json")
            print("2: saved.json")
            choice = input("Numéro de fichier à ouvrir: ")
            if choice == "1":  os.system("kitty nvim ~/.config/waybar/scripts/current.json")
            elif choice == "2": os.system("kitty nvim ~/.config/waybar/scripts/saved.json")

    clear()
    print("===                         ===")
    print("--- Panel météo de LoinafOS ---")
    print("===                         ===")
    print(f"Version {VERSION}")
    print("\n\n\n")
    print("Commune actuelle: "+str(current['city']))
    print("\n\nQue souhaitez vous faire?")
    print("1. Changer de commune")
    print("2. Ajouter une commune")
    print("3. Supprimer une commune")
    print("4. Gérer mon token Météo France")
    print("5. (DEBUG) Editer un .JSON")
    print("6. Terminer ce panel\n\n")
    menu = input("Menu: ")

