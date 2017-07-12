# https://www.udemy.com/unsupervised-deep-learning-in-python
import numpy as np
import pandas as pd

from sklearn.utils import shuffle

def relu(x):
    return x * (x > 0)


def error_rate(p, t):
    return np.mean(p != t)

def normalize(col):
    return (col - col.mean()) / col.std()


def getKaggleMNIST():
    # MNIST data:
    # column 0 is labels
    # column 1-785 is data, with values 0 .. 255
    # total size of CSV: (42000, 1, 28, 28)
    
    #pd.read_excel

    train = pd.read_csv('../large_files/train.csv').as_matrix().astype(np.float32)

    train = shuffle(train)

    Xtrain = train[:-1000,1:] / 255
    Ytrain = train[:-1000,0].astype(np.int32)

    Xtest  = train[-1000:,1:] / 255
    Ytest  = train[-1000:,0].astype(np.int32)
    return Xtrain, Ytrain, Xtest, Ytest

def getBankruptcy():
    train = pd.read_csv('../large_files/Qualitative_Bankruptcy.data.csv').as_matrix().astype(np.float32)
    train = shuffle(train)

    Xtrain = train[:,:5]
    Xtrain = Xtrain / Xtrain.mean()
    #normalize
    Ytrain = train[:,6].astype(np.int32)

    return Xtrain, Ytrain #, Xtest, Ytest

def getSolar():
    # Solar cells data:
    # columns C through G are data
    # column H is class

    train = pd.read_excel('./solar cells DataBase.xlsx', header=0).as_matrix().astype(np.float32)
    for i in range(2, 7):
        train[:, i] = normalize(train[:, i])
    train = shuffle(train)

    Xtrain = train[:,2:6]
    Xtrain = Xtrain / Xtrain.mean()
    #normalize
    Ytrain = train[:,7].astype(np.int32)

    return Xtrain, Ytrain #, Xtest, Ytest


def init_weights(shape):
    return np.random.randn(*shape) / np.sqrt(sum(shape))