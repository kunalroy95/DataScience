import requests

url = 'http://localhost:5000/results1'
r = requests.post(url,json={'accommodates':2, 'bed_type':1})

print(r.json())
