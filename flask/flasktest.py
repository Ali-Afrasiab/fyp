import pickle
from flask import Flask, render_template, request, redirect, url_for, jsonify
app = Flask(__name__)
#@app.route('/', methods=['GET'])
# loaded_model=load('finalized_model.pkl')

#loaded_model = pickle.load(open('finalized_model.pkl', 'rb'))
with open('finalized_model.pkl', 'rb') as f_in:
    loaded_model = pickle.load(f_in)
    f_in.close()

@app.route('/predict_covid/<array>', methods=['GET'])
#def function():
    #return jsonify({'greetings': 'Hi! This is python'})
    #return "hi"
def predict_covid(array):
    arr=[[]]
    for i in range(0,len(array),2):
        arr[0].append(array[i])
    loaded_model = pickle.load(open('finalized_model.pkl', 'rb'))
    
    result = loaded_model.predict(arr)
    return str(result[0])   

if __name__ == '__main__':
  #app.run(debug=True,use_reloader=True)
  app.run(debug=False,ssl_context='adhoc')