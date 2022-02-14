# Download HRTFS from https://sofacoustics.org/data/database/3d3a/
import requests
i = 0 # Index
# Default
hrir_def = '_HRIRs.sofa'
# Diffuse-field equalization
hrir_dfeq = '_HRIRs_dfeq.sofa'
# Low-frequency extension
hrir_lfc = '_HRIRs_lfc.sofa'

for x in range(42):
	i += 1
	name = 'Subject'
	name = name + str(i) + hrir_def # Change the hrir_def with what you want

	url = 'https://sofacoustics.org/data/database/3d3a/'+ name
	print('Downloading:   ' + url)

	r = requests.get(url, allow_redirects=True)
	open(name, 'wb').write(r.content)