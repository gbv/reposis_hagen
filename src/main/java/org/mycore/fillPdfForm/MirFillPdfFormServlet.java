package org.mycore.fillPdfForm;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.interactive.form.PDAcroForm;
import org.apache.pdfbox.pdmodel.interactive.form.PDField;
import org.apache.pdfbox.pdmodel.interactive.form.PDXFAResource;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.filter.Filters;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;

import org.mycore.frontend.servlets.MCRServlet;
import org.mycore.frontend.servlets.MCRServletJob;

public class MirFillPdfFormServlet extends MCRServlet {

    private static final Logger LOGGER = LogManager.getLogger();

    private static final String FILENAME = "Einverstaendniserklaerung.pdf";

    @Override
    public void doGetPost(final MCRServletJob job) throws Exception {
        HttpServletRequest req = job.getRequest();
        HttpServletResponse res = job.getResponse();

        Document xfdf = (Document) req.getAttribute("MCRXEditorSubmission");
        if (xfdf == null) {
            throw new IllegalArgumentException("No XFDF submission found (MCRXEditorSubmission missing).");
        }

        try (InputStream input = getServletContext().getResourceAsStream("/pdfform/" + FILENAME)) {
            if (input == null) {
                throw new FileNotFoundException("PDF template not found.");
            }
            try (PDDocument pdfDocument = Loader.loadPDF(input.readAllBytes())) {
                fillPdfForm(pdfDocument, xfdf);
                res.setContentType("application/pdf");
                res.setHeader(
                    "Content-Disposition",
                    "attachment; filename=\"" + FILENAME + "\""
                );
                pdfDocument.save(res.getOutputStream());
            }
        }
    }

    private void fillPdfForm(PDDocument pdfDocument, Document xfdf) throws Exception {
        PDDocumentCatalog docCatalog = pdfDocument.getDocumentCatalog();
        PDAcroForm acroForm = docCatalog.getAcroForm();
        if (acroForm == null) {
            throw new IllegalStateException("PDF contains no AcroForm.");
        }
        PDXFAResource xfa = acroForm.getXFA();
        if (xfa != null) {
            LOGGER.warn("PDF document contains XFA - XFA is not supported.");
        }

        XPathFactory xFactory = XPathFactory.instance();
        XPathExpression<Element> expr = xFactory.compile("//field", Filters.element());

        List<Element> fields = expr.evaluate(xfdf);
        for (Element field : fields) {
            String fieldName = field.getAttributeValue("name");
            if (fieldName == null) {
                continue;
            }
            Element valueElement = field.getChild("value");
            String value = valueElement != null ? valueElement.getValue() : "";
            PDField formField = acroForm.getField(fieldName);
            if (formField != null) {
                try {
                    formField.setValue(value);
                } catch (Exception e) {
                    LOGGER.warn("Could not set PDF field {} to '{}'", fieldName, value, e);
                }
            } else {
                LOGGER.info("Field {} not found in PDF.", fieldName);
            }
        }
    }
}
