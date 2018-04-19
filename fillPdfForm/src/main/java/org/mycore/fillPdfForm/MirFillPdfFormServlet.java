/*
 * $Id: MirFillPdfFormServlet.java 32236 2015-06-31 10:52:41Z mcrpabor $
 * $Revision: 32236 $ $Date: 2015-06-31 12:52:41 +0200 (Di, 31 Mär 2015) $
 *
 * This file is part of ***  M y C o R e  ***
 * See http://www.mycore.de/ for details.
 *
 * This program is free software; you can use it, redistribute it
 * and / or modify it under the terms of the GNU General Public License
 * (GPL) as published by the Free Software Foundation; either version 2
 * of the License or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program, in a file called gpl.txt or license.txt.
 * If not, write to the Free Software Foundation Inc.,
 * 59 Temple Place - Suite 330, Boston, MA  02111-1307 USA
 */
package org.mycore.fillPdfForm;

import java.text.MessageFormat;
import java.util.List;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.jdom2.Element;
import org.jdom2.output.DOMOutputter;
import org.jdom2.output.Format;
import org.jdom2.filter.Filters;
import org.jdom2.input.SAXBuilder;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;
import org.mycore.common.MCRMailer;
import org.mycore.common.MCRUtils;
import org.mycore.common.config.MCRConfiguration;
import org.mycore.common.content.MCRJDOMContent;
import org.mycore.frontend.MCRFrontendUtil;
import org.mycore.frontend.servlets.MCRServlet;
import org.mycore.frontend.servlets.MCRServletJob;
import org.mycore.services.i18n.MCRTranslation;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.fdf.FDFDocument;
import org.apache.pdfbox.pdmodel.interactive.form.PDAcroForm;
import org.apache.pdfbox.pdmodel.interactive.form.PDField;
import java.net.MalformedURLException;
import java.net.URL;
import org.apache.pdfbox.pdmodel.interactive.form.PDVariableText;

import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.SAXException;
import org.jdom2.output.XMLOutputter;
import org.apache.pdfbox.pdmodel.interactive.form.PDXFAResource;
import org.apache.pdfbox.pdmodel.interactive.action.PDActionJavaScript;

//remove later
import org.jdom2.input.SAXBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.xml.sax.InputSource;


/**
 * @author Paul Borchert 
 *
 */
public class MirFillPdfFormServlet extends MCRServlet {

    private static final Logger LOGGER = Logger.getLogger(MirFillPdfFormServlet.class);

    private static PDDocument _pdfDocument;
    
    
    public void doGetPost(final MCRServletJob job) throws Exception {
        final HttpServletRequest req = job.getRequest();
        final HttpServletResponse res = job.getResponse();
        
        org.jdom2.Document xfdf = (org.jdom2.Document) (req.getAttribute("MCRXEditorSubmission"));
        //TO DO test for valid xfdf
        
        String pdfPath=MCRFrontendUtil.getBaseURL()+"pdfform/Einverstaendniserklaerung.pdf";
        // TO DO read pdfPath from xfdf
        
        _pdfDocument = new PDDocument();
        try {
        	InputStream input = new URL(pdfPath).openStream();
        	_pdfDocument = PDDocument.load (input);
        	fillPdfForm (xfdf);
        	res.setContentType("application/pdf");
        	res.addHeader("Content-Disposition", "attachment; filename=\"Einverständiserklärung.pdf\"");
        	_pdfDocument.save(res.getOutputStream());
            _pdfDocument.close();
        } finally {
        	_pdfDocument.close();  
        }
    }
    
    /* OLD Version this is the backup
     * 
     * 
     */
    
    /*
     private void fillPdfForm(String pdfFormular,String xml) throws IOException {
        FDFDocument fdfdoc = new FDFDocument(xfdf);
    	 	
    	FDFDocument fdfdoc = FDFDocument.loadXFDF(new   ByteArrayInputStream(
        		xml.getBytes("UTF-8")));
        acroForm.importFDF(fdfdoc);
	
	    PDActionJavaScript javascript = new PDActionJavaScript(_javascript);
	    PDActionJavaScript javascript = new PDActionJavaScript(
				"c1 = color.blue, c2 = color.yellow; "
			    +"for (i = 0; i < this.numFields; i += 1) {"
			    +"  f_name = this.getNthFieldName(i);"
			    +"  f = this.getField(f_name);"
			    +"  switch (f.type) {"
			    +"    case 'button'    : break;  "
			    +"    case 'signature' : break;  "
			    +"    default :"
			    +"      fp = this.getField(f_name).page;"
			    +"      nWidgets = (typeof fp === 'number') ? 1 : fp.length;"
			    +"      for (j = 0; j < nWidgets; j += 1) {"
			    +"        fw = this.getField(f_name + '.' + j);"
			    +"        cc = fw.strokeColor;"
			    +"        fw.strokeColor = color.equal(cc, c1) ? c2 : c1;"
			    +"        fw.strokeColor = cc;"
			    +"      }"
			    +"      break;"
			    +"  }"
			    +"}"
			);
	     docCatalog.setOpenAction(javascript);
	
     }
    */
    
    private void fillPdfForm(org.jdom2.Document xfdf) throws IOException,ParserConfigurationException,SAXException {
    	
    	PDDocumentCatalog docCatalog = _pdfDocument.getDocumentCatalog();
    	PDAcroForm acroForm = docCatalog.getAcroForm();
    	
    	PDXFAResource xfa = acroForm.getXFA();
    	if (xfa != null) {
    		LOGGER.warn("PDF Dokument contains XFA - XFA is not supported");
    	} 
    	
    	XPathFactory xFactory = XPathFactory.instance();
        XPathExpression<Element> expr = xFactory.compile("//field", Filters.element());
        
        List<Element> fields = expr.evaluate(xfdf);
        
        PDField formField;
        
        for (Element field : fields) {
        	formField = acroForm.getField(field.getAttribute("name").getValue());
        	if (formField != null) { 
        	    formField.setValue(field.getChild("value").getValue());
        	} else {
        		LOGGER.info("Couldn't find the field " + field.getAttribute("name").getValue() + " in the PDF Dokumente");
        	}
        }
    }
    
}
