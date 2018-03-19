


# 预置样式
https://stackoverflow.com/questions/2643822/how-can-i-use-predefined-formats-in-docx-with-poi
It's very simple: Use a "template" docx file.

Create an empty docx file with Word 2007.
Use this file as a template for your XWPFDocument
Add your paragraphs with the styles.
Here's the code:

XWPFDocument document = new XWPFDocument(new FileInputStream("template.docx");
paragraph = document.createParagraph();
paragraph.setStyle("Heading1");
The template contains all styles and therefore they can referenced via setStyle("Heading1");.

# 大纲格式
[POI操作word2010实现多级标题结构](http://blog.csdn.net/oh_maxy/article/details/46515619)


# 分页符
<br clear=all style="page-break-before:always" mce_style="page-break-before:always"> 


经常导出word功能，想在jsp、html中控制word的页数、在指定的位置进行分页可以通过这段代码进行分页。

# word转html
[利用POI将word转换成html实现在线阅读](http://blog.csdn.net/jbjwpzyl3611421/article/details/49612537)

# 横向打印
首先在页面的head中加下面的一段代码 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style>
<!--
 @page
    {mso-page-border-surround-header:no;
    mso-page-border-surround-footer:no;}
@page Section1
    {size:841.9pt 595.3pt;
    mso-page-orientation:landscape;
    margin:89.85pt 72.0pt 89.85pt 72.0pt;
    mso-header-margin:42.55pt;
    mso-footer-margin:49.6pt;
    mso-paper-source:0;
    layout-grid:15.6pt;}
div.Section1
    {page:Section1;}
-->
</style>
</head>
然后用div包含整个的显示内容，会调用上面的style
<div class=Section1>
</div>
下面是告诉IE是用Word打开此文件。
 asp实现
<%
   Response.AddHeader"content-Type","application/msword"
   Response.AddHeader"content-Disposition","filename=机要文件一览表" &date()& ".doc;attachment;"
   Response.Flush
  %>
.net可以通过下面的代码实现
 this.Page.Response.AddHeader("content-Type: ","application/msword); 
this.Page.Response.AddHeader("Content-Disposition: ","attachment;filename="+name);


---
```java
//word 2 html 代码示例
package com.my.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.model.PicturesTable;
import org.apache.poi.hwpf.usermodel.CharacterRun;
import org.apache.poi.hwpf.usermodel.Paragraph;
import org.apache.poi.hwpf.usermodel.Picture;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.hwpf.usermodel.Table;
import org.apache.poi.hwpf.usermodel.TableCell;
import org.apache.poi.hwpf.usermodel.TableIterator;
import org.apache.poi.hwpf.usermodel.TableRow;

public class WordExcelToHtml1 {
    /**
     * 回车符ASCII码
     */
    private static final short ENTER_ASCII = 13;
    /**
     * 空格符ASCII码
     */
    private static final short SPACE_ASCII = 32;

    /**
     * 水平制表符ASCII码
     */
    private static final short TABULATION_ASCII = 9;

    public static String htmlText = "";
    public static String htmlTextTbl = "";
    public static int counter = 0;
    public static int beginPosi = 0;
    public static int endPosi = 0;
    public static int beginArray[];
    public static int endArray[];
    public static String htmlTextArray[];
    public static boolean tblExist = false;

    public static final String inputFile = "c://cc.doc";

    public static void main(String argv[]) {
        try {
            getWordAndStyle(inputFile);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 读取每个文字样式
     * 
     * @param fileName
     * @throws Exception
     */

    public static void getWordAndStyle(String fileName) throws Exception {
        FileInputStream in = new FileInputStream(new File(fileName));
        HWPFDocument doc = new HWPFDocument(in);
        Range rangetbl = doc.getRange();// 得到文档的读取范围
        TableIterator it = new TableIterator(rangetbl);
        int num = 100;
        beginArray = new int[num];
        endArray = new int[num];
        htmlTextArray = new String[num];
        // 取得文档中字符的总数
        int length = doc.characterLength();
        // 创建图片容器
        PicturesTable pTable = doc.getPicturesTable();
        htmlText = "<html><head><title>"
                + doc.getSummaryInformation().getTitle()
                + "</title></head><body>";
        // 创建临时字符串,好加以判断一串字符是否存在相同格式
        if (it.hasNext()) {
            readTable(it, rangetbl);
        }
        int cur = 0;

        String tempString = "";
        for (int i = 0; i < length - 1; i++) {
            // 整篇文章的字符通过一个个字符的来判断,range为得到文档的范围
            Range range = new Range(i, i + 1, doc);
            CharacterRun cr = range.getCharacterRun(0);
            if (tblExist) {
                if (i == beginArray[cur]) {
                    htmlText += tempString + htmlTextArray[cur];
                    tempString = "";
                    i = endArray[cur] - 1;
                    cur++;
                    continue;
                }
            }
            if (pTable.hasPicture(cr)) {
                htmlText += tempString;
                // 读写图片
                readPicture(pTable, cr);
                tempString = "";
            } else {

                Range range2 = new Range(i + 1, i + 2, doc);
                // 第二个字符
                CharacterRun cr2 = range2.getCharacterRun(0);
                char c = cr.text().charAt(0);

                System.out.println(i + "::" + range.getEndOffset() + "::"
                        + range.getStartOffset() + "::" + c);

                // 判断是否为回车符
                if (c == ENTER_ASCII) {
                    tempString += "<br/>";

                }
                // 判断是否为空格符
                else if (c == SPACE_ASCII)
                    tempString += " ";
                // 判断是否为水平制表符
                else if (c == TABULATION_ASCII)
                    tempString += "    ";
                // 比较前后2个字符是否具有相同的格式
                boolean flag = compareCharStyle(cr, cr2);
                if (flag)
                    tempString += cr.text();
                else {
                    String fontStyle = "<span style='font-family:' + cr.getFontName() + ';font-size:' + cr.getFontSize() / 2 + ";

                    if (cr.isBold())
                        fontStyle += "font-weight:bold;";
                    if (cr.isItalic())
                        fontStyle += "font-style:italic;";

                    htmlText += fontStyle;

                    if (cr.isBold())
                        fontStyle += "font-weight:bold;";
                    if (cr.isItalic())
                        fontStyle += "font-style:italic;";

                    htmlText += fontStyle;
                    tempString = "";
                }
            }
        }

        htmlText += tempString + "</body></html>";
        writeFile(htmlText);
    }

    /**
     * 读写文档中的表格
     * 
     * @param pTable
     * @param cr
     * @throws Exception
     */
    public static void readTable(TableIterator it, Range rangetbl)
            throws Exception {
        htmlTextTbl = "";
        // 迭代文档中的表格
        counter = -1;
        while (it.hasNext()) {
            tblExist = true;
            htmlTextTbl = "";
            Table tb = (Table) it.next();
            beginPosi = tb.getStartOffset();
            endPosi = tb.getEndOffset();
            counter = counter + 1;
            // 迭代行，默认从0开始
            beginArray[counter] = beginPosi;
            endArray[counter] = endPosi;
            htmlTextTbl += "<table border>";
            for (int i = 0; i < tb.numRows(); i++) {
                TableRow tr = tb.getRow(i);

                htmlTextTbl += "<tr>";
                // 迭代列，默认从0开始
                for (int j = 0; j < tr.numCells(); j++) {
                    TableCell td = tr.getCell(j);// 取得单元格
                    int cellWidth = td.getWidth();

                    // 取得单元格的内容
                    for (int k = 0; k < td.numParagraphs(); k++) {
                        Paragraph para = td.getParagraph(k);
                        String s = para.text().toString().trim();
                        if (s == "") {
                            s = " ";
                        }
                        htmlTextTbl += "<td width=" + cellWidth + ">" + s
                                + "</td>";
                    }
                }
            }
            htmlTextTbl += "</table>";
            htmlTextArray[counter] = htmlTextTbl;
        }
    }

    /**
     * 读写文档中的图片
     * 
     * @param pTable
     * @param cr
     * @throws Exception
     */
    public static void readPicture(PicturesTable pTable, CharacterRun cr)
            throws Exception {
        // 提取图片
        Picture pic = pTable.extractPicture(cr, false);
        // 返回POI建议的图片文件名
        String afileName = pic.suggestFullFileName();
        File file = null;
        if (StringUtilx.isNotEmpty(afileName)) {
            file = new File("c://test" + File.separator + afileName);
        }
        if (file != null) {
            if (!file.exists()) {
                file.createNewFile();
            }
            OutputStream out = new FileOutputStream(file);
            pic.writeImageContent(out);
            htmlText += "<img src=''/>";
        }

    }

    public static boolean compareCharStyle(CharacterRun cr1, CharacterRun cr2) {
        boolean flag = false;
        if (cr1.isBold() == cr2.isBold() && cr1.isItalic() == cr2.isItalic()
                && cr1.getFontName().equals(cr2.getFontName())
                && cr1.getFontSize() == cr2.getFontSize()) {
            flag = true;
        }
        return flag;
    }

    /**
     * 写文件
     * 
     * @param s
     */
    
    public static void writeFile(String s) {
        FileOutputStream fos = null;
        BufferedWriter bw = null;
        try {
            File file = new File("c://abc.html");
            fos = new FileOutputStream(file);
            bw = new BufferedWriter(new OutputStreamWriter(fos));
            bw.write(s);
        } catch (FileNotFoundException fnfe) {
            fnfe.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        } finally {
            try {
                if (bw != null)
                    bw.close();
                if (fos != null)
                    fos.close();
            } catch (IOException ie) {
            }
        }
    }

}
```



