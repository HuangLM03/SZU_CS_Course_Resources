import numpy as np
import matplotlib.pyplot as plt
import mne
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import FunctionTransformer
from mne.preprocessing import (ICA, create_eog_epochs, create_ecg_epochs,
                               corrmap)
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
import hdf5storage as hdf5
 
 
def eeg_power_band(epochs):
    FREQ_BANDS = {"delta": [0.5, 4.5],
                  "theta": [4.5, 8.5],
                  "alpha": [8.5, 11.5],
                  "sigma": [11.5, 15.5],
                  "beta": [15.5, 30]}
    spectrum = epochs.compute_psd(method='welch', picks='eeg', fmin=0.5, fmax=30., n_fft=64, n_overlap=10)
    des, freqs = spectrum.get_data(return_freqs=True)

    des /= np.sum(des, axis=-1, keepdims=True)
    X = []
    for fmin, fmax in FREQ_BANDS.values():
        des_band = psds[:, :, (freqs >= fmin) & (freqs < fmax)].mean(axis=-1)
        X.append(psds_band.reshape(len(psds), -1))
 
    return np.concatenate(X, axis=1)
 
 
if __name__ == "__main__" :
    raw = hdf5.loadmat('FACED_dataset_2_labels.mat')['de_lds']
    print(rwa.shape) 
    
    n_samples, n_times, n_channels = raw.shape
    raw = raw.reshape(n_samples, -1)
    event_id = {'rt': 1, 'square': 2}
    epochs_train = raw.copy()
    epochs_train = epochs_train.crop(0, 100)
    epochs_test = raw.crop(100, 134)
 
    pipe = make_pipeline(FunctionTransformer(eeg_power_band, validate=False),
                         SVC(C=1.2, kernel='rbf'))

    y_train = epochs_train.events[:, 2]
    pipe.fit(epochs_train, y_train)
 
    y_pred = pipe.predict(epochs_test)
 
    y_test = epochs_test.events[:, 2]
    acc = accuracy_score(y_test, y_pred)
 
    print("Accuracy score: {:.2f}".format(acc))