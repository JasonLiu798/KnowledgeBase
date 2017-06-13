#Hash
---
#times33算法
    APR_DECLARE_NONSTD(unsigned int) apr_hashfunc_default( const   char  *char_key, apr_ssize_t *klen)  
    {  
        unsigned int  hash = 0;  
        const  unsigned  char  *key = ( const  unsigned  char  *)char_key;  
        const  unsigned  char  *p;  
        apr_ssize_t i;  
          
        /*  
         - This is the popular `times 33' hash algorithm which is used by  
         - perl and also appears in Berkeley DB. This is one of the best  
         - known hash functions for strings because it is both computed  
         - very fast and distributes very well.  
         -  
         - The originator may be Dan Bernstein but the code in Berkeley DB  
         - cites Chris Torek as the source. The best citation I have found  
         - is "Chris Torek, Hash function for text in C, Usenet message  
         - <27038@mimsy.umd.edu> in comp.lang.c , October, 1990." in Rich  
         - Salz's USENIX 1992 paper about INN which can be found at  
         - <http://citeseer.nj.nec.com/salz92internetnews.html>.  
         -  
         - The magic of number 33, i.e. why it works better than many other  
         - constants, prime or not, has never been adequately explained by  
         - anyone. So I try an explanation: if one experimentally tests all  
         - multipliers between 1 and 256 (as I did while writing a low-level  
         - data structure library some time ago) one detects that even  
         - numbers are not useable at all. The remaining 128 odd numbers  
         - (except for the number 1) work more or less all equally well.  
         - They all distribute in an acceptable way and this way fill a hash  
         - table with an average percent of approx. 86%.  
         -  
         - If one compares the chi^2 values of the variants (see  
         - Bob Jenkins ``Hashing Frequently Asked Questions'' at  
         - http://burtleburtle.net/bob/hash/hashfaq.html for a description  
         - of chi^2), the number 33 not even has the best value. But the  
         - number 33 and a few other equally good numbers like 17, 31, 63,  
         - 127 and 129 have nevertheless a great advantage to the remaining  
         - numbers in the large set of possible multipliers: their multiply  
         - operation can be replaced by a faster operation based on just one  
         - shift plus either a single addition or subtraction operation. And  
         - because a hash function has to both distribute good _and_ has to  
         - be very fast to compute, those few numbers should be preferred.  
         -  
         -                  -- Ralf S. Engelschall <rse@engelschall.com>  
         */   
           
        if  (*klen == APR_HASH_KEY_STRING) {  
            for  (p = key; *p; p++) {  
                hash = hash * 33 + *p;  
            }  
            *klen = p - key;  
        }  
        else  {  
            for  (p = key, i = *klen; i; i--, p++) {  
                hash = hash * 33 + *p;  
            }  
        }  
        return  hash;  
    }  


---
#一致性hash
[Ketama一致性Hash算法(含Java代码)](http://langyu.iteye.com/blog/684087)
按机器唯一ID 计算hash 映射到圆环
key 计算hash映射到圆环，顺时针找到机器，超过最大，则映射到第一个

增加虚节点

```java
public class Shard<S> { // S类封装了机器节点的信息 ，如name、password、ip、port等
    private TreeMap<Long, S> nodes; // 虚拟节点
    private List<S> shards; // 真实机器节点
    private final int NODE_NUM = 100; // 每个机器节点关联的虚拟节点个数
    
    public Shard(List<S> shards) {
        super();
        this.shards = shards;
        init();
    }

    private void init() { // 初始化一致性hash环
        nodes = new TreeMap<Long, S>();
        for (int i = 0; i != shards.size(); ++i) { // 每个真实机器节点都需要关联虚拟节点
            final S shardInfo = shards.get(i);

            for (int n = 0; n < NODE_NUM; n++)
                // 一个真实机器节点关联NODE_NUM个虚拟节点
                nodes.put(hash("SHARD-" + i + "-NODE-" + n), shardInfo);

        }
    }

    public S getShardInfo(String key) {
        SortedMap<Long, S> tail = nodes.tailMap(hash(key)); // 沿环的顺时针找到一个虚拟节点
        if (tail.size() == 0) {
            return nodes.get(nodes.firstKey());
        }
        return tail.get(tail.firstKey()); // 返回该虚拟节点对应的真实机器节点的信息
    }

    /**
     *  MurMurHash算法，是非加密HASH算法，性能很高，
     *  比传统的CRC32,MD5，SHA-1（这两个算法都是加密HASH算法，复杂度本身就很高，带来的性能上的损害也不可避免）
     *  等HASH算法要快很多，而且据说这个算法的碰撞率很低.
     *  http://murmurhash.googlepages.com/
     */
    private Long hash(String key) {
        
        ByteBuffer buf = ByteBuffer.wrap(key.getBytes());
        int seed = 0x1234ABCD;
        
        ByteOrder byteOrder = buf.order();
        buf.order(ByteOrder.LITTLE_ENDIAN);

        long m = 0xc6a4a7935bd1e995L;
        int r = 47;

        long h = seed ^ (buf.remaining() * m);

        long k;
        while (buf.remaining() >= 8) {
            k = buf.getLong();

            k *= m;
            k ^= k >>> r;
            k *= m;

            h ^= k;
            h *= m;
        }

        if (buf.remaining() > 0) {
            ByteBuffer finish = ByteBuffer.allocate(8).order(
                    ByteOrder.LITTLE_ENDIAN);
            // for big-endian version, do this first:
            // finish.position(8-buf.remaining());
            finish.put(buf).rewind();
            h ^= finish.getLong();
            h *= m;
        }

        h ^= h >>> r;
        h *= m;
        h ^= h >>> r;

        buf.order(byteOrder);
        return h;
    }

}

```
























