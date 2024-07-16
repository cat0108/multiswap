import numpy as np
from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs
import time


np.random.seed(42)
samples, labels = make_blobs(n_samples=40000000, centers=10, random_state=0)
k_means = KMeans(10)
k_means.fit(samples)

