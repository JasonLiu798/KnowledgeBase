
# HBase 0.94之后Split策略
HBase 0.94之后split策略发生变更，导致原先的hbase.hregion.max.filesize参数失效。简单介绍一下新的split策略。
## HBase 0.94之前版本
split使用的是ConstantSizeRegionSplitPolicy。当region中文件大小超过配置中所指定大小时，会进行切分。

## 0.94版本之后
默认split策略修改为了IncreasingToUpperBoundRegionSplitPolicy。该策略使用了另一种方法来计算是否应当切割，导致原先的参数失效。

该方法中的分配策略，是根据table中region的个数平方，乘以memstore的大小。得出应当切分的大小。

假设memstoreSize配置为128M，则在memstore第一次刷入HFile数据时，进行第一次split，1 * 1 * 128M = 128M。
当region数达到2个时，2 * 2 * 128M = 512M。
当region数达到3个时，3 * 3 * 128M = 1152M。
依此类推。
当region个数到达30个时，30 * 30 * 128 = 107648M = 105.1G。即在此时，region的切分大小已经超过了我们原先在ConstantSizeRegionSplitPolicy策略中设置的100G大小。

## 简单分析
对这种策略进行简单的分析，可以看到，在数据写入初期，这种策略可以快速的对现有region进行split，使得在一开始就可以将热点region切分到多个server上。同时由于region size较小，也可以避免split操作对写入的阻塞。
而在后期，当region数量逐渐增多，单个regionSize逐渐增大时，split频率会急速减少，避免在region过大时频繁split的情况。
这种策略一方面在数据量增大的情况下减少了region的切分次数，达到了我们期望的尽量减少split的需求，避免对写入造成影响。同时在初期的快速切分，在基本不影响写入的同时，也减少了我们原先需要手动操作split的问题。可以认为，这种策略是符合我们需求的。当然，还需要进一步的测试来进行验证。
```java
/**
 * @return Region max size or <code>count of regions squared * flushsize, which ever is
 * smaller; guard against there being zero regions on this server.
 */
long getSizeToCheck(final int tableRegionsCount) {
  return tableRegionsCount == 0? getDesiredMaxFileSize():
    Math.min(getDesiredMaxFileSize(),
      this.flushSize * (tableRegionsCount * tableRegionsCount));
}
 
@Override
protected boolean shouldSplit() {
  if (region.shouldForceSplit()) return true;
  boolean foundABigStore = false;
  // Get count of regions that have the same common table as this.region
  int tableRegionsCount = getCountOfCommonTableRegions();
  // Get size to check
  long sizeToCheck = getSizeToCheck(tableRegionsCount);
 
  for (Store store : region.getStores().values()) {
    // If any of the stores is unable to split (eg they contain reference files)
    // then don't split
    if ((!store.canSplit())) {
      return false;
    }
 
    // Mark if any store is big enough
    long size = store.getSize();
    if (size > sizeToCheck) {
      LOG.debug("ShouldSplit because " + store.getColumnFamilyName() +
        " size=" + size + ", sizeToCheck=" + sizeToCheck +
        ", regionsWithCommonTable=" + tableRegionsCount);
      foundABigStore = true;
      break;
    }
  }
 
  return foundABigStore;
}
```
可详见：
http://hbase.apache.org/0.94/xref/org/apache/hadoop/hbase/regionserver/IncreasingToUpperBoundRegionSplitPolicy.html















