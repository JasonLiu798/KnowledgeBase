# 性能优化

## 开启gzip
[【spring】通过GZIP压缩提高网络传输效率（可以实现任何资源的gzip压缩、包括AJAX）](http://blog.csdn.net/szwangdf/article/details/43984773)
```java
	public void xxx(@RequestBody RptGetReq reqDto, HttpServletRequest req, HttpServletResponse resp) {
        ResponseDataDtoV1 respDto = ResponseDataDtoV1.buildOk(xxx.get(reqDto));

        String respStr = JSONFastJsonUtil.objectToJson(respDto);
        String encoding = req.getHeader("Accept-Encoding");
        boolean useZip = false;
        if (encoding.indexOf("gzip") != -1) {
            useZip = true;
        }

        byte[] respBytes = null;
        boolean fail = false;
        if (useZip) {
            try {
                respBytes = GzipUtil.compress(respStr);
            } catch (IOException e) {
                log.error("gzip error", e);
                fail = true;
            }
            resp.addHeader("Content-Encoding", "gzip");
        }

        if (!useZip || fail) {
            try {
                respBytes = respStr.getBytes("UTF-8");
            } catch (UnsupportedEncodingException e1) {
                log.error("to byte error", e1);
            }
        }
        resp.setContentType(MediaType.APPLICATION_JSON_VALUE); //设置ContentType
        if (respBytes != null) {
            resp.setContentLength(respBytes.length);
        }else{
        	resp.setContentLength(0);
        	return;
        }
        resp.setCharacterEncoding("UTF-8");
        try {
            ServletOutputStream out = resp.getOutputStream();
            out.write(respBytes);
        } catch (IOException e) {
            log.error("out write fail", e);
        }
    }
```



