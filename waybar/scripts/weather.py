import requests
import json

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
    loc_res = requests.get("https://api.my-ip.io/v2/ip.json", timeout=30).json()
    lat = loc_res['location']['lat']
    lon = loc_res['location']['lon']
    try:
        city = loc_res['city']
    except:
        city = str(lat)+" "+str(lon)

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
    output = {
        "text": f"{icon} {temp}°C",
        "tooltip": f"Météo de {city}"
    }
    print(json.dumps(output))

except Exception as e:
    print(json.dumps({"text": f"{icon_code["1"]} --°C", "tooltip": f"Erreur {e}"}))
