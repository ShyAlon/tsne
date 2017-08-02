from os import path
from os import listdir
from os.path import isfile, join, isdir
import csv

mypath = path.dirname(path.abspath(__file__)) + '\\results' 
onlypaths = [f for f in listdir(mypath) if isdir(join(mypath, f))]
for dir in onlypaths:
    with open(mypath+'\\' + dir + '.csv', 'wb') as csvfile:
        spamwriter = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
        spamwriter.writerow(['Quality', '3NN', '6NN', 'Trustworthiness', 'Seed', 'Features'])
        # FinancialRatios_0.562_3n_1.116_6n_2.832_trustworthiness_73.741_number_2965362140024_features_23

        # CMC_Antineoplastic_q_0.863_q3_0.876_q5_0.874_trust_0.151_number_297938681513_features_16

        pdir = mypath + '\\' + dir
        onlyfiles = [f for f in listdir(pdir) if isfile(join(pdir, f)) and f.endswith('png')]
        features = []
        for image in onlyfiles:
            vector = []
            image = image.replace('.png', '') 
            pieces = image.split('_')[1::1]    
            values = [v for idx, v in enumerate(pieces) if idx > 1 and idx%2 == 0]
            spamwriter.writerow(values)
            # get the features
            seed = int(pieces[10])
            while seed > 0:
                vector.append (seed % 2)
                seed = seed / 2
            features.append(vector)
        length = 0
        featureLine = []
        for vec in features:
            length = max(length, len(vec))
        for i in range(0, length):
            total = 0
            for vec in features:
                if i < len(vec):
                    total = total + vec[i]
            featureLine.append(total)
        spamwriter.writerow(featureLine)

            




        