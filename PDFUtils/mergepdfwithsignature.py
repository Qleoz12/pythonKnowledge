import PyPDF2

def replace_pdf_page(input_pdf, output_pdf, source_page_number, target_page_number):
    with open(input_pdf, 'rb') as file:
        reader = PyPDF2.PdfFileReader(file)
        writer = PyPDF2.PdfFileWriter()

        # Add pages from the input PDF to the writer, except the page to be replaced
        for page_num in range(reader.numPages):
            if page_num != (source_page_number - 1):
                page = reader.getPage(page_num)
                writer.addPage(page)

        # Get the page from the source PDF to be replaced
        with open(output_pdf, 'rb') as source_file:
            source_reader = PyPDF2.PdfFileReader(source_file)
            source_page = source_reader.getPage(target_page_number - 1)

            # Insert the source page into the writer at the desired position
            writer.insertPage(source_page_number - 1, source_page)

        # Write the modified PDF to the output file
        with open('output.pdf', 'wb') as output_file:
            writer.write(output_file)

if __name__ == "__main__":
    input_pdf = 'original.pdf'  # Original PDF
    output_pdf = 'replacement.pdf'  # PDF with replacement page
    source_page_number = 1  # Page number of the page to be replaced
    target_page_number = 2  # Page number where the replacement page should be inserted

    replace_pdf_page(input_pdf, output_pdf, source_page_number, target_page_number)
    print(f"Page {source_page_number} replaced with page {target_page_number} successfully.")
