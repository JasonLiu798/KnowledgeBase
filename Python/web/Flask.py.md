

url转换器
```python
@app.route('/user/<username>')
def show_user_profile(username):
    # show the user profile for that user
    return 'User %s' % username

@app.route('/post/<int:post_id>')
def show_post(post_id):
    # show the post with the given id, the id is an integer
    return 'Post %d' % post_id
```
int 接受整数
float   接受浮点数
path    和缺省情况相同，但也接受斜杠




#跨域
http://flask-cors.readthedocs.io/en/latest/

pip install -U flask-cors

```py
from flask import Flask
from flask_cors import CORS, cross_origin

app = Flask(__name__)
CORS(app)

@app.route("/")
def helloWorld():
  return "Hello, cross-origin-world!"
```


















