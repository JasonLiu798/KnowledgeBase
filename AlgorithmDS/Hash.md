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
按机器唯一ID 计算hash 映射到圆环
key 计算hash映射到圆环，顺时针找到机器，超过最大，则映射到第一个

增加虚节点


























