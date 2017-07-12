# https://www.udemy.com/unsupervised-deep-learning-in-python
import numpy as np
import matplotlib.pyplot as plt

from sklearn.manifold import TSNE
from util import getSolar


def main():
    # Xtrain, Ytrain, _, _ = getKaggleMNIST()
    X, Y = getSolar()
    # sample_size = 1000
    # X = Xtrain[:sample_size]
    # Y = Ytrain[:sample_size]

    for p in xrange(5, 50, 5):
        tsne = TSNE(perplexity=p, method='exact', n_iter=5000)
        Z = tsne.fit_transform(X)
        print(Z)
        fig = plt.figure(p)
        fig.suptitle('perplexity ' + str(p), fontsize=14, fontweight='bold')
        plt.scatter(Z[:,0], Z[:,1], s=100, c=Y, alpha=0.5)
        plt.savefig('./images/tsne' + str(p) + '.png')
        print ('finished iteration ' + str(p))

if __name__ == '__main__':
    main()