#自动集成
-----
#jekins






----
#hudson
java -jar hudson-3.2.2.war --httpPort=9090
http://127.0.0.1:9090


new mission
    
    Discard Old Builds
    Build trigger
        Poll SCM
            #every ten miniutes
            */10 * * * *