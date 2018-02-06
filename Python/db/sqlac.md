

#自动生成
sqlacodegen mysql+pymysql://root:root@10.202.125.245:3306/bk > models.py



------
#批量插入
http://docs.sqlalchemy.org/en/rel_1_0/orm/persistence_techniques.html

```py
s = Session()
objects = [
    User(name="u1"),
    User(name="u2"),
    User(name="u3")
]
s.bulk_save_objects(objects)

'''
For Session.bulk_insert_mappings(), and Session.bulk_update_mappings(), dictionaries are passed:
'''
s.bulk_insert_mappings(User,
  [dict(name="u1"), dict(name="u2"), dict(name="u3")]
)
```
See also
Session.bulk_save_objects()
Session.bulk_insert_mappings()
Session.bulk_update_mappings()




----------
#json
http://www.cnblogs.com/wancy86/p/6421792.html
[How to serialize SqlAlchemy result to JSON?](https://stackoverflow.com/questions/5022066/how-to-serialize-sqlalchemy-result-to-json)

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

A recursive, possibly-circular, selective implementation
```py
def new_alchemy_encoder(revisit_self = False, fields_to_expand = []):
    _visited_objs = []
    class AlchemyEncoder(json.JSONEncoder):
        def default(self, obj):
            if isinstance(obj.__class__, DeclarativeMeta):
                # don't re-visit self
                if revisit_self:
                    if obj in _visited_objs:
                        return None
                    _visited_objs.append(obj)

                # go through each field in this SQLalchemy class
                fields = {}
                for field in [x for x in dir(obj) if not x.startswith('_') and x != 'metadata']:
                    val = obj.__getattribute__(field)

                    # is this field another SQLalchemy object, or a list of SQLalchemy objects?
                    if isinstance(val.__class__, DeclarativeMeta) or (isinstance(val, list) and len(val) > 0 and isinstance(val[0].__class__, DeclarativeMeta)):
                        # unless we're expanding this field, stop here
                        if field not in fields_to_expand:
                            # not expanding this field: set it to None and continue
                            fields[field] = None
                            continue

                    fields[field] = val
                # a json-encodable dict
                return fields

            return json.JSONEncoder.default(self, obj)
    return AlchemyEncoder

print json.dumps(e, cls=new_alchemy_encoder(False, ['parents']), check_circular=False)
```

##as dict
```py
class User:
   def as_dict(self):
       return {c.name: getattr(self, c.name) for c in self.__table__.columns}
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



使用__repr__定义返回的数据
```
class User(Base):
    __tablename__ = 'user'
    nid = Column(Integer,primary_key=True,autoincrement=True)
    name = Column(String(10),nullable=False)
    role = Column(Integer,ForeignKey('role.rid'))
    group = relationship("Role",backref='uuu')    #Role为类名

    def __repr__(self):
        output = "(%s,%s,%s)" %(self.nid,self.name,self.role)
        return output
```


----
#Q
##sqlalchemy.exc.UnboundExecutionError: Instance <MyClass at 0x8db7fec> is not bound to a Session; attribute refresh operation cannot proceed

In your first function example, you will need to add a line:

session.expunge_all()
before

session.close()
More generally, let's say the session is not closed right away, like in the first example. Perhaps this is a session that is kept active during entire duration of a web request or something like that. In such cases, you don't want to do expunge_all. You will want to be more surgical:

for item in lst:
    session.expunge(item)










