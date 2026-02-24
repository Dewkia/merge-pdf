# PDF Standardiser & Merger

A lightweight and quick R script for merging multiple PDF files, standardising their format, and removing specific unwanted pages (e.g., generic covers or blank pages).

## **Key Features**
* **Batch Processing:** Automatically detects and sorts all `.pdf` files in the working directory.
* **Standardisation:** Re-processes pages via `qpdf` to ensure the final merged document is stable and corruption-free.
* **Page Extraction:** Easily exclude specific pages from the final output (e.g., "Remove page 3").
* **Automatic Cleanup:** Temporary folders and intermediate files are deleted automatically after execution.

## **Prerequisites**
Ensure you have **R** installed. You will also need to install the following libraries within your R console:

```r
install.packages("pdftools")
install.packages("qpdf")
```

## **Quick Start**
* Clone or Download this repository to your local machine.
* Place all the PDF files you wish to merge into the same folder as the script.
* Currently, the script does not allow sorting. You can add numbers in file names to force ranking your files first.
* Open `pdf_merger.R` in RStudio or your preferred editor.
* (Optional) Edit the `page_to_remove` variable if you need to delete a specific page (default is set to page 3).
* Execute the script.
* Your merged file will appear as `Standardised_Combined.pdf` in the same directory.
