import numpy as np 
import pandas as pd 
import sklearn

from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report

import seaborn as sns

from flask import Flask, jsonify, request

import csv
from pathlib import Path

# price              int64  <-- return predicted value
# bedrooms           int64
# bathrooms        float64
# sqft_living        int64
# sqft_lot           int64
# floors           float64
# waterfront         int64
# view               int64
# condition          int64
# grade              int64
# sqft_above       float64
# sqft_basement      int64
# yr_built           int64
# renovated          int64
# lat              float64
# long             float64

def predict(bedrooms, bathrooms, sqft_living, sqft_lot, 
floors, waterfront, view, condition, grade, sqft_above, sqft_basement, yr_built, renovated,
lat, long):

    col_names = ['price', 'bedrooms', 'bathrooms', 'sqft_living', 'sqft_lot', 
    'floors', 'waterfront', 'view', 'condition', 'grade', 'sqft_above', 'sqft_basement', 'yr_built', 'renovated',
    'lat', 'long']

    df = pd.read_csv('kc_house_format_data.csv', header=None, names=col_names)

    feature_cols = ['bedrooms', 'bathrooms', 'sqft_living', 'sqft_lot', 
    'floors', 'waterfront', 'view', 'condition', 'grade', 'sqft_above', 'sqft_basement', 'yr_built', 'renovated',
    'lat', 'long']

    X = df[feature_cols] # Features
    y = df.price # Target variable

    X_train,X_test,y_train,y_test = train_test_split(X,y,test_size=0.1,random_state=0)

    logmodel = LogisticRegression()

    logmodel.fit(X_train,y_train)

    # Use score method to get accuracy of model
    score = logmodel.score(X_test, y_test)
    print("Accuracy: ", score)


    # define input
    predictInput = [[int(bedrooms),float(bathrooms),int(sqft_living),int(sqft_lot),float(floors),
    int(waterfront),int(view),int(condition),int(grade),float(sqft_above),int(sqft_basement),
    int(yr_built),int(renovated),float(lat),float(long)]]

    predictions = logmodel.predict(predictInput)

    price = predictions[0]

    print(f'price is ${price}')

    return price

# call predict price
predict(3,3.25,5020,12431,2,1,4,3,10,3420,1600,1941,1,47.5925,-122.287)

# app = Flask(__name__)
# @app.route('/', methods=['GET', 'POST']) 
# def index():
#     if (request.method == 'POST'):
#         json_data = request.get_json()
#         print(json_data)

#         # expected JSON
#         {
#         "bedrooms": 6,
#         "bathrooms": 1.5,
#         "sqft_living": 123,
#         "sqft_lot": 100,
#         "floors": 1.5,
#         "waterfront": 1,
#         "view": 1,
#         "condition": 1,
#         "grade": 5,
#         "sqft_above": 123,
#         "sqft_basement": 123,
#         "yr_built": 2017,
#         "renovated": 1,
#         "lat": 111.0,
#         "long": -123.33
#         }

#         bedrooms = json_data["bedrooms"]
#         bathrooms = json_data["bathrooms"]
#         sqft_living = json_data["sqft_living"]
#         sqft_lot = json_data["sqft_lot"]
#         floors = json_data["floors"]
#         waterfront = json_data["waterfront"]
#         view = json_data["view"]
#         condition = json_data["condition"]
#         grade = json_data["grade"]
#         sqft_above = json_data["sqft_above"]
#         sqft_basement = json_data["sqft_basement"]
#         yr_built = json_data["yr_built"]
#         renovated = json_data["renovated"]
#         lat = json_data["lat"]
#         long = json_data["long"]
#         res = int(predict(int(bedrooms),float(bathrooms),int(sqft_living),int(sqft_lot),float(floors),int(waterfront),int(view),int(condition),int(grade),float(sqft_above),int(sqft_basement),int(yr_built),int(renovated),float(lat),float(long)))
#         return jsonify({'data': res})
#     else:
#         return "HELLO WORLD IT'S ME"

# if __name__ == '__main__':
#     app.run(debug=True)