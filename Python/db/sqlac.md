

#自动生成
sqlacodegen mysql+pymysql://root:root@10.202.125.245:3306/bk > models.py


#json
http://www.cnblogs.com/wancy86/p/6421792.html
##旧版
```py
import json
from sqlalchemy.ext.declarative import DeclarativeMeta
from datetime import datetime

def new_alchemy_encoder():
    _visited_objs = []

    class AlchemyEncoder(json.JSONEncoder):
        def default(self, obj):
            if isinstance(obj.__class__, DeclarativeMeta):
                # don't re-visit self
                if obj in _visited_objs:
                    return None
                _visited_objs.append(obj)

                # an SQLAlchemy class
                fields = {}
                for field in [x for x in dir(obj) if not x.startswith('_') and x != 'metadata']:
                    data = obj.__getattribute__(field)
                    try:
                        if isinstance(data, datetime):
                            data = data.strftime('%Y-%m-%d %H:%M:%S')
                        json.dumps(data)  # this will fail on non-encodable values, like other classes
                        fields[field] = data
                    except TypeError:
                        fields[field] = None
                return fields

            return json.JSONEncoder.default(self, obj)
    return AlchemyEncoder


UnReadMsg = self.db.query(Message).filter(Message.uid == self.uid)
msgs = []
for msg in UnReadMsg:
    msgs.append(msg)
UnReadMsg = json.dumps(msgs, cls=new_alchemy_encoder(), check_circular=False)
```

##新版
```py
UnReadMsg = self.db.query(Message).filter(Message.uid == self.uid)
msgs = []
for msg in UnReadMsg:
    msgs.append(msg.json)
print(msgs)
return JsonResponse(self, 50000, data=msgs)   
```

















