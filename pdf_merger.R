# ==========================================
# Script Name: PDF Standardiser & Merger
# Description: Combines all PDFs in a directory and standardises formatting.
#              Optional: Support for removing specific pages.
# Date: 2026-02-24
# Dependencies: pdftools, qpdf
# License: MIT
# ==========================================

# Load required libraries
if (!require("pdftools")) install.packages("pdftools")
if (!require("qpdf")) install.packages("qpdf")

library(pdftools)
library(qpdf)

# --- Configuration ---
input_dir <- getwd() 
output_filename <- "Standardised_Combined.pdf"
temp_folder_name <- "temp_processing_dir"

output_final  <- file.path(input_dir, output_filename)
temp_dir      <- file.path(input_dir, temp_folder_name)

# --- File Preparation ---
files <- list.files(path = input_dir, pattern = "(?i)\\.pdf$", full.names = TRUE)

# Exclude existing output files to prevent recursion
files <- files[!grepl(output_filename, files)]
files <- sort(files)

if (length(files) == 0) {
  stop("No PDF files found in the directory: ", input_dir)
}

# --- Processing & Standardisation ---
if (!dir.exists(temp_dir)) dir.create(temp_dir)
standardised_list <- c()

message("Processing ", length(files), " files...")

for (i in seq_along(files)) {
  out_path <- file.path(temp_dir, paste0("std_", i, ".pdf"))
  
  # Standardising each file by subsetting all its pages
  n_pages <- pdf_info(files[i])$pages
  pdf_subset(files[i], pages = 1:n_pages, output = out_path)
  
  standardised_list <- c(standardised_list, out_path)
}

# Combine all processed files directly to final output
pdf_combine(standardised_list, output = output_final)

# --- Optional: Custom Modification ---
# To remove a specific page (e.g., page 3), uncomment the lines below:
# ------------------------------------------------------------------
# page_to_remove <- 3
# total_pages <- pdf_info(output_final)$pages
# if (total_pages >= page_to_remove) {
#   pages_to_keep <- setdiff(1:total_pages, page_to_remove)
#   # Overwrite the file with the subset
#   pdf_subset(output_final, pages = pages_to_keep, output = "temp_final_subset.pdf")
#   file.rename("temp_final_subset.pdf", output_final)
#   message("Success! Page ", page_to_remove, " removed.")
# }
# ------------------------------------------------------------------

# --- Cleanup ---
# Removes the temporary processing folder
unlink(temp_dir, recursive = TRUE)

message("Final merged file saved at: ", output_final)
