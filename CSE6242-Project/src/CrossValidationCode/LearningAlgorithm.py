import sys
import scipy
import numpy

import pandas
from pandas.plotting import scatter_matrix
import matplotlib.pyplot as plt
from sklearn import model_selection
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC
from sklearn.neural_network import MLPClassifier
from sklearn.ensemble import AdaBoostClassifier


# Data preparation (Wine quality)
names = ['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar', 'chlorides',
         'free sulfur dioxide', 'total sulfur dioxide', 'density', 'pH', 'sulphates', 'alcohol', 'quality']
database = pandas.read_csv('data_input.csv', names=names, engine='python')  
database = database[1:]
val_in = database.values[:, 0:11]
val_out = database.values[:, 11]

# Data preparation (Blood Donation)
# url = "https://archive.ics.uci.edu/ml/machine-learning-databases/blood-transfusion/transfusion.data"
# names = ['Recency', 'Frequency', 'Monetary', 'Time', 'donated blood']
# database = pandas.read_csv(url, names=names)
# database = database[1:]
# val_in = database.values[:, 0:4]
# val_out = database.values[:, 4]

# Data preparation (Yeast Collection)
# names = ['Sequence Name', 'mcg', 'gvh', 'alm', 'mit', 'erl', 'pox', 'vac', 'nuc', 'class']
# database = pandas.read_csv('yeast.data', names=names, engine='python')
# val_in = database.values[:, 1:9]
# val_out = database.values[:, 9]

# print(database.shape)
# print(database.head(10))
# print(database.groupby('donated blood').size())
#
train_score = []
test_score = []
prop_score = []

for prop in range(1, 10):
    test_prop = prop / 10.0
    seeding = 10
    train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                              val_out,
                                                                              test_size=test_prop,
                                                                              random_state=seeding)

    # Decision tree
    dec_tree = DecisionTreeClassifier(criterion='gini',
                                      splitter='best',
                                      max_depth=4,
                                      min_samples_split=100,
                                      min_samples_leaf=100,
                                      max_leaf_nodes=4)
    dec_tree.fit(train_in, train_out)
    # print('Decision Tree:')
    train_score.append(dec_tree.score(train_in, train_out))
    test_score.append(dec_tree.score(test_in, test_out))
    prop_score.append(test_prop)
    # print(dec_tree.score(train_in, train_out))
    # print(dec_tree.score(test_in, test_out))

plt.plot(prop_score, train_score, 'r', label='Train set')
plt.plot(prop_score, test_score, 'g', label='Test set')
plt.title('Decision Tree')
plt.xlabel('Test set size')
plt.ylabel('Accuracy')
plt.show()

train_score = []
test_score = []
prop_score = []

for prop in range(1, 10):
    test_prop = prop / 10.0
    seeding = 10
    train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                              val_out,
                                                                              test_size=test_prop,
                                                                              random_state=seeding)

    # Decision tree
    neural_net = MLPClassifier()
    neural_net.fit(train_in, train_out)
    # print('Decision Tree:')
    train_score.append(neural_net.score(train_in, train_out))
    test_score.append(neural_net.score(test_in, test_out))
    prop_score.append(test_prop)
    # print(dec_tree.score(train_in, train_out))
    # print(dec_tree.score(test_in, test_out))

plt.plot(prop_score, train_score, 'r', label='Train set')
plt.plot(prop_score, test_score, 'g', label='Test set')
plt.title('Neural Network')
plt.xlabel('Test set size')
plt.ylabel('Accuracy')
plt.show()

train_score = []
test_score = []
prop_score = []

for prop in range(1, 10):
    test_prop = prop / 10.0
    seeding = 10
    train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                              val_out,
                                                                              test_size=test_prop,
                                                                              random_state=seeding)

    # Decision tree
    boost_tree = AdaBoostClassifier(DecisionTreeClassifier(criterion='gini',
                                      splitter='best',
                                      max_depth=4,
                                      min_samples_split=100,
                                      min_samples_leaf=100,
                                      max_leaf_nodes=4),
                                    algorithm='SAMME')
    boost_tree.fit(train_in, train_out)
    # print('Decision Tree:')
    train_score.append(boost_tree.score(train_in, train_out))
    test_score.append(boost_tree.score(test_in, test_out))
    prop_score.append(test_prop)
    # print(dec_tree.score(train_in, train_out))
    # print(dec_tree.score(test_in, test_out))

plt.plot(prop_score, train_score, 'r', label='Train set')
plt.plot(prop_score, test_score, 'g', label='Test set')
plt.title('Boosting')
plt.xlabel('Test set size')
plt.ylabel('Accuracy')
plt.show()

train_score = []
test_score = []
prop_score = []

for prop in range(1, 10):
    test_prop = prop / 10.0
    seeding = 10
    train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                              val_out,
                                                                              test_size=test_prop,
                                                                              random_state=seeding)

    # Decision tree
    knn = KNeighborsClassifier()
    knn.fit(train_in, train_out)
    # print('Decision Tree:')
    train_score.append(knn.score(train_in, train_out))
    test_score.append(knn.score(test_in, test_out))
    prop_score.append(test_prop)
    # print(dec_tree.score(train_in, train_out))
    # print(dec_tree.score(test_in, test_out))

plt.plot(prop_score, train_score, 'r', label='Train set')
plt.plot(prop_score, test_score, 'g', label='Test set')
plt.title('KNN')
plt.xlabel('Test set size')
plt.ylabel('Accuracy')
plt.show()

train_score = []
test_score = []
prop_score = []

for prop in range(1, 10):
    test_prop = prop / 10.0
    seeding = 10
    train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                              val_out,
                                                                              test_size=test_prop,
                                                                              random_state=seeding)

    # Decision tree
    SVM_method = SVC(gamma='auto', kernel='rbf')    # kernel value can be changed into 'linear' or 'poly'
    SVM_method.fit(train_in, train_out)
    # print('Decision Tree:')
    train_score.append(SVM_method.score(train_in, train_out))
    test_score.append(SVM_method.score(test_in, test_out))
    prop_score.append(test_prop)
    # print(dec_tree.score(train_in, train_out))
    # print(dec_tree.score(test_in, test_out))

plt.plot(prop_score, train_score, 'r', label='Train set')
plt.plot(prop_score, test_score, 'g', label='Test set')
plt.title('SVM')
plt.xlabel('Test set size')
plt.ylabel('Accuracy')
plt.show()

# Test for KNN with different N values
k_values = []
train_score = []
test_score = []
test_prop = 0.1
seeding = 10
train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                          val_out,
                                                                          test_size=test_prop,
                                                                          random_state=seeding)
for i in range(1, 21):
    knn = KNeighborsClassifier(n_neighbors=i)
    knn.fit(train_in, train_out)
    # print('knn result with k = {}:'.format(i))
    # print(knn.score(train_in, train_out))
    # print(knn.score(test_in, test_out))
    k_values.append(i)
    train_score.append(knn.score(train_in, train_out))
    test_score.append(knn.score(test_in, test_out))
plt.plot(k_values, train_score, 'r', label='Train set')
plt.plot(k_values, test_score, 'g', label='Test set')
plt.title('KNN with different K')
plt.xlabel('K values')
plt.ylabel('Accuracy')
plt.show()

# cross validation
# print('K fold cross validation:')
test_prop = 0.1
seeding = 10
result_list = []
train_in, test_in, train_out, test_out = model_selection.train_test_split(val_in,
                                                                          val_out,
                                                                          test_size=test_prop,
                                                                          random_state=seeding)

fold = model_selection.KFold(n_splits=15, random_state=seeding)
result = model_selection.cross_val_score(DecisionTreeClassifier(criterion='gini',
                                  splitter='best',
                                  max_depth=4,
                                  min_samples_split=100,
                                  min_samples_leaf=100,
                                  max_leaf_nodes=4), train_in, train_out, cv=fold, scoring='accuracy')
result_list.append(result)
fold = model_selection.KFold(n_splits=15, random_state=seeding)
result = model_selection.cross_val_score(MLPClassifier(max_iter=200), train_in, train_out, cv=fold, scoring='accuracy')
result_list.append(result)
fold = model_selection.KFold(n_splits=15, random_state=seeding)
result = model_selection.cross_val_score(AdaBoostClassifier(DecisionTreeClassifier(criterion='gini',
                                      splitter='best',
                                      max_depth=4,
                                      min_samples_split=100,
                                      min_samples_leaf=100,
                                      max_leaf_nodes=4),
                                    algorithm='SAMME'), train_in, train_out, cv=fold, scoring='accuracy')
result_list.append(result)
fold = model_selection.KFold(n_splits=15, random_state=seeding)
result = model_selection.cross_val_score(SVC(gamma='auto'), train_in, train_out, cv=fold, scoring='accuracy')
result_list.append(result)
fold = model_selection.KFold(n_splits=15, random_state=seeding)
result = model_selection.cross_val_score(KNeighborsClassifier(), train_in, train_out, cv=fold, scoring='accuracy')
result_list.append(result)

# Compare Algorithms
fig = plt.figure()
fig.suptitle('Algorithm Comparison with cross validation')
ax = fig.add_subplot(111)
plt.boxplot(result_list)
ax.set_xticklabels(['Decision\nTree', 'Neural\nNetwork', 'Boosting', 'SVM', 'KNN'])
plt.show()