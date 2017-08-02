from os import path
from os import listdir
from os.path import isfile, join, isdir
import csv

mypath = path.dirname(path.abspath(__file__)) + '\\results' 
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f)) and f.endswith('csv')]
with open(mypath+'\\summary.csv', 'wb') as csvfile:
    spamwriter = csv.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
    for f in onlyfiles: 
        with open(mypath+'\\'+f, 'rb') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
            spamwriter.writerow([f[:f.index('.')]])
            for row in spamreader:
                spamwriter.writerow([x.strip() for x in row[0].split(',')])

        # pdir = mypath + '\\' + dir
        # onlyfiles = [f for f in listdir(pdir) if isfile(join(pdir, f)) and f.endswith('png')]
        # features = []
        # for image in onlyfiles:
        #     vector = []
        #     image = image.replace('.png', '') 
        #     pieces = image.split('_')[1::1]    
        #     values = [v for idx, v in enumerate(pieces) if idx > 1 and idx%2 == 0]
        #     spamwriter.writerow(values)
        #     # get the features
        #     seed = int(pieces[10])
        #     while seed > 0:
        #         vector.append (seed % 2)
        #         seed = seed / 2
        #     features.append(vector)
        # length = 0
        # featureLine = []
        # for vec in features:
        #     length = max(length, len(vec))
        # for i in range(0, length):
        #     total = 0
        #     for vec in features:
        #         if i < len(vec):
        #             total = total + vec[i]
        #     featureLine.append(total)
        # spamwriter.writerow(featureLine)

            




        