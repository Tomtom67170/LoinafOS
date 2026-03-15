from botan3 import scrypt
import requests
import json, os
from ntpath import expanduser
from posix import stat

icon_code = {
    "0": "",
    "1": "",
    "2": "",
    "3": "",
    "45": "",
    "48": "󰼯",
    "51": "",
    "53": "",
    "55": "",
    "56": "",
    "57": "",
    "61": "󰖗",
    "63": "",
    "65": "",
    "66": "",
    "67": "",
    "71": "",
    "73": "",
    "75": "",
    "77": "",
    "80": "󰸊",
    "81": "󰸊",
    "82": "󰸊",
    "85": "󱪀",
    "86": "󱪀",
    "95": "",
    "96": "",
    "97": ""
}

try:
    path = os.path.expanduser('~/.config/waybar/scripts/current.json')
    with open(path, 'r') as fichier:
        location = json.load(fichier)
    if location['city'] == 'location':
        loc_res = requests.get("https://api.my-ip.io/v2/ip.json", timeout=30).json()
        lat = loc_res['location']['lat']
        lon = loc_res['location']['lon']
        try:
            city = loc_res['city']
        except:
            city = str(lat)+" "+str(lon)
        dept = 9999
    else:
        city = location['city']
        lat = location['lat']
        lon = location['lon']
        dept = location['dept']

    url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&models=meteofrance_seamless&current=weather_code,temperature_2m&timezone=Europe%2FBerlin&forecast_days=1"
    request = requests.get(url, timeout=5)
    if request.status_code != 200:
        output = {
            "text": f"{icon_code["1"]} --°C",
            "tooltip": f"Erreur HTML {request.status_code}"
        }
        print(json.dumps(output))
        quit()

    resp = request.json()
    code = resp['current']['weather_code']
    temp = resp['current']['temperature_2m']

    icon = icon_code[str(code)]
    token_path = os.path.expanduser("~/.config/waybar/scripts/token")

    if dept == 9999 or not(os.path.isfile(token_path)):
        output = {
            "text": f"{icon} {temp}°C",
            "tooltip": f"Météo de {city}"
        }
    else:
        with open(token_path, 'r') as fichier:
            token = fichier.read()
            if token[-1] == '\n': token = token[:-1]
        headers = {
            'accept': '*/*',
            'apikey': token
        }
        try:
            response = requests.get("https://public-api.meteofrance.fr/public/DPVigilance/v1/cartevigilance/encours", headers=headers).json()
            status = ["green", "yellow", "orange", "red"]
            final_class = ""
            for element in response['product']['periods'][0]['timelaps']['domain_ids']:
                if element["domain_id"] == str(dept): 
                    final_class = status[element["max_color_id"] - 1]
            output = {
                "text": f"{icon} {temp}°C",
                "tooltip": f"Météo de {city}",
                "class": final_class
            }


        except Exception as E:
            crash_path = os.path.expanduser("~/.config/waybar/scripts/vigi_error.txt")
            with open(crash_path, 'w') as fichier:
                fichier.write(str(E))
            #print(f"Erreur {E}")
            output = {
                "text": f"{icon} {temp}°C",
                "tooltip": f"Météo de {city}\nErreur interne lors de la récupération de la vigilance!"
            }


    print(json.dumps(output))

except Exception as e:
    print(json.dumps({"text": f"{icon_code["1"]} --°C", "tooltip": f"Erreur {e}"}))
